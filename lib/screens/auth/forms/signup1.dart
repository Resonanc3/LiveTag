import 'package:capstone/provider/email_password.dart';
import 'package:flutter/material.dart';

import '../../../components/constants.dart';

class Signup1 extends StatefulWidget {
  final Function(int) setIndex;
  final Function(String uid) setUid;
  const Signup1({Key? key, required this.setIndex, required this.setUid})
      : super(key: key);

  @override
  _Signup1State createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _cpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                  child: Image.asset(
                'assets/Images/Group 57.png',
                width: 150,
                height: 150,
              )),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    'Create your Live Tag Account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                  controller: _email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                  controller: _password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your password");
                    }
                    return null;
                  },
                  hint: 'Password',
                  obscured: true),
              const SizedBox(
                height: 20,
              ),
              inputField(
                  controller: _cpassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please confirm your password");
                    }

                    if (value != _password.text) {
                      return ("Password does not match");
                    }
                    return null;
                  },
                  hint: 'Confirm Password',
                  obscured: true),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    final email = _email.text.trim();
                    final password = _password.text.trim();

                    EmailPassword.createAccountEmail(context,
                            email: email, password: password)
                        .then((value) {
                      if (value != null) {
                        widget.setUid(value);
                        widget.setIndex(1);
                      }
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
                    'Proceed',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ]),
          ),
        ),
      )),
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
