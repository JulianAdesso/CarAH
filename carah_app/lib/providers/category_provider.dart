import 'dart:convert';

import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/category.dart';
import 'package:http/http.dart' as http;


class CategoryProvider extends ChangeNotifier{

  List<Category> _categories = [];


  List<Category> get categories => _categories;

  final _offlineBox = Hive.box('myBox');

  Future <void> fetchAllCategories(String categoryUUID, String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var categoriesFromCMS = await http.get(
          Uri.parse(
              '$baseUrl/nodes/$categoryUUID/children'),
          headers: {
            "Content-Type": "application/json",
          });
      _categories = jsonDecode(utf8.decoder.convert(categoriesFromCMS.bodyBytes))['data'].map<Category>((element) {
        return Category.fromJson(element);
      }).toList();
    } else {
      _categories  = _offlineBox.get(type)?.cast<Category>();
    }
    notifyListeners();

  }

  Future<Category> fetchCategoryById(String categoryUUID, String type) async{
    Category category;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var categoriesFromCMS = await http.get(
          Uri.parse(
              '$baseUrl/nodes/$categoryUUID'),
          headers: {
            "Content-Type": "application/json",
          });
      category = Category.fromJson(jsonDecode(utf8.decoder.convert(categoriesFromCMS.bodyBytes)));
    } else {
      List<Category> offlineCategories  = _offlineBox.get(type)?.cast<Category>();
      category = offlineCategories.where((element) => element.uuid == categoryUUID).toList().first;
    }
    notifyListeners();
    return category;
  }

  Future<bool> downloadCategory(String categoryID) async{
    List<Category>? cat  = _offlineBox.get('articles_category')?.cast<Category>();
    if(cat == null || !cat.any((element) => element.uuid == categoryID)) {
      Category searchedCategory = await fetchCategoryById(categoryID, 'articles_category');
      cat = [searchedCategory];
    }
    await _offlineBox.put('articles_category',
        cat.where((element) => element.uuid == categoryID).toList());
    return true;
  }


}