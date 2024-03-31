import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SharedPreferences? prefs = null;
  String? currentDir = null;
  List<String> files = [];

  SettingsProvider(){
    _loadSettings();
  }

  void _loadSettings() async {
    prefs ??= await SharedPreferences.getInstance();
    currentDir ??= prefs!.getString("currentDir");   
    if (files.isEmpty)
      files = prefs!.getStringList("files") ?? [];
    notifyListeners();
  }

  void saveDir(String directory) async {
    prefs ??= await SharedPreferences.getInstance();
    currentDir = directory;
    
    if (currentDir != null)
      prefs!.setString('currentDir', currentDir!);
    notifyListeners();
  }

  void addFile(String file) async{
    prefs ??= await SharedPreferences.getInstance();
    files.add(file);
    prefs!.setStringList("files", files);
    notifyListeners();
  }

  void removeFile(String file) async{
    prefs ??= await SharedPreferences.getInstance();
    files.remove(file);
    prefs!.setStringList("files", files);
    notifyListeners();
  }

}