import 'package:http/http.dart' as http;
import 'package:quran_arabi/database/mysharedpreferece.dart';
import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quran_arabi/view/Home/dashboard.dart';

class quranArabiRepository{



  String _Registration_text = '';
  String get Registration_text => _Registration_text;


  Future<void> postData(BuildContext context) async {
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

   MySharedPrefrence().set_userid(data['user_id']);
   print(MySharedPrefrence().get_userid());

   
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

  signInWithGoogle(BuildContext context) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      // setState(() {
      //   isLoading = false;
      // });
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
      _Registration_text = user!.displayName.toString();
      // MySharedPrefrence().set_user_name(user!.displayName);
      // MySharedPrefrence().setUserLoginStatus(true);
      MySharedPrefrence().set_user_email(user.email);
      print(Registration_text);
      // print(MySharedPrefrence().get_user_name());
      // print(MySharedPrefrence().getUserLoginStatus());
      print(MySharedPrefrence().get_user_email());
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> WillPopScope(child: Home(), onWillPop: () async => false)));
        // setState(() {
        postData(context);
        //  });
    } catch (e) {
      print('Error $e');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
}