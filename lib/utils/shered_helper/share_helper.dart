import 'package:shared_preferences/shared_preferences.dart';

void saveBookmark({required List <String>bookmark}) async {
  SharedPreferences shr = await SharedPreferences.getInstance();
  shr.setStringList("url",bookmark );
}

Future<List <String>?> applyMark() async {
  SharedPreferences shr = await SharedPreferences.getInstance();
  return shr.getStringList("url");
}
