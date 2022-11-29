import 'dart:convert';

import 'package:carah_app/model/list_article_item.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import '../model/article.dart';

class ArticlesProvider extends ChangeNotifier{

  List<ListArticlesItem> _articles = [];

  Article? currentArticle;

  List<ListArticlesItem> get articles => _articles;

  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  fetchDataByCategory(String id) async {
    var articlesFromCMS = await http.get(
        Uri.parse(
            '$_baseURL/nodes/$id/children'),
        headers: {
          "Content-Type": "application/json",
        });
    _articles = jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data'].map<ListArticlesItem>((element) {
      return ListArticlesItem.fromJson(element);
    }).toList();
    notifyListeners();
  }

  getArticleByUUID(String id) async{
    var articlesFromCMS = await http.get(
        Uri.parse(
            '$_baseURL/nodes/$id'),
        headers: {
          "Content-Type": "application/json",
        });
    currentArticle = Article.fromJson(jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes)));
    notifyListeners();
  }


}