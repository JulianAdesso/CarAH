import 'package:flutter/widgets.dart';

import '../model/content.dart';

class ContentProvider<P extends Content> extends ChangeNotifier {
  List<P> _items = [];

  get items => _items;

  set items(value) {
    _items = value;
  }

  fetchDataByCategory(String id) {}

  setFavorite(String id, bool val) {}
}
