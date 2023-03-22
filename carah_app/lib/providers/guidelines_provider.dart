import 'dart:convert';
import 'dart:developer';
import 'package:carah_app/model/guideline.dart';
import 'package:carah_app/model/lightContent.dart';
import 'package:carah_app/providers/content_provider.dart';
import 'package:carah_app/providers/settings_provider.dart';
import 'package:carah_app/shared/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

import '../model/contentImage.dart';

class GuidelinesProvider extends ContentProvider<Guideline> {
  SettingsProvider settingsProvider;

  final List<Guideline> _guidelines = [];

  List<Guideline> get guidelines => _guidelines;

  GuidelinesProvider(
      {required this.settingsProvider}) {
    settingsProvider.getSettingsOfUser();
  }

  GuidelinesProvider update(
      SettingsProvider settingsProvider) {
    this.settingsProvider = settingsProvider;
    return this;
  }

  @override
  fetchDataByCategory(String uuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var guidelineFromCMS = await http.post(
        Uri.parse('$baseUrl/graphql'),
        headers: {
          "Content-Type": "application/json",
        },
        body:
        '''{"query":"{\\r\\n          node(uuid: \\"$uuid\\", version: ${dotenv.get('CMS_DATA_VERSION')}) {\\r\\n          uuid\\r\\n          parent {\\r\\n              displayName\\r\\n          }\\r\\n          ... on Slide {\\r\\n            fields {\\r\\n                title\\r\\n                text\\r\\n                position_in_guideline\\r\\n                images {\\r\\n                    uuid\\r\\n                    displayName\\r\\n                }\\r\\n            }\\r\\n          }\\r\\n        }\\r\\n}","variables":{}}''');
      log(jsonDecode(utf8.decoder.convert(guidelineFromCMS.bodyBytes)).toString());
      Guideline guideline = Guideline.fromJson(
          jsonDecode(utf8.decoder.convert(guidelineFromCMS.bodyBytes))['data']
              ['node']);
      if (guideline.images != null) {
        for(var img in guideline.images!) {
          await getImagesByUUID(img);
        }
      }
      guidelines.add(guideline);

    } else {
      // lightItems = _offlineBox.get("questions").cast<Question>();
    }
    notifyListeners();
  }

  @override
  fetchLightDataByCategory(String uuid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var guidelineCategoryFromCMS = await http.post(
        Uri.parse('$baseUrl/graphql'),
        headers: {
          "Content-Type": "application/json",
        },
        body:
            '''{"query":" {\\r\\n node(uuid: \\"$uuid\\") \\r\\n {\\r\\n children(filter: {\\r\\n} \\r\\n ){\\r\\n elements {\\r\\n displayName\\r\\n uuid\\r\\n schema {\\r\\n uuid\\r\\n }\\r\\n \\r\\n }\\r\\n }\\r\\n }\\r\\n }","variables":{}}''',
      );

      lightItems =
          jsonDecode(utf8.decoder.convert(guidelineCategoryFromCMS.bodyBytes))[
                  'data']['node']['children']['elements']
              .map<LightContent>((element) {
        return LightContent.fromJson(element);
      }).toList();
      lightItems.removeWhere((element) =>
          element.category ==
          "066e4aa01dc14ad6a8951e789c719bf6"); //Remove all image folders
    } else {
      // lightItems = _offlineBox.get("questions").cast<Question>();
    }
    notifyListeners();
  }

  getImagesByUUID(ContentImage image) async {
    if (!settingsProvider.userSettings!.dataSaveMode) {
      var connectivityResult = await (Connectivity().checkConnectivity());
        if ((connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi)) {
          var message = await http
              .get(Uri.parse('$baseUrl/nodes/${image.uuid}/binary/image'), headers: {
            "Content-Type": "application/json",
          });
          image.image = Image.memory(message.bodyBytes);
        }
    }
    notifyListeners();
  }
}
