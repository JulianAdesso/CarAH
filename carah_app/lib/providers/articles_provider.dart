import 'dart:convert';
import 'dart:typed_data';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/settings_provider.dart';
import 'package:connectivity/connectivity.dart';
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
  List<String> favorites = [];
  List<Image> showingImages = [];

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  ArticlesProvider({required this.categoryProvider, required this.settingsProvider}) {
   settingsProvider.getSettingsOfUser();
  }

  ArticlesProvider update(CategoryProvider categoryProvider, SettingsProvider settingsProvider) {
    this.categoryProvider = categoryProvider;
    this.settingsProvider = settingsProvider;
    return this;
  }

  @override
  Future <void> fetchDataByCategory(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS =
          await http.get(Uri.parse('$_baseURL/nodes/$id/children'), headers: {
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
      items = _offlineBox.get("articles").cast<Article>();
    }
    favorites = _offlineBox.get('favorites') ?? favorites;
    for (var item in items as List<Article>) {
      if (favorites.contains(item.uuid)) {
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
            await http.get(Uri.parse('$_baseURL/nodes/$id'), headers: {
          "Content-Type": "application/json",
        });
        currentArticle = Article.fromJson(
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
      } else {
        currentArticle = _offlineBox.get("articles").cast<Article>().where((element) => element.uuid == id).toList().first;
      }
      if (currentArticle!.imageId != null) {
        getImagesByUUID(currentArticle!.imageId!);
      } else {
        images = {};
      }
      favorites = _offlineBox.get('favorites') ?? favorites;
      if (currentArticle != null && favorites.contains(currentArticle!.uuid)) {
        currentArticle!.saved = true;
      } else {
        currentArticle!.saved = false;
      }
      var savedArticles = _offlineBox.get('articles') ?? [];
        if (savedArticles.any((element) => element.uuid == currentArticle!.uuid)) {
          currentArticle!.downloaded = true;
        }
      notifyListeners();
    }
  }

  getImagesByUUID(List<String> ids) async {
    if(!settingsProvider.userSettings!.dataSaveMode) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      Map<String, Uint8List> tmpImages = {};
      for (var id in ids) {
        id = id.replaceAll('{uuid: ', '');
        id = id.replaceAll('}', '');
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi &&
                !_offlineBox.containsKey(id)) {
          var message = await http
              .get(Uri.parse('$_baseURL/nodes/$id/binary/image'), headers: {
            "Content-Type": "application/json",
          });
          tmpImages.putIfAbsent(id, () => message.bodyBytes);
          images = tmpImages;
          showingImages.add(Image.memory(message.bodyBytes));
        } else {
          tmpImages.putIfAbsent(id, () => _offlineBox.get(id));
          images = tmpImages;
          showingImages.add(Image.memory(_offlineBox.get(id)));
        }
      }
    }
    notifyListeners();
  }

  @override
  setFavorite(String id, bool val) {
    items[items.indexWhere((Article art) => art.uuid == id)]
        .saved = val;
    if (currentArticle != null && currentArticle!.uuid == id) {
      currentArticle!.saved = val;
    }
    if (val) {
      favorites.add(id);
    } else {
      if (favorites.isNotEmpty && favorites.contains(id)) {
        favorites.remove(id);
      }
    }
    _offlineBox.put('favorites', favorites);
    notifyListeners();
  }

  Future<bool> downloadArticle(Article article, String categoryUUID) async {
    List<Article>? articles =  await _offlineBox.get("articles")?.cast<Article>();
    articles ??= [];
    if (!articles.any((element) => element.uuid == article.uuid)) {
      await categoryProvider.downloadCategory(categoryUUID);
      if(!settingsProvider.userSettings!.dataSaveMode) {
        images.forEach((key, val) {
          _offlineBox.put(key, val);
        });
      }
      articles.add(article);
      await _offlineBox.put("articles", articles);
    }
    return true;
  }
}
