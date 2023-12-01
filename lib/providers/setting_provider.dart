import 'package:flutter/material.dart';
import 'package:weather/utils/share_preferences.dart';

enum TemperatureUnit { celsius, fahrenheit }

class SettingProvider with ChangeNotifier {
  TemperatureUnit _temp = TemperatureUnit.celsius;
  final List<String> _theme = ["Purple", "Blue", "Blue Grey", "Coffee"];
  String _selectedTheme = "Blue";
  String? _currentLocation;

//getter
  String get getSelectedTheme => _selectedTheme;

  String? get getCurrentLocation => _currentLocation;

  TemperatureUnit get getTempUnit => _temp;

  List<String> get getListTheme => _theme;

//function
  void changeTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
    writeDataString('theme', theme);
  }

  void changeLocation(String location) async {
    _currentLocation = location;
    writeDataString('currentLocation', location);
    List<String>? listLocation = await readDataList("listlocation");
    if (listLocation != null) {
      if (!listLocation.contains(location)) {
        listLocation.add(location);
        writeDataList('listlocation', listLocation);
      }
    } else {
      writeDataList('listlocation', [location]);
    }
    notifyListeners();
  }

  void changeTempUnit(String tempUnit) {
    if (tempUnit == "C") {
      _temp = TemperatureUnit.celsius;
      writeDataString('tempUnit', "C");
    } else {
      _temp = TemperatureUnit.fahrenheit;
      writeDataString('tempUnit', "F");
    }
    notifyListeners();
  }
}
