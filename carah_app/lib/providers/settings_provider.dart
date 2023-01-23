import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../model/settings.dart';

class SettingsProvider extends ChangeNotifier{

  Settings? userSettings;
  final _offlineBox = Hive.box('myBox');

  getSettingsOfUser(){
    userSettings = _offlineBox.get("settings");
    if(userSettings == null){
      userSettings = Settings();
      saveSettings(userSettings!);
    }
  }

  void saveSettings(Settings settings) {
    _offlineBox.put("settings", settings);
  }

}