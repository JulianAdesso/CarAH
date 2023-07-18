import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/navigation_item.dart';
import '../shared/constants.dart';

class ListItemProvider extends ChangeNotifier{

  List<ListItem> homepageItems = [];

  final _offlineBox = Hive.box('myBox');

  initHomePageItems() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var listItemsFromCMS = await http.post(Uri.parse('$baseUrl/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body: '''{"query":"{\\r\\n          node(path: \\"/\\") {\\r\\n              children(filter: {\\r\\n                  schema: {\\r\\n                      is: HomePage_Card\\r\\n                  }\\r\\n              }) {\\r\\n                  elements{\\r\\n                    ...on HomePage_Card{\\r\\n                        uuid\\r\\n                        fields {                    \\r\\n                            Header\\r\\n                              Subheading\\r\\n                              icon\\r\\n                              isAvailableInOfflineMode\\r\\n                            isDisabled\\r\\n                            routerLink\\r\\n                        position\\r\\n                     }\\r\\n                    }\\r\\n                  }\\r\\n              }\\r\\n              }\\r\\n}","variables":{}}''');
      homepageItems =
          jsonDecode(utf8.decoder.convert(listItemsFromCMS.bodyBytes))['data']['node']['children']['elements']
              .map<ListItem>((element) {
                  return ListItem.fromJson(element);
          }).toList();
      homepageItems.sort((a, b) => a.position.compareTo(b.position));
      _offlineBox.put("homepage", homepageItems);
    } else {
      homepageItems = _offlineBox.get("homepage")?.cast<ListItem>();
    }
    notifyListeners();
  }

}