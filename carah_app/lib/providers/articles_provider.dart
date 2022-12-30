import 'dart:convert';
import 'package:carah_app/model/list_article_item.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';

class ArticlesProvider extends ChangeNotifier {

  List<ListArticlesItem> _articles = [];

  Article? currentArticle;

  List<ListArticlesItem> get articles => _articles;

  List<Image> images = [];
  Image? image;

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  fetchDataByCategory(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$id/children'),
          headers: {
            "Content-Type": "application/json",
          });
      _articles =
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
              .map<ListArticlesItem>((element) {
            return ListArticlesItem.fromJson(element);
          }).toList();
      _articles.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
      _offlineBox.put("articles", _articles);
    } else {
      _articles = _offlineBox.get("articles").cast<ListArticlesItem>();
    }
    notifyListeners();
  }

  getArticleByUUID(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$id'),
          headers: {
            "Content-Type": "application/json",
          });
      currentArticle = Article.fromJson(
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
      _offlineBox.put(id, currentArticle);
    } else {
      currentArticle = _offlineBox.get(id);
    }
    if(currentArticle!.imageId != null) {
      getImageByUUID(currentArticle!.imageId!.first);
      getImagesByUUID(currentArticle!.imageId!);
    } else {
      images = [];
      image = null;
    }
    notifyListeners();
  }

  getImageByUUID(String id) async {
    id = id.replaceAll('{uuid: ', '');
    id = id.replaceAll('}', '');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var message = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$id/binary/image'),
          headers: {
            "Content-Type": "application/json",
          });
      image = Image.memory(message.bodyBytes);
      _offlineBox.put(id, message.bodyBytes);
    } else {
      image = Image.memory(_offlineBox.get(id));
    }
  }

  getImagesByUUID(List<String> ids) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<Image> tmpImages = [];
    for (var id in ids)  {
      id = id.replaceAll('{uuid: ', '');
      id = id.replaceAll('}', '');
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var message = await http.get(
            Uri.parse(
                '$_baseURL/nodes/$id/binary/image'),
            headers: {
              "Content-Type": "application/json",
            });
        tmpImages.add(Image.memory(message.bodyBytes));
        _offlineBox.put(id, message.bodyBytes);
        image = Image.memory(message.bodyBytes);
        images = tmpImages;
      } else {
        tmpImages.add(Image.memory(_offlineBox.get(id)));
        images = tmpImages;
      }
    }
  }
}