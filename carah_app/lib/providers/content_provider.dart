import 'dart:convert';

import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/lightContent.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/content.dart';

class ContentProvider<P extends Content> extends ChangeNotifier {
  List<P> _items = [];
  List<LightContent> _lightItems = [];

  CategoryProvider categoryProvider = CategoryProvider();

  final _offlineBox = Hive.box('myBox');

  get items => _items;
  get lightItems => _lightItems;

  set items(value) {
    _items = value;
  }

  set lightItems(value) {
    _lightItems = value;
  }

  fetchDataByCategory(String uuid) {}
  fetchLightDataByCategory(String uuid) {}
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
      List<LightContent> tmpArticleList = [];
      for (String categoryUuid in articlesUuidList) {
        articlesFromCMS = await http.post(
          Uri.parse('$baseUrl/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body:
              '''{"query":"        {\\r\\n          node(uuid: \\"$categoryUuid\\") {\\r\\n              children(filter: {\\r\\n    }\\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                    schema {uuid}\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
        );
        var categorySearchArticlesList =
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
                    ['node']['children']['elements']
                .map<LightContent>((element) {
          return LightContent.fromJson(element);
        }).toList();
        tmpArticleList += categorySearchArticlesList;
      }
      for (LightContent tmpArticle in tmpArticleList) {
        tmpArticle.contentType = ContentType.article;
      }
      //Remove all image folders
      tmpArticleList.removeWhere(
          (element) => element.category == "066e4aa01dc14ad6a8951e789c719bf6");
      _items.addAll(tmpArticleList as List<P>);
      List<LightContent> tmpQuestionList = [];
      List<String> questionsUuidList = [];
      await categoryProvider.fetchAllCategories(
          "b46628c6bc284debbd2ab8c76888a850", "faq_category");
      for (Category singleCategory in categoryProvider.categories) {
        questionsUuidList.add(singleCategory.uuid);
      }
      for (String categoryUuid in questionsUuidList) {
        articlesFromCMS = await http.post(
          Uri.parse('$baseUrl/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body:
              '''{"query":"        {\\r\\n          node(uuid: \\"$categoryUuid\\") {\\r\\n              children(filter: {\\r\\n    }\\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                    schema {uuid}\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
        );
        var categorySearchQuestionList =
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']
                    ['node']['children']['elements']
                .map<LightContent>((element) {
          return LightContent.fromJson(element);
        }).toList();
        tmpQuestionList += categorySearchQuestionList;
      }
      for (LightContent tmpQuestion in tmpQuestionList) {
        tmpQuestion.contentType = ContentType.question;
      }
      //Remove all image folders
      tmpQuestionList.removeWhere(
          (element) => element.category == "066e4aa01dc14ad6a8951e789c719bf6");
      _items.addAll(tmpQuestionList as List<P>);
    } else {
      await categoryProvider.fetchAllCategories(
          "0a8e66b695f5410cac44b1a9531a7a2b", "articles_category");
      var tmpArticlesList = [];
      for (var cat in categoryProvider.categories) {
        String tmpCategoryUuid = cat.uuid;
        if (_offlineBox.get("articles_$tmpCategoryUuid")?.cast<Content>() !=
            null) {
          tmpArticlesList +=
              _offlineBox.get("articles_$tmpCategoryUuid")?.cast<Content>();
        }
      }
      if (tmpArticlesList != null) {
        for (Content tmpArticle in tmpArticlesList) {
          LightContent tmpSearchContent = LightContent(
              uuid: tmpArticle.uuid,
              title: tmpArticle.title,
              content: "",
              category: tmpArticle.category);
          tmpSearchContent.contentType = ContentType.article;
          _items.add(tmpSearchContent as P);
        }
      }
      var tmpQuestionsList = _offlineBox.get("questions")?.cast<Content>();
      if (tmpQuestionsList != null) {
        for (Content tmpQuestion in tmpQuestionsList) {
          LightContent tmpSearchContent = LightContent(
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

  setFavorite(String uuid, bool val) {}
}
