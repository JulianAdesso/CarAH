import 'dart:convert';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/faq_question.dart';
import 'content_provider.dart';

class QuestionsProvider extends ContentProvider<Question> {

  Question? currentQuestion;
  String? lastArticleID;


  final _offlineBox = Hive.box('myBox');

  @override
  fetchDataByCategory(String uuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var questionsFromCMS = await http.post(
        Uri.parse('$baseUrl/graphql'),
        headers: {
          "Content-Type": "application/json",
        },
        body: '''{"query":"        {\\r\\n          node(uuid: \\"$uuid\\") \\r\\n          {\\r\\n              children(filter: {\\r\\n    }   \\r\\n            ){\\r\\n                elements {\\r\\n                    uuid\\r\\n                    \\r\\n                    \\r\\n                    ... on Article {\\r\\n                         fields {\\r\\n                             Display_Name\\r\\n                             Html_Text\\r\\n                             }\\r\\n                             parent {\\r\\n                                 displayName\\r\\n                             }\\r\\n                    }\\r\\n\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }","variables":{}}''',
      );
      items =
          jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes))['data']['node']['children']['elements']
              .map<Question>((element) {
            return Question.fromJson(element);
          }).toList();
      items.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
    } else {
      items = _offlineBox.get("questions").cast<Question>();
    }
    notifyListeners();
  }

  getQuestionByUUID(String uuid) async {
    print(uuid);
    if(uuid != currentQuestion?.uuid) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var questionsFromCMS = await http.post(
          Uri.parse('$baseUrl/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body:  '''{"query":" {\\r\\n          node(uuid: \\"2679fe5c2c5641ea86fb37a0ff1fe032\\") {\\r\\n            uuid\\r\\n            ... on Article {\\r\\n                         fields {\\r\\n                             Html_Text\\r\\n                             Display_Name\\r\\n                             }\\r\\n                             parent {\\r\\n                                 displayName\\r\\n                             }\\r\\n                    }\\r\\n          }\\r\\n        }","variables":{}}''',
        );
        currentQuestion = Question.fromJson(
            jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes))['data']['node']);
        _offlineBox.put(uuid, currentQuestion);
      } else {
        currentQuestion = _offlineBox.get(uuid);
      }
      notifyListeners();
      lastArticleID = currentQuestion?.uuid;
    }
  }

}