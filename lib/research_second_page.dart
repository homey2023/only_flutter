import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:real_only/research_third_page.dart';

class ResearchSecondPage extends StatefulWidget {
  const ResearchSecondPage({super.key});

  @override
  _ResearchSecondPageState createState() => _ResearchSecondPageState();
}

class _ResearchSecondPageState extends State<ResearchSecondPage> {
  final formKey = GlobalKey<FormState>();

  final List<String> imageUrls =
      List.generate(7, (index) => 'assets/2-${index + 2}.png');

  List radioValues = List.generate(7, (index) => '');

  String _selectedSafety = '';
  String reason = '';

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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset('assets/2-0.png'),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset('assets/2-1.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: RadioGroup<String>.builder(
                  groupValue: _selectedSafety,
                  onChanged: (value) =>
                      setState(() => _selectedSafety = value!),
                  items: ['안전하다', '보통이다', '안전하지 않다'],
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                    textPosition: RadioButtonTextPosition.right,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Image.asset('assets/2-1-2.png'),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: formKey,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '동네 분위기가 안좋다.',
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
                        reason = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(7, (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(imageUrls[index]),
                        const SizedBox(height: 7),
                        RadioListTile<String>(
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          title: Text(
                            '그렇다',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'T',
                          groupValue: radioValues[index],
                          onChanged: (String? value) {
                            setState(() {
                              radioValues![index] = value ?? 'F';
                            });
                          },
                        ),
                        RadioListTile<String>(
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          title: const Text(
                            '아니다',
                            style: TextStyle(fontSize: 14),
                          ),
                          value: 'F',
                          groupValue: radioValues[index],
                          onChanged: (String? value) {
                            setState(() {
                              radioValues[index] = value ?? 'F';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildNextButton(),
              )
            ],
          ),
        ));
  }

  Widget _buildNextButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: _navigateToSecondPage,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 16)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          child: const Text(
            '다음 단계로 넘어가기 (2/3)',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _navigateToSecondPage() async {
    bool _isNull = false;
    for (var i in radioValues) {
      if (i == '') {
        _isNull = true;
      }
    }
    print(_isNull);

    if (_selectedSafety != '' && !_isNull) {
      List<dynamic> value = Get.arguments;
      value.add(_selectedSafety);
      value.add(reason);
      value.add(radioValues);

      Get.to(() => ResearchThirdPage(), arguments: value);
    } else {
      _showIncompleteDataSnackBar();
    }
  }

  void _showIncompleteDataSnackBar() {
    const snackBar = SnackBar(
      content: Text('모두 입력해주세요 🙂'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
