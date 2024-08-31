import 'dart:convert';

import'package:flutter/material.dart';
import 'package:quran_arabi/view/Home/levels/level1/lesson1/gardan.dart';
// import 'package:qurani_arabi_flutter/view/Home/levels/level1/lesson1/quiz/quizhome.dart';
// import 'package:qurani_arabi_flutter/view/levels/lesson1/demo.dart';

import '../../../../../function/functions.dart';
import '../../../../../model/images_get.dart';
import '../../../../../model/lesson_intro_Data.dart';
import 'package:http/http.dart' as http;

import '../../../menubar.dart';
import '../../../header.dart';
import '../../../networkheader.dart';
import 'lesson_description.dart';
import 'quiz/quizhome.dart';

class Lessons extends StatefulWidget {
   Lessons({required this.lesson_id});
  String lesson_id; 
  @override
  State<Lessons> createState() => _LessonsState(lesson_id);
}

class _LessonsState extends State<Lessons> {
  _LessonsState(this.lesson_id);
  String lesson_id;


Future<List<LessonIntroData>> fetchData() async {
    var url =Uri.parse("https://quranarbi.turk.pk/api/subcategories");
    final response = await http.get(url);
    if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => LessonIntroData.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

int imgwidth=1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body:  Column(
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
                height: MediaQuery.of(context).size.height*0.2,
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
           TopMenu(false, false, false, false, false,false),
          //  Container(
          //    margin: EdgeInsets.only(left: 5,right: 5),
          //             padding: EdgeInsets.all(10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          //               image: DecorationImage(
          //                 fit: BoxFit.fitWidth,
          //                 image: AssetImage("assets/bg.jpg"))),
          //   height: MediaQuery.of(context).size.height*0.58,
            
          //    child: 
             FutureBuilder<List<LessonIntroData>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return 
                    Expanded(
                      child:
                  Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/bg.jpg"))),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                      var imageurl=snapshot.data![index].featured_image;
                      var linkapi="https://quranarbi.turk.pk/";
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if(snapshot.data![index].id==13)...{
                            Container(
                             width: MediaQuery.of(context).size.width*0.94,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                                  lesson_id:lesson_id,
                                  sub_category_id: snapshot.data![index].id.toString(),)));
                              },
                              child: Image.network("${linkapi+imageurl}")),
                          ),},
                          if(snapshot.data![index].id==16 )...{
                              Row(  
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                              lesson_id:lesson_id,
                              sub_category_id: snapshot.data![index].id.toString(),)));
                          },child: Image.network("${linkapi+"${snapshot.data![index].featured_image}"}"))),
                          //gardan
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                              lesson_id:lesson_id,
                              sub_category_id: snapshot.data![index+1].id.toString(),)));
                          },child: Image.network("${linkapi+"${snapshot.data![index+1].featured_image}"}")))
                           
                              ],),
                          },   

//gardan
     if(snapshot.data![index].id==14 )...{
                              Row(  
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                              lesson_id:lesson_id,
                              sub_category_id: snapshot.data![index].id.toString(),)));
                          },child: Image.network("${linkapi+"${snapshot.data![index].featured_image}"}"))),
                          //gardan
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Gardan(
                              lesson_id:lesson_id,
                              sub_category_id: snapshot.data![index+1].id.toString(),)));
                          },child: Image.network("${linkapi+"${snapshot.data![index+1].featured_image}"}")))
                           
                              ],),
                          }, 






                          if(snapshot.data![index].id==18  )...{
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                              lesson_id:lesson_id,
                              sub_category_id: snapshot.data![index].id.toString(),)));
                          },child: Image.network("${linkapi+"${snapshot.data![index].featured_image}"}"))),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.45,
                            child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizHomePage(lesson_id: lesson_id,)));
                          },child: Image.network("${linkapi+"${snapshot.data![index+1].featured_image}"}")))
                           
                              ],),
                          },
                          // if(snapshot.data![index].id==18)...{
                          //   Container(
                          //   width: MediaQuery.of(context).size.width*0.45,
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>LessonsDescription(
                          //         sub_category_id: snapshot.data![index].id.toString(),
                          //         lesson_id:lesson_id,
                          //         )));
                          //     },child: Image.network("${linkapi+imageurl}")),
                          // ),
                          // InkWell(
                          //   onTap: (){
                          //      Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizHomePage()));
                          //   },
                          //   child: Container(
                          //   width: MediaQuery.of(context).size.width*0.99,
                          //   height: MediaQuery.of(context).size.height*0.147,
                          //   decoration: BoxDecoration(
                              
                          //     image: DecorationImage(
                          //       fit: BoxFit.fitHeight,
                          //       image: AssetImage("assets/images/question.png"))),
                          //   child:Center(child:Text("امتحان",style: TextStyle(fontSize: 30),))
                          // ),),
                          // متحان
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizHomePage()));
                            
                          // } ,
                        
                            
                        ],
                      );
                                  }),
                  )
                    );
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
                      ),
          //  ), 
        ],
      ),),
    );
  }
}