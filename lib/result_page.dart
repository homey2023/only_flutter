import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_only/triangle_maker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var pageNumber = Get.arguments;
  final formKey = GlobalKey<FormState>();
  List value = [];
  String? ask;
  bool isLoading = true;
  Map infoList = {};

  @override
  void initState() {
    super.initState();
    bringInfo();
  }

  bringInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    try {
      var response = await http.post(
        Uri.parse(
            'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/home_safety_rating/showResult'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": id,
          "surveyNo": pageNumber + 1,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('실패');
      }

      print('결과 : ${jsonDecode(utf8.decode(response.bodyBytes))}');

      setState(() {
        infoList = jsonDecode(utf8.decode(response.bodyBytes));

        isLoading = false;
      });
    } catch (error) {
      print('error is ${error}');
    }
  }

  late KakaoMapController mapController;
  Set<Marker> markers = {};

  final _screenshotController = ScreenshotController();

  Future<void> _captureAndShare() async {
    final image = await _screenshotController.capture();

    // 이미지를 파일로 저장 (디바이스에 저장됨)
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/screenshot.png';
    File(imagePath).writeAsBytesSync(image!);

    // XFile로 변경
    XFile xfile = XFile(imagePath);

    // 소셜미디어 공유
    await Share.shareXFiles([xfile], text: '안전등급 결과');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '우리집 안전등급은?',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/frame.png'),
                    Screenshot(
                        controller: _screenshotController,
                        child: Container(
                          color: Colors.white,
                          child: Column(children: [
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF6F6F6),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color(0xFFE8E8E8))),
                              child: Text(
                                '우리집 주소 : ${infoList["address"]}',
                                style: TextStyle(
                                    color: Color(0xFF979797), fontSize: 11),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '우리집의 안전등급은',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              '${infoList["rating"]}등급 (${infoList["total_score"]}점)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const Text(
                              '입니다',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Text(
                                    '위치 및 조건',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      ClipPath(
                                        clipper: Triangle(),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF6F6F6),
                                          ),
                                          width: 200,
                                          height: 200,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CustomPaint(
                                          foregroundPainter: LinePainter(),
                                        ),
                                      ),
                                      ClipPath(
                                        clipper: ResultTriangle(
                                          infoList["location_percent"],
                                          infoList["support_percent"],
                                          infoList["facility_percent"],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          width: 200,
                                          height: 200,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CustomPaint(
                                          foregroundPainter: LinePainter2(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '시설',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      Text(
                                        '지원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Image.asset(
                              'assets/text2.png',
                              width: 200,
                            ),
                            if (!isLoading)
                              Container(
                                margin: const EdgeInsets.all(16),
                                height: 200,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFF6F6F6),
                                ),
                                child: KakaoMap(
                                  currentLevel: 5,
                                  onMapCreated: ((controller) async {
                                    mapController = controller;

                                    setState(() {
                                      for (List latlon
                                          in infoList["list_of_busStops"]) {
                                        markers.add(Marker(
                                            markerId: 'police',
                                            latLng:
                                                LatLng(latlon[0], latlon[1]),
                                            width: (123 * 0.3).toInt(),
                                            height: (144 * 0.3).toInt(),
                                            offsetX: 20,
                                            markerImageSrc:
                                                'https://ifh.cc/g/wBVMOP.png'));
                                      }

                                      for (List latlon
                                          in infoList["list_of_polices"]) {
                                        markers.add(Marker(
                                            markerId: 'police',
                                            latLng:
                                                LatLng(latlon[0], latlon[1]),
                                            width: (123 * 0.3).toInt(),
                                            height: (144 * 0.3).toInt(),
                                            offsetX: 20,
                                            markerImageSrc:
                                                'https://ifh.cc/g/BwFVMb.png'));
                                      }

                                      for (List latlon in infoList[
                                          "list_of_safetyCenters"]) {
                                        markers.add(Marker(
                                            markerId: 'safetyCenter',
                                            latLng:
                                                LatLng(latlon[0], latlon[1]),
                                            width: (123 * 0.3).toInt(),
                                            height: (144 * 0.3).toInt(),
                                            offsetX: 20,
                                            markerImageSrc:
                                                'https://ifh.cc/g/wHA86S.png'));
                                      }

                                      for (List latlon
                                          in infoList["list_of_ansimees"]) {
                                        markers.add(Marker(
                                            markerId: 'ansimee',
                                            latLng:
                                                LatLng(latlon[0], latlon[1]),
                                            width: (123 * 0.3).toInt(),
                                            height: (144 * 0.3).toInt(),
                                            offsetX: 20,
                                            markerImageSrc:
                                                'https://ifh.cc/g/szwbQS.png'));
                                      }

                                      markers.add(Marker(
                                          markerId: 'home',
                                          latLng: LatLng(infoList['coords'][0],
                                              infoList['coords'][1]),
                                          width: (123 * 0.3).toInt(),
                                          height: (144 * 0.3).toInt(),
                                          offsetX: 20,
                                          markerImageSrc:
                                              'https://ifh.cc/g/AsC2fl.png'));
                                    });
                                  }),
                                  markers: markers.toList(),
                                  center: LatLng(infoList['coords'][0],
                                      infoList['coords'][1]),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Image.asset('assets/flip.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(infoList["no_of_polices"].toString() +
                                      "개"),
                                  Text(infoList["no_of_safetyCenters"]
                                          .toString() +
                                      "개"),
                                  Text(infoList["no_of_ansimees"].toString() +
                                      "개"),
                                  Text(infoList["no_of_busStops"].toString() +
                                      "개")
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ]),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Image.asset('assets/result_message.png'),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Image.asset(
                                  'assets/button1.png',
                                  width: constraints.maxWidth * 0.43,
                                ),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                                ),
                                                const Text(
                                                  '이런 점이 좋아요! 이런 점은 별로에요!',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Form(
                                                  key: formKey,
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          '안전등급이 조금 더 빨리 나왔으면 좋겠어요!',
                                                      hintStyle: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
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
                                                      final SharedPreferences
                                                          prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      int? id =
                                                          prefs.getInt('id');
                                                      if (ask != '') {
                                                        try {
                                                          var response = await http.post(
                                                              Uri.parse(
                                                                  'https://port-0-homeympv-eu1k2lllj1sfo3.sel3.cloudtype.app/inquiry/saveInquiry'),
                                                              headers: <String,
                                                                  String>{
                                                                'Content-Type':
                                                                    'application/json',
                                                              },
                                                              body: jsonEncode({
                                                                'id': id,
                                                                'inquiry_message':
                                                                    ask
                                                              }));
                                                          if (response.statusCode !=
                                                                  200 ||
                                                              response.body !=
                                                                  '"success"\n') {
                                                            Get.snackbar(
                                                                '의견 전송에 실패했습니다.',
                                                                '네트워크를 확인해주세요.');
                                                          } else {
                                                            Get.back();
                                                            Get.snackbar(
                                                                '의견이 수집되었습니다 :)',
                                                                '소중한 의견을 주셔서 감사합니다😊');
                                                          }
                                                        } catch (error) {
                                                          print(
                                                              '문의사항 저장 실패 : $error');
                                                        }
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all<
                                                                      EdgeInsets>(
                                                                  EdgeInsets
                                                                      .symmetric(
                                                        vertical: 16,
                                                      )),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      '의견 보내기',
                                                      style: TextStyle(
                                                          fontSize: 16),
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
                              GestureDetector(
                                child: Image.asset(
                                  'assets/button2.png',
                                  width: constraints.maxWidth * 0.43,
                                ),
                                onTap: () => _captureAndShare(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ResultTriangle extends CustomClipper<Path> {
  double? v1;
  double? v2;
  double? v3;

  ResultTriangle(v1, v2, v3)
      : this.v1 = v1 * 0.01,
        this.v2 = v2 * 0.01,
        this.v3 = v3 * 0.01;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, (size.height / 2) * (1 - v1!));
    path.lineTo((size.width / 2) * (1 + v2!), (size.height / 3) * (2 + v2!));
    path.lineTo((size.width / 2) * (1 - v3!), (size.height / 3) * (2 + v3!));
    path.lineTo(size.width / 2, (size.height / 2) * (1 - v1!));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
