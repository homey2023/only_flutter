import 'dart:convert';

import 'package:get/get.dart';
import 'package:real_only/model/only_user.dart';
import 'package:http/http.dart' as http;

import '../view/main_page.dart';
import '../user_pref.dart';

class DemoUser extends OnlyUser {
  late int id;
  final String pin;

  DemoUser({required this.pin});

  sendInfoToServer() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-ac2nllhjp14c.sel3.cloudtype.app/login/pincheck'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": pin,
        }),
      );
      print(response.body);
      if (response.statusCode == 200 && response.body == '"success"\n') {
        id = int.parse(pin); // id 값을 서버에서 받음
        UserPref().login(id, 'demo');
        Get.to(() => const MainPage());
      } else {
        throw Exception('error');
      }
    } catch (error) {
      print('error is $error');
    }
  }
}
