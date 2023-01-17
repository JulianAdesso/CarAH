import 'dart:convert';
import 'package:carah_app/providers/content_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';

class ArticlesProvider extends ContentProvider<Article> {
  Article? currentArticle;
  String? lastArticleID;
  List<String> favorites = [];
  List<Image> images = [];

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  @override
  fetchDataByCategory(String id) async {
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
      _offlineBox.put("articles", items);
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

  getArticleByUUID(String id) async {
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
        _offlineBox.put(id, currentArticle);
      } else {
        currentArticle = _offlineBox.get(id);
      }
      if (currentArticle!.imageId != null) {
        getImagesByUUID(currentArticle!.imageId!);
      } else {
        images = [];
      }
      favorites = _offlineBox.get('favorites') ?? favorites;
      if (currentArticle != null && favorites.contains(currentArticle!.uuid)) {
        currentArticle!.saved = true;
      } else {
        currentArticle!.saved = false;
      }
      notifyListeners();
      lastArticleID = currentArticle?.uuid;
    }
  }

  getImagesByUUID(List<String> ids) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<Image> tmpImages = [];
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
        tmpImages.add(Image.memory(message.bodyBytes));
        _offlineBox.put(id, message.bodyBytes);
        images = tmpImages;
      } else {
        tmpImages.add(Image.memory(_offlineBox.get(id)));
        images = tmpImages;
      }
    }
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
}
