import 'package:capstone/components/constants.dart';
import 'package:capstone/components/show_info.dart';
import 'package:capstone/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailPassword {
  static logoutAccount(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth.signOut().whenComplete(() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Login1(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      ShowInfo.showToast(e.message.toString());
    }
  }

  static Future loginAccountEmail(BuildContext context,
      {required String email, required String password}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Logging in, please wait...',
                      style: TextStyle(fontFamily: 'Roboto'),
                    )
                  ],
                ),
              ),
            ),
          );
        });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then((value) => Navigator.of(context).pop());

      return auth.currentUser?.uid;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      ShowInfo.showToast(e.message.toString());

      return null;
    }
  }

  static Future createAccountEmail(BuildContext context,
      {required String email, required String password}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Some text
                    Text(
                      'Validating account, please wait...',
                      style: TextStyle(fontFamily: 'Roboto'),
                    )
                  ],
                ),
              ),
            ),
          );
        });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .then((value) {
        Navigator.of(context).pop();
        return true;
      });

      return auth.currentUser?.uid;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      ShowInfo.showToast(e.message!);
      return null;
    }
  }
}
