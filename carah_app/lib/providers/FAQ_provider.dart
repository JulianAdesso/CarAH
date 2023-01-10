import 'dart:convert';
import 'package:carah_app/model/list_faq_item.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import '../model/faq_question.dart';

class QuestionsProvider extends ChangeNotifier {

  List<ListFAQItem> _questions= [];

  Question? currentQuestion;
  String? lastArticleID;

  List<ListFAQItem> get questions=> _questions;

  List<Image> images = [];

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  fetchDataByCategory(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var questionsFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$id/children'),
          headers: {
            "Content-Type": "application/json",
          });
      _questions =
          jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes))['data']
              .map<ListFAQItem>((element) {
            return ListFAQItem.fromJson(element);
          }).toList();
      _questions.removeWhere((element) => element.title == ""); //The "Article Images" Folder has been loaded without title
      _offlineBox.put("questions", _questions);
    } else {
      _questions = _offlineBox.get("faqs").cast<ListFAQItem>();
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
                '$_baseURL/nodes/$id'),
            headers: {
              "Content-Type": "application/json",
            });
        currentQuestion = Question.fromJson(
            jsonDecode(utf8.decoder.convert(questionsFromCMS.bodyBytes)));
        _offlineBox.put(id, currentQuestion);
      } else {
        currentQuestion = _offlineBox.get(id);
      }
      if(currentQuestion!.imageId != null) {
        getImagesByUUID(currentQuestion!.imageId!);
      } else {
        images = [];
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
                '$_baseURL/nodes/$id/binary/image'),
            headers: {
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
}