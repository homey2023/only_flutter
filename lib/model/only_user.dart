import 'package:shared_preferences/shared_preferences.dart';

class OnlyUser {
  checkLoginState() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? id = prefs.getInt('id');
  return id != null;
}
}
