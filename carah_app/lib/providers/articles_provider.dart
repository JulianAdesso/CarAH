import 'dart:convert';
import 'dart:typed_data';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/settings_provider.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';
import '../model/lightContent.dart';
import 'category_provider.dart';

class ArticlesProvider extends ContentProvider<Article> {
  CategoryProvider categoryProvider;
  SettingsProvider settingsProvider;
  Article? currentArticle;

  Map<String, Uint8List> images = {};
  List<String> _favorites = [];
  List<Image> showingImages = [];

  final _offlineBox = Hive.box('myBox');

  ArticlesProvider(
      {required this.categoryProvider, required this.settingsProvider}) {
    settingsProvider.getSettingsOfUser();
  }

  ArticlesProvider update(
      CategoryProvider categoryProvider, SettingsProvider settingsProvider) {
    this.categoryProvider = categoryProvider;
    this.settingsProvider = settingsProvider;
    return this;
  }

  @override
  fetchLightDataByCategory(String uuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var questionsFromCMS = await http.post(
        Uri.parse('$baseUrl/graphql'),
        headers: {
          "Content-Type": "application/json",
        },
        body:
            '''{"query":"        {\\r\\n          node(uuid: \\"$uuid\\") \\r\\n          {\\r\\n              children(filter: {\\r\\n    }   \\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                    schema {\\r\\n                        uuid\\r\\n                    }\\r\\n                    \\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
      );
      lightItems =
          jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes))['data']
                  ['node']['children']['elements']
              .map<LightContent>((element) {
        return LightContent.fromJson(element);
      }).toList();
      lightItems.removeWhere((element) =>
          element.category ==
          "066e4aa01dc14ad6a8951e789c719bf6"); //Remove all image folders
    } else {
      items = _offlineBox.get("articles_$uuid")?.cast<Article>();
      lightItems.clear();
      for(Article tmpItem in items) {
        LightContent tmpLightContent = LightContent(uuid: tmpItem.uuid, title: tmpItem.title, content: "", category: tmpItem.category);
        lightItems.add(tmpLightContent);
      }
    }
    _favorites = _offlineBox.get('favorites') ?? _favorites;
    for (var tmpLightItem in lightItems as List<LightContent>) {
      if (_favorites.contains(tmpLightItem.uuid)) {
        tmpLightItem.saved = true;
      }
    }
    notifyListeners();
  }

  @override
  Future<void> fetchDataByCategory(String uuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS =
          await http.get(Uri.parse('$baseUrl/nodes/$uuid/children'), headers: {
        "Content-Type": "application/json",
      });
      items =
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
              .map<Article>((element) {
        return Article.fromJson(element);
      }).toList();
      items.removeWhere((element) =>
          element.title ==
          ""); //The "Article Images" Folder has been loaded without title
    } else {
      items = _offlineBox.get("articles_$uuid")?.cast<Article>();
    }
    _favorites = _offlineBox.get('favorites') ?? _favorites;
    for (var item in items as List<Article>) {
      if (_favorites.contains(item.uuid)) {
        item.saved = true;
      }
    }
    notifyListeners();
  }

  Future<void> getArticleByUUID(String uuid, String categoryId) async {
    if (uuid != currentArticle?.uuid) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var articlesFromCMS =
            await http.get(Uri.parse('$baseUrl/nodes/$uuid'), headers: {
          "Content-Type": "application/json",
        });
        currentArticle = Article.fromJson(
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
      } else {
        currentArticle = _offlineBox
            .get("articles_$categoryId")
            .cast<Article>()
            .firstWhere((element) => element.uuid == uuid);
      }
      if (currentArticle!.imageId != null) {
        await getImagesByUUID(currentArticle!.imageId!);
      } else {
        images = {};
        showingImages = [];
      }
      _favorites = _offlineBox.get('favorites') ?? _favorites;
      if (currentArticle != null && _favorites.contains(currentArticle!.uuid)) {
        currentArticle!.saved = true;
      } else {
        currentArticle!.saved = false;
      }
      var savedArticles = _offlineBox.get('articles_$categoryId') ?? [];
      if (savedArticles
          .any((element) => element.uuid == currentArticle!.uuid)) {
        currentArticle!.downloaded = true;
      }
      notifyListeners();
    }
  }

  Future<void> getImprint() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS = await http.get(
          Uri.parse('$baseUrl/nodes/1839c4d1daf246829fcb0da11b085b59'),
          headers: {
            "Content-Type": "application/json",
          });
      currentArticle = Article.fromJson(
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
      _offlineBox.put('imprint', currentArticle);
    } else {
      currentArticle = _offlineBox.get("imprint").cast<Article>();
    }
    if (currentArticle!.imageId != null) {
      await getImagesByUUID(currentArticle!.imageId!);
    } else {
      images = {};
    }
    notifyListeners();
  }

  getImagesByUUID(List<String> uuids) async {
    images = {};
    showingImages = [];
    if (!settingsProvider.userSettings!.dataSaveMode) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      for (var uuid in uuids) {
        uuid = uuid.replaceAll('{uuid: ', '');
        uuid = uuid.replaceAll('}', '');
        if ((connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) &&
            !_offlineBox.containsKey(uuid)) {
          var message = await http
              .get(Uri.parse('$baseUrl/nodes/$uuid/binary/image'), headers: {
            "Content-Type": "application/json",
          });
          images.putIfAbsent(uuid, () => message.bodyBytes);
          showingImages.add(Image.memory(message.bodyBytes));
        } else {
          images.putIfAbsent(uuid, () => _offlineBox.get(uuid));
          showingImages.add(Image.memory(_offlineBox.get(uuid)));
        }
      }
    }
    notifyListeners();
  }

  @override
  setFavorite(String uuid, bool val) {
    if (lightItems != null && lightItems.isNotEmpty) {
      lightItems[lightItems.indexWhere((LightContent art) => art.uuid == uuid)].saved = val;
    }
    if (currentArticle != null && currentArticle!.uuid == uuid) {
      currentArticle!.saved = val;
    }
    if (val && !_favorites.contains(uuid)) {
      _favorites.add(uuid);
    } else {
      if (_favorites.isNotEmpty && _favorites.contains(uuid)) {
        _favorites.remove(uuid);
      }
    }
    _offlineBox.put('favorites', _favorites);
    notifyListeners();
  }

  Future<bool> downloadArticle(Article article, String categoryUUID) async {
    List<Article>? articles =
        await _offlineBox.get('articles_${article.category}')?.cast<Article>();
    articles ??= [];
    if (!articles.any((element) => element.uuid == article.uuid)) {
      await categoryProvider.downloadCategory(categoryUUID);
      if (!settingsProvider.userSettings!.dataSaveMode) {
        images.forEach((key, val) {
          _offlineBox.put(key, val);
        });
      }
      articles.add(article);
      await _offlineBox.put('articles_${article.category}', articles);
    }
    return true;
  }

  Future<bool> removeArticleFromDownloads(Article toBeRemoved) async {
    List<Article> articles = await _offlineBox
        .get("articles_${toBeRemoved.category}")
        ?.cast<Article>();
    articles.removeWhere((element) => element.uuid == toBeRemoved.uuid);
    await _offlineBox.put("articles_${toBeRemoved.category}", articles);
    if (!articles.any((element) => element.category == toBeRemoved.category)) {
      await categoryProvider.removeDownloadFromCategories(toBeRemoved.category);
    }
    notifyListeners();
    return true;
  }

  Future<List<Article>> fetchFavorites() async {
    _favorites = _offlineBox.get('favorites') ?? _favorites;
    if (_favorites.isEmpty) {
      return [];
    }
    List<Article> favoriteArticles = [];
    await categoryProvider.fetchAllCategories(
        "0a8e66b695f5410cac44b1a9531a7a2b", "articles_category");
    for (var cat in categoryProvider.categories) {
      await fetchDataByCategory(cat.uuid);
      for (var fav in _favorites) {
        if (items.any((element) => element.uuid == fav)) {
          favoriteArticles
              .add(items.firstWhere((element) => element.uuid == fav));
        }
      }
    }
    return favoriteArticles;
  }
}
