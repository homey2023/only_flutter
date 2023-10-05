import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'package:real_only/research_finish_page.dart';

import 'notification.dart';

enum Standard {
  a('a', '안전'),
  b('b', '뷰'),
  c('c', '인프라(학교,편의시설 등)'),
  d('d', '이웃'),
  e('e', '동네분위기'),
  f('f', '위치'),
  g('g', '매물컨디션(청결도, 준공일 등)');

  // enum의 constructor를 정의해 줍니다.
  const Standard(this.englishName, this.koreanName);
  final String englishName;
  final String koreanName;
}

enum Safety {
  a('a', '경찰서'),
  b('b', 'CCTV'),
  c('c', '학교'),
  d('d', '공공기관'),
  e('e', '편의점'),
  f('f', '학원'),
  g('g', '부동산'),
  h('h', '여성안심귀갓길'),
  i('i', '여성안심택배함');

  // enum의 constructor를 정의해 줍니다.
  const Safety(this.englishName, this.koreanName);
  final String englishName;
  final String koreanName;
}

class ResearchThirdPage extends StatefulWidget {
  const ResearchThirdPage({super.key});

  @override
  State<ResearchThirdPage> createState() => _ResearchThirdPageState();
}

class _ResearchThirdPageState extends State<ResearchThirdPage> {
  final formKey = GlobalKey<FormState>();
  List requestList = [];

  List<String> _standard = [];
  List<String> _safety = [];
  int? _prefer1;
  int? _prefer2;
  int? _prefer3;
  int? _prefer4;
  String? another = '';

  List<String> prefer1 = ['고층', '저층', '상관없음'];
  List<String> prefer2 = ['도로변', '골목 안', '상관없음'];
  List<String> prefer3 = ['좁은 평수', '넓은 평수', '상관없음'];
  List<String> prefer4 = ['신축', '구축', '상관없음'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '우리집 안전등급은?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 16),
              Image.asset('assets/3-0.png'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Image.asset('assets/3-1.png'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 3.0,
                      children: Standard.values.map((Standard exercise) {
                        return FilterChip(
                          side: BorderSide.none,
                          showCheckmark: false,
                          backgroundColor: Color(0xFFF6F6F6),
                          selectedColor: Color(0xFFFFDCC1),
                          padding: EdgeInsets.all(4),
                          label: Text(exercise.koreanName),
                          selected: _standard.contains(exercise.koreanName),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                if (_standard.length != 2)
                                  _standard.add(exercise.koreanName);
                              } else {
                                _standard.remove(exercise.koreanName);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Image.asset('assets/3-2.png'),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text('층 수',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                flex: 3,
                                child: Wrap(
                                  spacing: 3.0,
                                  children: List<Widget>.generate(
                                    prefer1.length,
                                    (int index) {
                                      return RawChip(
                                        side: BorderSide.none,
                                        showCheckmark: false,
                                        backgroundColor: Color(0xFFF6F6F6),
                                        selectedColor: Color(0xFFFFDCC1),
                                        padding: const EdgeInsets.all(4),
                                        label: Text(prefer1[index]),
                                        selected: _prefer1 == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _prefer1 = selected ? index : null;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          Image.asset('assets/divider.png'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text('위치',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                flex: 3,
                                child: Wrap(
                                  spacing: 3.0,
                                  children: List<Widget>.generate(
                                    prefer2.length,
                                    (int index) {
                                      return RawChip(
                                        side: BorderSide.none,
                                        showCheckmark: false,
                                        backgroundColor: Color(0xFFF6F6F6),
                                        selectedColor: Color(0xFFFFDCC1),
                                        padding: const EdgeInsets.all(4),
                                        label: Text(prefer2[index]),
                                        selected: _prefer2 == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _prefer2 = selected ? index : null;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          Image.asset('assets/divider.png'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text('평 수',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                flex: 5,
                                child: Wrap(
                                  spacing: 3.0,
                                  children: List<Widget>.generate(
                                    prefer3.length,
                                    (int index) {
                                      return RawChip(
                                        side: BorderSide.none,
                                        showCheckmark: false,
                                        backgroundColor: Color(0xFFF6F6F6),
                                        selectedColor: Color(0xFFFFDCC1),
                                        padding: const EdgeInsets.all(4),
                                        label: Text(prefer3[index]),
                                        selected: _prefer3 == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _prefer3 = selected ? index : null;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          Image.asset('assets/divider.png'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text('준공일',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Flexible(
                                flex: 3,
                                child: Wrap(
                                  spacing: 3.0,
                                  children: List<Widget>.generate(
                                    prefer4.length,
                                    (int index) {
                                      return RawChip(
                                        side: BorderSide.none,
                                        showCheckmark: false,
                                        backgroundColor: Color(0xFFF6F6F6),
                                        selectedColor: Color(0xFFFFDCC1),
                                        padding: const EdgeInsets.all(4),
                                        label: Text(prefer4[index]),
                                        selected: _prefer4 == index,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            _prefer4 = selected ? index : null;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          Image.asset('assets/divider.png'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('assets/3-3.png'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 3.0,
                        children: Safety.values.map((Safety exercise) {
                          return FilterChip(
                            side: BorderSide.none,
                            showCheckmark: false,
                            backgroundColor: Color(0xFFF6F6F6),
                            selectedColor: Color(0xFFFFDCC1),
                            padding: EdgeInsets.all(4),
                            label: Text(exercise.koreanName),
                            selected: _safety.contains(exercise.koreanName),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _safety.add(exercise.koreanName);
                                } else {
                                  _safety.remove(exercise.koreanName);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset('assets/3-4.png'),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Form(
                        key: formKey,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'ex) 안전비상벨',
                            hintStyle: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.normal),
                            fillColor: Color(0xFFF6F6F6),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 1,
                          maxLength: 50,
                          onChanged: (value) {
                            setState(() {
                              another = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                      onPressed: () async {
                        _sendToServer();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                          vertical: 16,
                        )),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: const Text(
                        '완료하기',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _sendToServer() async {
    try {
      var value = Get.arguments;

      User user = await UserApi.instance.me();

      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/survey/saveHomeSurvey'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": user.id,
          'address': value[0],
          'dwellingType': value[1],
          'roomNumber': value[2],
          'toiletNumber': value[3],
          'floorNumber': value[4],
          'facility': value[5],
          'isSafety': value[6],
          'reason': value[7],
          'yesOrNo': value[8],
          'standard': _standard,
          'prefer1': prefer1[_prefer1!],
          'prefer2': prefer2[_prefer2!],
          'prefer3': prefer3[_prefer3!],
          'prefer4': prefer4[_prefer4!],
          'safety': _safety,
          'another': another,
        }),
      );
      if (response.statusCode != 200 || response.body != '"success"\n') {
        print(response.statusCode);
        Get.snackbar('전송 실패', '네트워크를 확인해주세요');
      } else {
        Get.to(() => ResearchFinishPage());
      }
    } catch (e) {
      print('실패 $e');
    }
  }
}
