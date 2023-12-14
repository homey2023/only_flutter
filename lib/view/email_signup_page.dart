import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:real_only/model/email_user.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  State<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  bool obscureText = true;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  final OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Color(0xff979797), width: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '이메일 회원가입',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        label: const Text('닉네임'),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border,
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "닉네임 정보가 올바르지 않습니다.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: const Text('이메일'),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border,
                        suffix: FilledButton(
                          onPressed: tryEmailAuth,
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
                            '인증요청',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
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
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        label: Text('비밀번호'),
                        border: _border,
                        enabledBorder: _border,
                        focusedBorder: _border,
                        suffixIcon: GestureDetector(
                          child: obscureText
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
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
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            EmailUser(
                                    email: _emailController.text,
                                    nickname: _nicknameController.text)
                                .sendInfoToServer();
                          },
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
                            '회원가입',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
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

  tryEmailAuth() {}
}
