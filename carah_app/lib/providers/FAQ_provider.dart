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
  fetchDataByCategory(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var questionsFromCMS = await http.get(
          Uri.parse(
              '$baseUrl/nodes/$id/children'),
          headers: {
            "Content-Type": "application/json",
          });
      items =
          jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes))['data']
              .map<Question>((element) {
            return Question.fromJson(element);
          }).toList();
      items.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
    } else {
      items = _offlineBox.get("questions").cast<Question>();
    }
    notifyListeners();
  }

  getQuestionByUUID(String id) async {
    if(id != currentQuestion?.uuid) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        var questionsFromCMS = await http.get(
            Uri.parse(
                '$baseUrl/nodes/$id'),
            headers: {
              "Content-Type": "application/json",
            });
        currentQuestion = Question.fromJson(
            jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes)));
        _offlineBox.put(id, currentQuestion);
      } else {
        currentQuestion = _offlineBox.get(id);
      }
      notifyListeners();
      lastArticleID = currentQuestion?.uuid;
    }
  }

  getImagesByUUID(List<String> ids) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<Image> tmpImages = [];
    for (var id in ids)  {
      id = id.replaceAll('{uuid: ', '');
      id = id.replaceAll('}', '');
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi && !_offlineBox.containsKey(id)) {
        var message = await http.get(
            Uri.parse(
                '$baseUrl/nodes/$id/binary/image'),
            headers: {
              "Content-Type": "application/json",
            });
        tmpImages.add(Image.memory(message.bodyBytes));
        images = tmpImages;
      } else {
        tmpImages.add(Image.memory(_offlineBox.get(id)));
        images = tmpImages;
      }
    }
  }

}