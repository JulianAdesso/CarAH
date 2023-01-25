import 'dart:convert';

import 'package:carah_app/model/category.dart';
import 'package:carah_app/model/searchArticle.dart';
import 'package:carah_app/providers/category_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/content.dart';



//final HttpLink httpLink = HttpLink("http://h2992008.stratoserver.net:8080/api/v2/CarAH");

String query =
  """
  query {
          {
            node(uuid: "0a8e66b695f5410cac44b1a9531a7a2b") {
              edited
            }
          }
        }
        """;
class ContentProvider<P extends Content> extends ChangeNotifier {

  List<P> _items = [];
  List<String> _allArticlesByUuid = [];
  List<String> _allQuestionsByUuid = [];
  List<SearchArticle> _allSearchArticlesList = [];

  CategoryProvider categoryProvider = CategoryProvider();

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
    List<String> categoryUuidList= [];
    await categoryProvider.fetchAllCategories("0a8e66b695f5410cac44b1a9531a7a2b", "articles_category");
    for(Category singleCategory in categoryProvider.categories) {
      categoryUuidList.add(singleCategory.uuid);
    }
    await categoryProvider.fetchAllCategories("b46628c6bc284debbd2ab8c76888a850", "faq_category");
    for(Category singleCategory in categoryProvider.categories) {
      categoryUuidList.add(singleCategory.uuid);
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var articlesFromCMS;
      List<Content> tmpItems = [];
      for(String categoryUuid in categoryUuidList) {

          articlesFromCMS = await http.post(Uri.parse(
              '$_baseURL/graphql'),
            headers: {
              "Content-Type": "application/json",
            },
            body:
            '''{"query":"        {\\r\\n          node(uuid: \\"''' + categoryUuid + '''\\") {\\r\\n              children(filter: {\\r\\n    }\\r\\n            ){\\r\\n                elements {\\r\\n                    displayName\\r\\n                    uuid\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
          );
        var categorySearchArticlesList =
            jsonDecode(utf8.decoder.convert(articlesFromCMS.bodyBytes))['data']['node']['children']['elements']
                .map<SearchArticle>((element) {
              return SearchArticle.fromJson(element);
            }).toList();
        tmpItems += categorySearchArticlesList;

      }
      items = tmpItems;
      items.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
      _allArticlesByUuid =   (items as List<Content>).map((content) => (content.uuid.toString())).toList();
    } else {
      print("offline");
        var tmp1 = _offlineBox.get("questions")?.cast<Content>();
        var tmp2 = _offlineBox.get("articles")?.cast<Content>();
        _items.addAll(tmp1 as List<P>);
        _items.addAll(tmp2 as List<P>);
      var tmpArticlesUuid = _offlineBox.get("articles").cast<Content>();
      _allArticlesByUuid =   (tmpArticlesUuid as List<Content>).map((content) => (content.uuid.toString())).toList();
      var tmpQuestionUuid = _offlineBox.get("questions").cast<Content>();
      _allQuestionsByUuid =   (tmpQuestionUuid as List<Content>).map((content) => (content.uuid.toString())).toList();

    }
    notifyListeners();
}
  setFavorite(String id, bool val) {}
}
