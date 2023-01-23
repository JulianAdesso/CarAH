import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 5)
class Settings{

  @HiveField(0)
  bool dataSaveMode;

  Settings({this.dataSaveMode = false});

}