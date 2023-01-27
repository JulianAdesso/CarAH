import 'dart:convert';

import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/searchContent.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/content.dart';

class ContentProvider<P extends Content> extends ChangeNotifier {
  List<P> _items = [];

  CategoryProvider categoryProvider = CategoryProvider();

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  get items => _items;

  set items(value) {
    _items = value;
  }

  fetchDataByCategory(String id) {}
  fetchAllContent() async {
    _items = [];
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      List<String> articlesUuidList = [];
      await categoryProvider.fetchAllCategories(
          "0a8e66b695f5410cac44b1a9531a7a2b", "articles_category");
      for (Category singleCategory in categoryProvider.categories) {
        articlesUuidList.add(singleCategory.uuid);
      }
      http.Response articlesFromCMS;
      List<SearchContent> tmpArticleList = [];
      for (String categoryUuid in articlesUuidList) {
        articlesFromCMS = await http.post(
          Uri.parse('$_baseURL/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body: '''{"query":"        {\\r\\n          node(uuid: \\"$categoryUuid\\") {\\r\\n              children(filter: {\\r\\n    }\\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
        );
        var categorySearchArticlesList =
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
                    ['node']['children']['elements']
                .map<SearchContent>((element) {
          return SearchContent.fromJson(element);
        }).toList();
        tmpArticleList += categorySearchArticlesList;
      }
      for (SearchContent tmpArticle in tmpArticleList) {
        tmpArticle.contentType = ContentType.article;
      }
      tmpArticleList.removeWhere((element) =>
          element.title ==
          ""); //ToDo: Die Bilder Objekte werden nicht rausgefiltert. Wir müssen sie irgendwie markieren
      _items.addAll(tmpArticleList as List<P>);
      List<SearchContent> tmpQuestionList = [];
      List<String> questionsUuidList = [];
      await categoryProvider.fetchAllCategories(
          "b46628c6bc284debbd2ab8c76888a850", "faq_category");
      for (Category singleCategory in categoryProvider.categories) {
        questionsUuidList.add(singleCategory.uuid);
      }
      for (String categoryUuid in questionsUuidList) {
        articlesFromCMS = await http.post(
          Uri.parse('$_baseURL/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body: '''{"query":"        {\\r\\n          node(uuid: \\"$categoryUuid\\") {\\r\\n              children(filter: {\\r\\n    }\\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
        );
        var categorySearchQuestionList =
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
                    ['node']['children']['elements']
                .map<SearchContent>((element) {
          return SearchContent.fromJson(element);
        }).toList();
        tmpQuestionList += categorySearchQuestionList;
      }
      for (SearchContent tmpQuestion in tmpQuestionList) {
        tmpQuestion.contentType = ContentType.question;
      }
      tmpQuestionList.removeWhere((element) =>
          element.title ==
          ""); //The "Article Images" Folder has been loaded without title
      _items.addAll(tmpQuestionList as List<P>);
    } else {
      var tmpArticlesList = _offlineBox?.get("articles")?.cast<Content>();
      if(tmpArticlesList != null) {
        for (Content tmpArticle in tmpArticlesList) {
          SearchContent tmpSearchContent = SearchContent(
              uuid: tmpArticle.uuid,
              title: tmpArticle.title,
              content: "",
              category: "");
          tmpSearchContent.contentType = ContentType.article;
          _items.add(tmpSearchContent as P);
        }
      }
      var tmpQuestionsList = _offlineBox?.get("questions")?.cast<Content>();
      if(tmpQuestionsList != null) {
        for (Content tmpQuestion in tmpQuestionsList) {
          SearchContent tmpSearchContent = SearchContent(
              uuid: tmpQuestion.uuid,
              title: tmpQuestion.title,
              content: "",
              category: "");
          tmpSearchContent.contentType = ContentType.question;
          _items.add(tmpSearchContent as P);
        }
      }
      notifyListeners();
    }
  }

  setFavorite(String id, bool val) {}
}
