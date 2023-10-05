import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:real_only/my_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List strList = [];
  bool isLoading = true;
  bool isNone = false;

  @override
  void initState() {
    super.initState();
    bringNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '알림',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (isNone)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('알람이 없습니다'),
                    ),
                  ),
                for (String str in strList)
                  if (str == "설문결과완료")
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MyPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFF6F6F6),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📢 우리 집 안전등급이 궁금하지 않으세요?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ONLY가 준비한 안전등급  산출이 끝났습니다. 우리 집 안전등급 결과를 어서 확인해보세요!☺️',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
    );
  }

  bringNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    try {
      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/alarm/showAlarm'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      setState(() {
        if (response.body != '"저장된 결과 없음\n"') {
          strList = jsonDecode(utf8.decode(response.bodyBytes));
        } else {
          isNone = true;
        }
        isLoading = false;
      });
    } catch (error) {
      print('error is $error');
    }
  }
}
