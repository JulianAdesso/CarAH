import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/faq_category.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import '../model/list_faq_item.dart';

class FAQCategoryProvider extends ChangeNotifier{

  List<FAQCategory> _categories = [];


  List<FAQCategory> get categories => _categories;

  List<ListFAQItem> _questions = [];

  List<ListFAQItem> get questions => _questions;
  //final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';
  final _baseUUID = 'b46628c6bc284debbd2ab8c76888a850';

  void fetchAllCategories() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var categoriesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$_baseUUID/children'),
          headers: {
            "Content-Type": "application/json",
          });
      _categories = jsonDecode(utf8.decoder.convert(categoriesFromCMS.bodyBytes))['data'].map<FAQCategory>((element) {
        return FAQCategory.fromJson(element);
      }).toList();
      //_offlineBox.put("faq_category", _categories);
    } else {
      //_categories  = _offlineBox.get("faq_category").cast<FAQCategory>();
    }
    notifyListeners();

  }


}