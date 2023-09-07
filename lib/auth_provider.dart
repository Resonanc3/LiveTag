import 'package:capstone/screens/homepage/dashboard.dart';
import 'package:capstone/screens/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends StatefulWidget {
  const AuthProvider({Key? key}) : super(key: key);

  @override
  AuthProviderState createState() => AuthProviderState();
}

class AuthProviderState extends State<AuthProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const Dashboard();
          } else {
            return const Login1();
          }
        },
      ),
    );
  }
}
