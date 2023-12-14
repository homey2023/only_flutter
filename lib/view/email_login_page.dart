import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:real_only/view/email_signup_page.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => EmailLoginPageState();
}

class EmailLoginPageState extends State<EmailLoginPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: Text('이메일'),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border,
                      ),
                      validator: (input) {
                        bool isValid = EmailValidator.validate(input ?? '');
                        if (!isValid) {
                          return "이메일 정보가 올바르지 않습니다.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        label: Text('비밀번호'),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border,
                        suffixIcon: GestureDetector(
                          child: _obscureText
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (input) {
                        if (input!.isEmpty || input.length < 2) {
                          return "비밀번호 정보가 올바르지 않습니다.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          onPressed: tryEmailLogin,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xffFF951A)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 16)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                          child: const Text(
                            '로그인',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Image.asset('assets/계정 생성.png', width: 60),
                          onTap: () => Get.to(() => EmailSignUpPage()),
                        ),
                        SizedBox(width: 5),
                        Image.asset('assets/_.png', width: 2),
                        SizedBox(width: 5),
                        GestureDetector(
                          child: Image.asset('assets/비밀번호 찾기.png', width: 88),
                          onTap: () {},
                        ),
                      ],
                    )
                  ]),
                ),
              ),
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  tryEmailLogin() {
    if (_formKey.currentState!.validate()) {
      // 여기서 로그인 로직을 추가하면 됨
      String email = _emailController.text;
      String password = _passwordController.text;
      // 로그인 로직 구현
      print('이메일: $email, 비밀번호: $password');
    }
  }
}
