import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../function/functions.dart';
import '../../model/images_get.dart';
import '../../model/lesson_data.dart';
import 'levels/level1/level1.dart';
import 'header.dart';
import 'menubar.dart';
import 'package:http/http.dart' as http;
import 'package:quran_arabi/database/mysharedpreferece.dart';

import 'networkheader.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
//   Future<List<imageget>> fetchData() async {
//     var url =Uri.parse("https://quranarbi.turk.pk/api/images");
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     return jsonResponse.map((data) => imageget.fromJson(data)).toList();
//   } else {
//     throw Exception('Unexpected error occured!');
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: 30,
          color: Color(0xff1c4b5e),
          // decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.bottomLeft,
              //     end: Alignment.bottomRight,
              //     colors: <Color>[
              //   Color(0xff1c4b5e),
              //   Color(0xff006064),
              // ])
              // ),
        ),
        SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   FutureBuilder<List<imageget>>(
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
                                return Column(children: [if(snapshot.data![index].id==1)...{
                                  Headernetwork(linkapi+imageurl, '', Colors.white,
                      true)
                                }],); 
                            });
                }}
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.55,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            },
          ), 
                  
                 
                 TopMenu(false, false, false, false, false,false,false),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            //--------------------------------------------
                            builder: (context) => Level1(),
                          ));
                    },
                    child: Container(
                     
                      height: MediaQuery.of(context).size.height*0.15,
                      width: MediaQuery.of(context).size.width*0.88,
                      child: Card(
                        // margin: EdgeInsets.symmetric(horizontal: 30),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                           Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Text(
                                              ' قرآنی عربی',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontFamily: 'Al',
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                          'Level 1',
                                          style: TextStyle(
                                            fontSize: 18,
                                            // fontFamily: 'Al',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                             ],
                           ),
                                       
                          SizedBox(
                                height: MediaQuery.of(context).size.height*0.2,
                                width: MediaQuery.of(context).size.width*0.30,
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
                                      return Column(children: [if(snapshot.data![index].id==6)...{
                                                                    SizedBox(
                                                                      // height: MediaQuery.of(context).size.height*0.15,
                                                                      child: 
                                                                    Image.network(linkapi+imageurl)
                                                                    ),
                                                    //             Headernetwork(linkapi+imageurl, '', Colors.black,
                                                    // true)
                                      }],); 
                                      });  
                                            
                                              }}
                                            return SizedBox(
                                              height: MediaQuery.of(context).size.height*0.02,
                                              width: MediaQuery.of(context).size.width,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                              )],
                        )
                        
                        
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ListTile(title:  Text(
                                "Today's Verse",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                          subtitle: 
                          
                              Text(
                                "Surah Al-An'am [162]",
                                style: TextStyle(fontSize: 13),
                              ),
                            
                          ),
                          Text(
                            'قُلْ اِنَّ صَلَاتِيْ وَنُسُكِيْ وَمَحْيَايَ وَمَمَاتِيْ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Al'),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'کہہ دو کہ میری نماز اور میری عبادت اور میرا جینا اور میرا مرنا سب اللہ رب العالمین ہی کے لیے ہے',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Alvi'),
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  
}
