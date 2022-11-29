import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../model/category.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier{

  List<Category> _categories = [];


  List<Category> get categories => _categories;

  final _baseURL = 'http://h2992008.stratoserver.net:8080/api/v2/CarAH';
  final _baseUUID = '0a8e66b695f5410cac44b1a9531a7a2b';

  void fetchAllCategories() async {
    var categoriesFromCMS = await http.get(
        Uri.parse(
            '$_baseURL/nodes/$_baseUUID/children'),
        headers: {
          "Content-Type": "application/json",
        });
    _categories = jsonDecode(utf8.decoder.convert(categoriesFromCMS.bodyBytes))['data'].map<Category>((element) {
      return Category.fromJson(element);
    }).toList();
    notifyListeners();
  }


}