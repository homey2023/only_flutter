import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:real_only/view/login_page.dart';
import 'package:real_only/view/result_page.dart';
import 'package:real_only/user_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? name;
  List? infoList;
  bool isLoading = true;
  Set<Marker> markers = {};
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();

    bringName();
    bringInfo();
  }

  bringName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _name = prefs.getString('name');
    setState(() {
      name = _name;
    });
  }

  bringInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    try {
      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/survey/showSurveyList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": id,
        }),
      );

      setState(() {
        infoList = jsonDecode(utf8.decode(response.bodyBytes));

        for (int i = 0; i < infoList!.length; i++) {
          infoList![i]['coords'][0] = double.parse(infoList![i]['coords'][0]);
          infoList![i]['coords'][1] = double.parse(infoList![i]['coords'][1]);
        }

        isLoading = false;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '마이페이지',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text('$name 님의',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('안전등급 결과는 ${infoList!.length}건입니다.',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    for (int i = 0; i < infoList!.length; i++)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFF6F6F6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: infoList![i]['confirm']
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                              child: Text(
                                infoList![i]['confirm'] ? '확인 완료' : '확인 전',
                                style: TextStyle(
                                  color: infoList![i]['confirm']
                                      ? Colors.white
                                      : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '주소',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  infoList![i]['address'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '신청일시',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${infoList![i]['time'].split('/')[0]}년 ${infoList![i]['time'].split('/')[1]}월 ${infoList![i]['time'].split('/')[2]}일 ${infoList![i]['time'].split('/')[3]}시',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            IgnorePointer(
                              child: Container(
                                height: 150,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFF6F6F6),
                                ),
                                child: KakaoMap(
                                  currentLevel: 5,
                                  onMapCreated: ((controller) {
                                    setState(() {
                                      markers.add(Marker(
                                          markerId: i.toString(),
                                          latLng: LatLng(
                                              infoList![i]['coords'][0],
                                              infoList![i]['coords'][1]),
                                          width: (123 * 0.3).toInt(),
                                          height: (144 * 0.3).toInt(),
                                          offsetX: 20,
                                          markerImageSrc:
                                              'https://ifh.cc/g/AsC2fl.png'));
                                    });
                                  }),
                                  
                                  markers: markers.toList(),
                                  center: LatLng(infoList![i]['coords'][0],
                                      infoList![i]['coords'][1]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () =>
                                    Get.to(() => ResultPage(), arguments: i),
                                child: const Text('결과 확인하기'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Divider(),
                          ),
                          FilledButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                try {
                                  UserPref().logout();
                                  Get.offAll(() => LoginPage());
                                } catch (error) {
                                  Get.snackbar('로그아웃 실패', '$error');
                                }
                              },
                              child: const Text('로그아웃')),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
