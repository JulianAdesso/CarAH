import 'dart:convert';
import 'dart:typed_data';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/settings_provider.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';
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
  Future<void> fetchDataByCategory(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS =
          await http.get(Uri.parse('$baseUrl/nodes/$id/children'), headers: {
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
      items = _offlineBox.get("articles_$id")?.cast<Article>();
    }
    _favorites = _offlineBox.get('favorites') ?? _favorites;
    for (var item in items as List<Article>) {
      if (_favorites.contains(item.uuid)) {
        item.saved = true;
      }
    }
    notifyListeners();
  }

  Future<void> getArticleByUUID(String id) async {
    if (id != currentArticle?.uuid) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var articlesFromCMS =
            await http.get(Uri.parse('$baseUrl/nodes/$id'), headers: {
          "Content-Type": "application/json",
        });
        currentArticle = Article.fromJson(
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
      } else {
        currentArticle = _offlineBox
            .get("articles_$id")
            .cast<Article>()
            .where((element) => element.uuid == id)
            .toList()
            .first;
      }
      if (currentArticle!.imageId != null) {
        await getImagesByUUID(currentArticle!.imageId!);
      } else {
        images = {};
      }
      _favorites = _offlineBox.get('favorites') ?? _favorites;
      if (currentArticle != null && _favorites.contains(currentArticle!.uuid)) {
        currentArticle!.saved = true;
      } else {
        currentArticle!.saved = false;
      }
      var savedArticles = _offlineBox.get('articles_$id') ?? [];
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

  getImagesByUUID(List<String> ids) async {
    images = {};
    showingImages = [];
    if (!settingsProvider.userSettings!.dataSaveMode) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      for (var id in ids) {
        id = id.replaceAll('{uuid: ', '');
        id = id.replaceAll('}', '');
        if ((connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) &&
            !_offlineBox.containsKey(id)) {
          var message = await http
              .get(Uri.parse('$baseUrl/nodes/$id/binary/image'), headers: {
            "Content-Type": "application/json",
          });
          images.putIfAbsent(id, () => message.bodyBytes);
          showingImages.add(Image.memory(message.bodyBytes));
        } else {
          images.putIfAbsent(id, () => _offlineBox.get(id));
          showingImages.add(Image.memory(_offlineBox.get(id)));
        }
      }
    }
    notifyListeners();
  }

  @override
  setFavorite(String id, bool val) {
    if (items != null && items.isNotEmpty) {
      items[items.indexWhere((Article art) => art.uuid == id)].saved = val;
    }
    if (currentArticle != null && currentArticle!.uuid == id) {
      currentArticle!.saved = val;
    }
    if (val && !_favorites.contains(id)) {
      _favorites.add(id);
    } else {
      if (_favorites.isNotEmpty && _favorites.contains(id)) {
        _favorites.remove(id);
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
    List<Article> articles = await _offlineBox.get("articles_${toBeRemoved.category}")?.cast<Article>();
    articles.removeWhere((element) => element.uuid == toBeRemoved.uuid);
    await _offlineBox.put("articles_${toBeRemoved.category}", articles);
    if(!articles.any((element) => element.category == toBeRemoved.category)) {
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
    Article? tmpArticle = currentArticle;
    List<Article> favoriteArticles = [];
    for (var fav in _favorites) {
      await getArticleByUUID(fav);
      if (currentArticle != null) {
        favoriteArticles.add(currentArticle!);
      }
    }
    currentArticle = tmpArticle;
    return favoriteArticles;
  }
}
