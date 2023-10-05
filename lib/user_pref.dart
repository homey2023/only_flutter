import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  login(id, name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
    await prefs.setString('name', name);
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
  }
}
