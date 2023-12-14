import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:real_only/model/demo_user.dart';

class EmailLoginPageDemo extends StatefulWidget {
  const EmailLoginPageDemo({super.key});

  @override
  State<EmailLoginPageDemo> createState() => _EmailLoginPageDemoState();
}

class _EmailLoginPageDemoState extends State<EmailLoginPageDemo> {
  TextEditingController _pinController = TextEditingController();
  bool isLoading = false;

  final OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Color(0xff979797), width: 0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '이메일 로그인',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              child: TextFormField(
                                controller: _pinController,
                                decoration: InputDecoration(
                                  label: Text('PIN'),
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                                validator: (input) {
                                  bool isValid =
                                      EmailValidator.validate(input ?? '');
                                  if (!isValid) {
                                    return "이메일 정보가 올바르지 않습니다.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FilledButton(
                                  onPressed: tryPinLogin,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffFF951A)),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.symmetric(vertical: 16)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                  ),
                                  child: const Text(
                                    '로그인',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ))),
    );
  }

  tryPinLogin() {
    setState(() {
      isLoading = true;
    });
    String pin = _pinController.text;
    // 로그인 로직 구현
    print('비밀번호: $pin');

    DemoUser user = DemoUser(pin: pin);

    user.sendInfoToServer();
    setState(() {
      isLoading = false;
    });
  }
}
