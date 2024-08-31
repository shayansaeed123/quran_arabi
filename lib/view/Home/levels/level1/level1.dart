import 'dart:convert';
import 'dart:math';

// import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
// import 'package:qurani_arabi_flutter/view/Home/header.dart';

import '../../../../function/functions.dart';
import '../../../../model/images_get.dart';
import '../../../../model/lesson_data.dart';
import '../../menubar.dart';
import '../../networkheader.dart';
import 'lesson1/Lessons.dart';


class Level1 extends StatefulWidget {
   Level1({super.key});

  @override
  State createState() => Level1State();
}

class Level1State extends State<Level1> {
   
Future<List<LessonData>> fetchData() async {
    var url =Uri.parse("https://quranarbi.turk.pk/api/categories");
    final response = await http.get(url);
    if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => LessonData.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
          body: Column(
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
                                return Column(children: [if(snapshot.data![index].id==7)...{
                             Headernetwork(linkapi+imageurl, '', Colors.white, true),
                      //             Headernetwork(linkapi+imageurl, '', Colors.black,
                      // true)
                                }],); 
                                });  
              
                }}
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            },
          ),
              
               TopMenu(false, false, false, false, false,false),
          //  video_button('قرآنی عربی کا تعارف', 'intro.mp4'),
            FutureBuilder<List<LessonData>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.connectionState==ConnectionState.done){
                  return    Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/bg.jpg"))),
                    child: GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: 
                        SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 5, 
                        mainAxisExtent: 80,
                        // childAspectRatio: 6/6,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell( 
                          onTap: (){
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context)=>
                            Lessons(lesson_id:snapshot.data![index].lesson_id.toString()))
                            //  MyWidget()
                            );
                          },
                            child: Container(
                              margin: EdgeInsets.only(left: 5,right: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage("https://quranarbi.turk.pk/${snapshot.data![index].featured_image}"))),
                              // child: Image.network("https://quranarbi.turk.pk/"+
                              //             snapshot.data![index].featured_image.toString()),
                            ),
                          );
                        }
                        ),
                  ),
                );
                }
                else{
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.30,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );    
                }
              }
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
          ), ]
          ),
    ));
  }
}
