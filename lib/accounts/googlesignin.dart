import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:quran_arabi/view/Home/dashboard.dart';
import '../database/mysharedpreferece.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   final FirebaseAuth _auth = FirebaseAuth.instance;
   late bool isLoading;

   

    Future<void> postData() async {
  var url = 'https://quranarbi.turk.pk/api/verifyAppUser';
  
  var body = {
    'email': MySharedPrefrence().get_user_email(),
    'verified': '1',
  };
  
  var headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(
    Uri.parse(url),
    // headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
 
    print('Post request successful!');
   final Map<String, dynamic> data = json.decode(response.body);

   MySharedPrefrence().set_user_ID(data['user_id']);
   print(MySharedPrefrence().get_user_ID());

   
    print("Id no");
    print(body);
      //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
      // MaterialPageRoute(
      //       builder: (context) =>
      //           WillPopScope(onWillPop: () async => false, child: Home()));

    
    print(response.body);
    
  } else {
     _showAlertDialog(context);
    print('Post request failed with status: ${response.statusCode}');
  }
}

void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text("Id Password does not matched"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      setState(() {
        isLoading = false;
      });
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        // idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        final String? email = user.email;
      
        print('User email: $email');
        // You can now use the email variable
      }
      MySharedPrefrence().set_user_name(user!.displayName);
      // MySharedPrefrence().setUserLoginStatus(true);
      MySharedPrefrence().set_user_email(user.email);
      print(MySharedPrefrence().get_user_name());
      // print(MySharedPrefrence().getUserLoginStatus());
      print(MySharedPrefrence().get_user_email());
      Navigator.push(context, MaterialPageRoute(builder: (context)=> WillPopScope(child: Home(), onWillPop: () async => false)));
        postData();
    } catch (e) {
      print('Error $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login(context);
  }

  void login(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    print('email ${user}');

    if(user != null){
      Timer(Duration(seconds: 0), () {
        print('check user login ${user}');
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WillPopScope(onWillPop: () async => false, child: Home())),
      );
      });
    }else{
      Timer(Duration(seconds: 0), () {
        print('check user without login ${user}');
      //   Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           WillPopScope(onWillPop: () async => false, child: SignInScreen())),
      // );
      });
    }
  }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_main.png',
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Quran-e-Arabic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                  ),
                  icon: Image.asset(
                    'assets/googlelogo.png',
                    height: 24,
                  ),
                  label: Text('Sign in with Google'),
                  onPressed: () {
                  signInWithGoogle();
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}