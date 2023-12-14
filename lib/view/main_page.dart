import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_only/view/my_page.dart';
import 'package:real_only/view/notification_page.dart';
import 'package:real_only/view/research_first_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final formKey = GlobalKey<FormState>();
  String ask = '';
  final String url =
      'https://instagram.com/onlyteam2023?igshid=NTc4MTIwNjQ2YQ==';

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: SafeArea(
            child: Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/user.png',
                          height: 30,
                        ),
                        onTap: () => Get.to(() => MyPage()),
                      ),
                    ),
                    Image.asset(
                      'assets/main_logo.png',
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0 + 5),
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/bell.png',
                          height: 30,
                        ),
                        onTap: () => Get.to(() => NotificationPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: deviceWidth * 0.7,
                    width: deviceWidth * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFF6F6F6),
                    ),
                    child: Swiper(
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset('assets/main_page_${index + 1}.jpg');
                      },
                      itemCount: 2,
                      pagination: const SwiperPagination(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                          builder: DotSwiperPaginationBuilder(
                              space: 5,
                              color: Color(0xFF979797),
                              activeColor: Color(0xFFE8E8E8),
                              size: 10.0,
                              activeSize: 10.0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text('우리집이 얼마나 안전한지 알아볼까요?'),
              const Text('아래 버튼을 클릭해주세요!'),
              const SizedBox(height: 25),
              FilledButton(
                onPressed: () => Get.to(() => ResearchFirstPage()),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 60, vertical: 20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: const Text(
                  '우리 집 안전 등급은?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  child: Image.asset('assets/collect_opinion_box.png'),
                  onTap: () {
                    Get.bottomSheet(
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    '호미는 여러분의 의견이 듣고 싶어요😊',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  const Text(
                                    '이런 점이 좋아요! 이런 점은 별로에요!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Form(
                                    key: formKey,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '안전등급이 조금 더 빨리 나왔으면 좋겠어요!',
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 1,
                                      maxLines: 5,
                                      maxLength: 1000,
                                      onChanged: (value) {
                                        setState(() {
                                          ask = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () async {
                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        int? id = prefs.getInt('id');
                                        if (ask != '') {
                                          try {
                                            var response = await http.post(
                                                Uri.parse(
                                                    'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/inquiry/saveInquiry'),
                                                headers: <String, String>{
                                                  'Content-Type':
                                                      'application/json',
                                                },
                                                body: jsonEncode({
                                                  'id': id,
                                                  'inquiry_message': ask
                                                }));
                                            if (response.statusCode != 200 ||
                                                response.body !=
                                                    '"success"\n') {
                                              Get.snackbar('의견 전송에 실패했습니다.',
                                                  '네트워크를 확인해주세요.');
                                            } else {
                                              Get.back();
                                              Get.snackbar('의견이 수집되었습니다 :)',
                                                  '소중한 의견을 주셔서 감사합니다😊');
                                            }
                                          } catch (error) {
                                            print('문의사항 저장 실패 : $error');
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(EdgeInsets.symmetric(
                                          vertical: 16,
                                        )),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        '의견 보내기',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFFFFEDDC),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
