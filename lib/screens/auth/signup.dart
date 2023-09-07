import 'package:capstone/screens/auth/forms/signup1.dart';
import 'package:capstone/screens/auth/forms/signup2.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  int currentIndex = 0;

  String uId = '';

  void setIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void setUID(String uid) {
    setState(() {
      uId = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        Signup1(
          setUid: (uid) {
            setUID(uid);
          },
          setIndex: (index) {
            setIndex(index);
          },
        ),
        Signup2(
          uid: uId,
        )
      ],
    );
  }
}
