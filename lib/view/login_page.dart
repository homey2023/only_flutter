import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_only/model/kakao_user.dart';
import 'package:real_only/view/email_login_page_demo.dart';

import 'email_login_page.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

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
                  width: screenWidth * 0.3,
                ),
                const SizedBox(height: 100),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    KakaoUser().getInfoFromKakao();
                  },
                  child: Image.asset(
                    'assets/kakao_login_button.png',
                    width: screenWidth * 0.6,
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => Get.to(() => const EmailLoginPageDemo()),
                  child: Image.asset(
                    'assets/email_login_button.png',
                    width: screenWidth * 0.6,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
