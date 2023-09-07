import 'package:capstone/components/constants.dart';
import 'package:capstone/provider/email_password.dart';
import 'package:capstone/screens/homepage/dashboard.dart';
import 'package:capstone/screens/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login1 extends StatefulWidget {
  const Login1({Key? key}) : super(key: key);

  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  String errorMessage = '';

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                      "assets/Images/Agriculture-Farm-Vector-PNG 1.png",
                      fit: BoxFit.cover,
                      color: Colors.white.withOpacity(0.45),
                      colorBlendMode: BlendMode.modulate),
                )),
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                        child: Image.asset(
                      'assets/Images/Group 57.png',
                      width: 150,
                      height: 150,
                    )),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              inputField(
                                  controller: emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Please enter your email");
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("Please enter a valid email");
                                    }
                                    return null;
                                  },
                                  hint: 'Email Address'),
                              const SizedBox(
                                height: 20,
                              ),
                              inputField(
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Please enter your password");
                                    }
                                    return null;
                                  },
                                  obscured: true,
                                  hint: 'Password'),
                              const SizedBox(
                                height: 35,
                              ),
                              GestureDetector(
                                onTap: () {
                                  final form = formKey.currentState!;

                                  if (form.validate()) {
                                    final email = emailController.text.trim();
                                    final password =
                                        passwordController.text.trim();

                                    EmailPassword.loginAccountEmail(context,
                                            email: email, password: password)
                                        .then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard(),
                                        ),
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF075C1F),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: linkColor,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Signup(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(color: linkColor),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField inputField(
      {required TextEditingController controller,
      TextInputType? inputType,
      bool? obscured = false,
      required String? Function(String?)? validator,
      required String hint}) {
    return TextFormField(
        autofocus: false,
        controller: controller,
        obscureText: obscured!,
        validator: validator,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: hint,
            isCollapsed: false,
            contentPadding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 3, style: BorderStyle.solid, color: Colors.black),
                borderRadius: BorderRadius.circular(15))));
  }
}
