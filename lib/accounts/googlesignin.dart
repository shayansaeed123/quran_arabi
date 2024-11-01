import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:quran_arabi/view/Home/dashboard.dart';
import '../database/mysharedpreferece.dart';
import 'package:quran_arabi/repo/quran_arabi_repo.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  // quranArabiRepository repo = quranArabiRepository();
   final FirebaseAuth _auth = FirebaseAuth.instance;
   late bool isLoading;

   

    Future<void> postData() async {
  var url = 'https://quranarbi.turk.pk/api/verifyAppUser';
  
  var body = {
    // 'email': MySharedPrefrence().get_user_email().toString(),
    'email': 'Shayan11@gmail.com',
    'verified': '1',
  };
  
  var headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode == 200) {
 
    print('Post request successful!');
   final Map<String, dynamic> data = json.decode(response.body);

   setState(() {});
   MySharedPrefrence().set_user_id(data['user_id']);
   print(MySharedPrefrence().get_user_id());
   setState(() {});

   
    print("Id no");
    print(body);
      //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
      // MaterialPageRoute(
      //       builder: (context) =>
      //           WillPopScope(onWillPop: () async => false, child: Home()));

    
    print(response.body);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WillPopScope(child: Home(), onWillPop: () async => false)));
    
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
      setState(() {});
      MySharedPrefrence().set_user_email(user.email);
      setState(() {});
      print(MySharedPrefrence().get_user_name().toString());
      // print(MySharedPrefrence().getUserLoginStatus());
      print(MySharedPrefrence().get_user_email().toString());
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> WillPopScope(child: Home(), onWillPop: () async => false)));
        setState(() {
        postData();
         });
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
    print(MySharedPrefrence().get_user_id().toInt());
    print(MySharedPrefrence().get_user_email().toString());
    login(context);
  }

  void login(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    // print('email ${user}');

    if(MySharedPrefrence().get_user_id() != 0){
      Timer(Duration(seconds: 0), () {
        print('check user login ${MySharedPrefrence().get_user_id()}');
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WillPopScope(onWillPop: () async => false, child: Home())),
      );
      });
    }else{
      Timer(Duration(seconds: 0), () {
        print('check user without login ${MySharedPrefrence().get_user_id()}');
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
                  // signInWithGoogle();
                  postData();
                  // repo.signInWithGoogle(context);
                  // print(repo.Registration_text);
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