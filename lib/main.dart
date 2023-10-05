// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:real_only/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:real_only/main_page.dart';

import 'color_schemes.g.dart';
import 'login_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '7193d58cd1f3e974e331cf4488fc4f01',
    javaScriptAppKey: '7c4ea26182fe96e74c2901c80bd4a320',
  );

  AuthRepository.initialize(appKey: '8d446c2509c713f22afd3ba5062b0ff4');

  bool isLogin = await checkLoginState();

  FlutterNativeSplash.remove();

  runApp(MyApp(
    isLogin: isLogin,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  final bool isLogin;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: 'NotoSansKR',
      ),
      home: widget.isLogin ? const MainPage() : LoginPage(),
    );
  }
}

checkLoginState() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? id = prefs.getInt('id');
  return id != null;
}
