import 'package:shared_preferences/shared_preferences.dart';

writeDataString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

writeDataList(String key, List<String> value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key, value);
}

// Hàm để đọc dữ liệu từ SharedPreferences
Future<String?> readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<List<String>?> readDataList(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}
