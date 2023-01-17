import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';
import '../model/content.dart';

class ContentProvider<P extends Content> extends ChangeNotifier {

  List<P> _items = [];
  List<String> _allArticlesByUuid = [];
  List<String> _allQuestionsByUuid = [];

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';
  List<String> _allArticlesByUuid = [];
  List<String> _allQuestionsByUuid = [];

  List<Content> _AllContent = [];

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  get items => _items;
  get allArticlesUuid => _allArticlesByUuid;
  get allQuestionsUuid => _allQuestionsByUuid;

  set items(value) {
    _items = value;
  }

  fetchDataByCategory(String id) {
  }

  fetchAllContent () async {
    _items = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes'),
          headers: {
            "Content-Type": "application/json",
          });
      items =
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
              .map<Article>((element) {
            return Article.fromJson(element);
          }).toList();
      items.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
      _offlineBox.put("articles", items);
    } else {
      if(_offlineBox.get("questions") != null ||  _offlineBox.get("questions") != null) {
        var tmp1 = _offlineBox.get("questions").cast<Content>();
        var tmp2 = _offlineBox.get("articles").cast<Content>();
        _items.addAll(tmp1 as List<P>);
        _items.addAll(tmp2 as List<P>);
      var tmpArticlesUuid = _offlineBox.get("articles").cast<Content>();
      _allArticlesByUuid =   (tmpArticlesUuid as List<Content>).map((content) => (content.uuid.toString())).toList();
      var tmpQuestionUuid = _offlineBox.get("questions").cast<Content>();
      _allQuestionsByUuid =   (tmpQuestionUuid as List<Content>).map((content) => (content.uuid.toString())).toList();
      }
    }
    notifyListeners();
}
  fetchAllContent () async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes'),
          headers: {
            "Content-Type": "application/json",
          });
      items =
          jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
              .map<Article>((element) {
            return Article.fromJson(element);
          }).toList();
      items.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
      _offlineBox.put("articles", items);
    } else {
      //_items.clear();
      _items = _offlineBox.get("questions").cast<Content>();
      _items.addAll(_offlineBox.get("articles").cast<Content>());
      print(items.length);
      var tmpArticlesUuid = _offlineBox.get("articles").cast<Content>();
      _allArticlesByUuid =   (tmpArticlesUuid as List<Content>).map((content) => (content.uuid.toString())).toList();
      var tmpQuestionUuid = _offlineBox.get("questions").cast<Content>();
      _allQuestionsByUuid =   (tmpQuestionUuid as List<Content>).map((content) => (content.uuid.toString())).toList();

    }
    notifyListeners();
}
  setFavorite(String id, bool val) {}
}
