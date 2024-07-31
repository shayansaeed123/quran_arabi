import 'package:flutter/material.dart';

import '../googlesign.dart';
// import 'package:google_sign_in/google_sign_in.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future signIn()async{
    await GoogleSignInApi.login();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      ElevatedButton.icon(onPressed: signIn, icon: Icon(Icons.login), label: Text("Login with google"))
    ],));
  }
}