import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:real_only/view/main_page.dart';
import 'package:real_only/model/only_user.dart';
import 'package:http/http.dart' as http;
import 'package:real_only/user_pref.dart';

class KakaoUser extends OnlyUser {
  getInfoFromKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();

        KakaoUser().sendInfoToServer();
      } catch (error) {
        print('error is $error');
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          await UserApi.instance.loginWithKakaoAccount();
          KakaoUser().sendInfoToServer();
        } catch (error) {}
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        KakaoUser().sendInfoToServer();
      } catch (error) {}
    }
  }

  sendInfoToServer() async {
    try {
      User user = await UserApi.instance.me();
      String? gender;
      String ageRange = user.kakaoAccount?.ageRange.toString() ?? '';

      if (user.kakaoAccount?.gender == Gender.female) {
        gender = "F";
      } else if (user.kakaoAccount?.gender == Gender.male) {
        gender = "M";
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
          'gender': gender ?? '',
          'ageRange': ageRange.replaceAll('AgeRange.age_', ''),
        }),
      );

      if (response.statusCode != 200 || response.body != '"success"\n') {
        throw Exception('error');
      } else {
        UserPref().login(user.id, user.kakaoAccount!.profile!.nickname!);
        Get.to(() => const MainPage());
      }
    } catch (error) {}
  }
}
