import 'package:capstone/api/services.dart';
import 'package:capstone/components/constants.dart';
import 'package:capstone/components/loading_dialog.dart';
import 'package:capstone/components/show_info.dart';
import 'package:capstone/models/user_data.dart';
import 'package:capstone/provider/email_password.dart';
import 'package:capstone/screens/homepage/dashboard.dart';
import 'package:flutter/material.dart';

class Signup2 extends StatefulWidget {
  final String uid;
  const Signup2({Key? key, required this.uid}) : super(key: key);

  @override
  _Signup2State createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  String errorMessage = '';

  final formKey = GlobalKey<FormState>();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phoneNumber = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    // try {
    //   await Auth().createUserWithEmailAndPassword(
    //     email: signupEmailController.text,
    //     password: signupPasswordController.text,
    //   );
    // } on FirebaseAuthException catch (e) {
    //   setState(() {
    //     errorMessage = e.message!;
    //   });
    // }
  }

  @override
  void dispose() {
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  controller: _name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your complete name");
                    }
                    return null;
                  },
                  hint: 'Complete name'),
              const SizedBox(
                height: 20,
              ),
              inputField(
                  controller: _address,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your address");
                    }

                    return null;
                  },
                  hint: 'Address'),
              const SizedBox(
                height: 20,
              ),
              inputField(
                  controller: _phoneNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter your phone number");
                    }
                    return null;
                  },
                  hint: 'Phone number'),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    final user = UserData(
                        id: widget.uid,
                        name: _name.text.trim(),
                        address: _address.text.trim(),
                        phone: _phoneNumber.text.trim());

                    ShowInfo.showUpDialog(context,
                        title: 'Create Account',
                        message: 'Are you sure you want to create account?',
                        action1: 'Yes',
                        btn1: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const LoadingDialog(
                                    message: 'Creating account, please wait...',
                                  ));

                          Services.createAccount(user: user).then((value) {
                            if (value) {
                              ShowInfo.showUpDialog(context,
                                  title: 'Account Created',
                                  message:
                                      'Your account has been successfully created, you will be logged in automatically.',
                                  action1: 'Okay', btn1: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const Dashboard())));
                              });
                            } else {
                              ShowInfo.showToast(
                                  'Failed, due to an error occurred');
                            }
                          });
                        },
                        action2: 'Cancel',
                        btn2: () {
                          Navigator.of(context).pop();
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
                    'Sign Up',
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
