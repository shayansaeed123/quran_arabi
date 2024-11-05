import 'package:flutter/material.dart';
import 'package:quran_arabi/view/hadith/hadith_books.dart';
// import 'package:qurani_arabi_flutter/view/Tasbeeh/Tasbeeh.dart';

import '../../function/functions.dart';
import '../../model/images_get.dart';
import '../PrayerTimig/PrayerTiming.dart';
import '../Quran/Quran.dart';
import '../Tasbeeh/Tasbeeh.dart';
import '../profile/profilelist.dart';
import 'package:quran_arabi/database/mysharedpreferece.dart';
import 'package:quran_arabi/accounts/googlesignin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class TopMenu extends StatelessWidget {
  bool home, namaz_timings, quran, hadith, tasbeeh,profile,logout;

  TopMenu(this.home, this.namaz_timings, this.quran, this.hadith, this.tasbeeh, this.profile,this.logout);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.07,
      width: MediaQuery.of(context).size.width*0.97,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon:
              Image.asset(home?"assets/icon/Home-Fill.png":"assets/icon/Home.png"),
              onPressed: () {
                if (!home) 
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              
            ),
            IconButton(
              icon: 
              Image.asset(namaz_timings?"assets/icon/Namaz-Timing-Fill.png":"assets/icon/Namaz-Timing.png"),
              onPressed: () {
                if (!namaz_timings) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrayerTiming(),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: 
              Image.asset(quran?"assets/icon/Quran-Fill.png":"assets/icon/Quran.png"), 
              onPressed: () {
                if (!quran) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Quran(),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: Image.asset(hadith?"assets/icon/Hadees-fill.png":"assets/icon/Hadees.png"), 
              onPressed: () {
                if (!hadith) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HadithBooks(),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width*0.18,
              child: FutureBuilder<List<imageget>>(
                future: imagedata(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.connectionState==ConnectionState.done){
                      return  ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                                    itemCount: 
                                    snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) { 
                                    var imageurl=snapshot.data![index].featured_image;
                                    var linkapi="https://quranarbi.turk.pk/";
                                    return Column(children: [if(snapshot.data![index].id==5)...{
                                 IconButton(
                                  iconSize: 1,
                                   icon:
                     Image.asset(tasbeeh?"assets/icon/Tasbeeh-Fill.png":"assets/icon/Tasbeeh.png"),
                onPressed: () {
                  if (!tasbeeh) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Tasbeeh(imagepath:linkapi+imageurl),
                      ),
                    );
                  }
                },
              ),
                                    }],); 
                                    });  
                  
                    }}
                  return      Container(
                    margin: EdgeInsets.only(left:10,right: 10,top: 10,bottom: 13.5),
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.height*0.1,
                    child: Image.asset(tasbeeh?"assets/icon/Tasbeeh-Fill.png":"assets/icon/Tasbeeh.png"));
                },
              ),
            ),
        
               IconButton(
              icon: 
              Image.asset(profile?"assets/images/myprofile.png":"assets/images/myprofile.png"), 
              onPressed: () {
                if (!quran) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => myprofile(),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: 
              Image.asset(logout?"assets/images/myprofile.png":"assets/images/myprofile.png"), 
              onPressed: () async{
                if (!quran)  {
          MySharedPrefrence().logout();
          MySharedPrefrence().setUserLoginStatus(false);
          GoogleSignIn _googleSignIn = GoogleSignIn();
          await _googleSignIn.signOut();
           FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signOut().then((value) {
             Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => WillPopScope(
                                            onWillPop: () async => false,
                                            child: SignInScreen())),
                                  );
          });
          print('User signed out');
        
                }
              },
            ),
           
          ],
        ),
      ),
    );
  }
}