import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_only/notification.dart';

import 'main_page.dart';

class ResearchFinishPage extends StatefulWidget {
  const ResearchFinishPage({super.key});

  @override
  State<ResearchFinishPage> createState() => _ResearchFinishPageState();
}

class _ResearchFinishPageState extends State<ResearchFinishPage> {
  @override
  void initState() {
    super.initState();
    FlutterLocalNotification.showNotification();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.to(() => const MainPage());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            '우리집 안전등급은?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                '우리 집 안전 등급 산출에 응해주셔서 감사합니다. 지금은 등급 산출이 진행되는 중입니다. 최대 24시간 이내로 등급이 산출됩니다.등급 결과가 나오면 알림을 보내드리겠습니다.',
                textAlign: TextAlign.justify,
              ),
              FilledButton(
                onPressed: () => Get.to(() => MainPage()),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                    vertical: 16,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: const Text(
                  '메인으로 이동하기',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
