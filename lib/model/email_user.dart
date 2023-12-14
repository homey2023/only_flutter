import 'dart:convert';

import 'package:get/get.dart';
import 'package:real_only/model/only_user.dart';
import 'package:http/http.dart' as http;

import '../view/main_page.dart';
import '../user_pref.dart';

class EmailUser extends OnlyUser {
  late int id;
  final String nickname;
  final String email;

  EmailUser({required this.nickname, required this.email});

  sendInfoToServer() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/login/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": '',
          "nickname": nickname,
          'email': email,
          'gender': '',
          'ageRange': '',
        }),
      );

      if (response.statusCode == 200 || response.body == '"success"\n') {
        id = response.body.length; // id 값을 서버에서 받음
        UserPref().login(id, nickname);
        Get.to(() => const MainPage());
      } else {
        throw Exception('error');
      }
    } catch (error) {}
  }
}
