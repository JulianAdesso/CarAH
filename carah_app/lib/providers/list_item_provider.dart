import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/navigation_items.dart';
import '../shared/constants.dart';

class ListItemProvider extends ChangeNotifier{

  List<ListItem> homepageItems = [];

  initHomePageItems() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var listItemsFromCMS = await http.post(Uri.parse('$baseUrl/graphql'),
          headers: {
            "Content-Type": "application/json",
          },
          body: '''{"query":"{\\r\\n          node(path: \\"/\\", version: ${dotenv.get("CMS_DATA_VERSION")}) {\\r\\n              children{\\r\\n                  elements{\\r\\n                    ...on HomePage_Card{\\r\\n                        uuid\\r\\n                        fields {                    \\r\\n                            Header\\r\\n                              Subheading\\r\\n                              icon\\r\\n                              isAvailableInOfflineMode\\r\\n                            isDisabled\\r\\n                            routerLink\\r\\n                        }\\r\\n                    }\\r\\n                  }\\r\\n              }\\r\\n              }\\r\\n}","variables":{}}''');

      homepageItems =
          jsonDecode(utf8.decoder.convert(listItemsFromCMS.bodyBytes))['data']
              .map<ListItem>((element) {
            return ListItem.fromJson(element);
          }).toList();
    }
  }

}