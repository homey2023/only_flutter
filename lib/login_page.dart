import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

import 'main_page.dart';
import 'user_pref.dart';

enum G { F, M }

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '로그인',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'assets/login_logo.png',
                  width: 150,
                ),
                const SizedBox(height: 100),
                GestureDetector(
                  onTap: () {
                    kakaoLogin();
                  },
                  child: Image.asset(
                    'assets/kakao_login_button.png',
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  kakaoLogin() async {
    setState(() {
      isLoading = true;
    });
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        saveInfo();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          await UserApi.instance.loginWithKakaoAccount();
          saveInfo();
        } catch (error) {}
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        saveInfo();
      } catch (error) {}
    }
  }

  saveInfo() async {
    try {
      User user = await UserApi.instance.me();
      String? _gender;
      String _ageRange = user.kakaoAccount?.ageRange.toString() ?? '';
      if (user.kakaoAccount?.gender == Gender.female) {
        _gender = "F";
      } else if (user.kakaoAccount?.gender == Gender.male) {
        _gender = "M";
      }

      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/login/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": user.id,
          "nickname": user.kakaoAccount!.profile!.nickname!,
          'email': user.kakaoAccount?.email ?? '',
          'gender': _gender ?? '',
          'ageRange': _ageRange.replaceAll('AgeRange.age_', ''),
        }),
      );

      if (response.statusCode != 200 || response.body != '"success"\n') {
        print(response.body);
        throw Exception('error');
      } else {
        UserPref().login(user.id, user.kakaoAccount!.profile!.nickname!);
        Get.to(() => const MainPage());
      }
    } catch (error) {}
  }
}
