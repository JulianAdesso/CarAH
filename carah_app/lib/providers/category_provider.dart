import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/category.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';


class CategoryProvider extends ChangeNotifier{

  List<Category> _categories = [];


  List<Category> get categories => _categories;

  final _offlineBox = Hive.box('myBox');
  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';

  void fetchAllCategories(String categoryUUID, String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var categoriesFromCMS = await http.get(
          Uri.parse(
              '$_baseURL/nodes/$categoryUUID/children'),
          headers: {
            "Content-Type": "application/json",
          });
      _categories = jsonDecode(utf8.decoder.convert(categoriesFromCMS.bodyBytes))['data'].map<Category>((element) {
        return Category.fromJson(element);
      }).toList();
      _offlineBox.put(type, _categories);
    } else {
      _categories  = _offlineBox.get(type).cast<Category>();
    }
    notifyListeners();

  }


}