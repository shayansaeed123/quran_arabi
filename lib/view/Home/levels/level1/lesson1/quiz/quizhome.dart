
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:qurani_arabi_flutter/view/Home/menubar.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_html/flutter_html.dart';
import '../../../../../../function/functions.dart';
import '../../../../../../model/images_get.dart';
import '../../../../../../model/quizmodel.dart';
import '../../../../../../res/player.dart';
import '../../../../../../res/reusable.dart';
import '../../../../menubar.dart';
import '../../../../networkheader.dart';


class QuizHomePage extends StatefulWidget {
   QuizHomePage({required this.lesson_id});
  String lesson_id;
  @override
  State<QuizHomePage> createState() => _QuizHomePageState(lesson_id:lesson_id);
}
class _QuizHomePageState extends State<QuizHomePage> {
  _QuizHomePageState({required this.lesson_id});
  String lesson_id;
  

  AudioPlayer audioPlayer = AudioPlayer();
  bool? Ansstatus;
  bool selected=false;

 

  @override

    void initstate(){
      super.initState();
        // fetchData();
        audioPlayer; 
        fetchDataQuestion();
    }
int selectedIdx = -1;
// List<String> texts = ["Text 1", "Text 2", "Text 3", "Text 4"];
//   Future<List<quizhomemodel>> fetchData() async {
//   var url = 'https://quranarbi.turk.pk/api/question';  
//   print('lessen id $lesson_id');
//   var body = {
//     'lesson_id': lesson_id,
//   };
//   var headers = {
//     'Content-Type': 'application/json',
//   };
//   var response = await http.post(
//     Uri.parse(url),
//     headers: headers,
//     body: jsonEncode(body),
//   );
//   if (response.statusCode == 200) {
//     print('quizzz res ${response.body}');
//   } else {
//     print('Post request failed with status: ${response.statusCode}');
//   }
//     if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     if(jsonResponse==null){
//       return jsonResponse.map((data) => quizhomemodel.fromJson(data)).toList();
//     }
//   return 
//  jsonResponse.map((data) => quizhomemodel.fromJson(data)).toList();
//   } else {
//     throw Exception('Unexpected error occured!');
//   }
// }
List<dynamic> alldata = [];
Future<List<dynamic>> fetchDataQuestion() async {
  var url = 'https://quranarbi.turk.pk/api/question';  
  print('lessen id $lesson_id');
  var body = {
    'lesson_id': lesson_id,
  };
  var headers = {
    'Content-Type': 'application/json',
  };
  var response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    print('quizzz res ${response.body}');
  } else {
    print('Post request failed with status: ${response.statusCode}');
  }
    if (response.statusCode == 200) {
    alldata = json.decode(response.body);
    // if(jsonResponse==null){
    //   return jsonResponse.map((data) => quizhomemodel.fromJson(data)).toList();
    // }
    print('all data $alldata');
  return alldata;
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<void> answer() async {
  var url = 'https://quranarbi.turk.pk/api/userAnswer';  
  print('lessen id $lesson_id');
  var body = {
    'user_id': lesson_id,
    'question_id': lesson_id,
    'status': lesson_id,
  };
  var headers = {
    'Content-Type': 'application/json',
  };
  var response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    print('quizzz res ${response.body}');
  } else {
    print('Post request failed with status: ${response.statusCode}');
  }
    if (response.statusCode == 200) {
    alldata = json.decode(response.body);
    // if(jsonResponse==null){
    //   return jsonResponse.map((data) => quizhomemodel.fromJson(data)).toList();
    // }
    print('all data $alldata');
  } else {
    throw Exception('Unexpected error occured!');
  }
}



void playAudioFromUrl(String url) async {
  var result = await audioPlayer.play() as int;
  if (result == 1) {
    print('Audio playing');
  } else {
    print('Error playing audio');
  }
}


 alerdialogans(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
}

int? selectedIndex;
String selectedOption = '';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  
          Container(
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
                                  itemCount: 
                                  snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index) { 
                                  var imageurl=snapshot.data![index].featured_image;
                                  var linkapi="https://quranarbi.turk.pk/";
                                  return Column(children: [if(snapshot.data![index].id==7)...{
                               Headernetwork(linkapi+imageurl, '', Colors.white, true),
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
            TopMenu(false, false, false, false, false),

            Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: fetchDataQuestion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data found');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var question = snapshot.data![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (question['id'] == 6)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                        padding: EdgeInsets.only(top: 12,bottom:12,right:8,left:8),
                        margin: EdgeInsets.only(top:20,right: 5,left: 5,bottom: 7),
                            width: MediaQuery.of(context).size.width*0.99,
                            height: MediaQuery.of(context).size.height*0.15,
                            decoration: BoxDecoration(
                              
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/question.png"))),
                            child:Center(child: Text(
                            question['title'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),)
                          ),   
                        GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 3 / 1.5,
            ),
            itemCount: question['options'].length,
            itemBuilder: (context, optionIndex) {
              var option = question['options'][optionIndex];
              var status = question['options'][optionIndex]['status'];
              bool isSelected = selectedIndex == optionIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = optionIndex;
                    selectedOption = status;
                    print(selectedOption);
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.99,
                      // height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/ans.png"),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option['title'].toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                          Container(
                            width: MediaQuery.of(context).size.width*1,
                            height: MediaQuery.of(context).size.height*0.1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage("assets/images/button.png"))),
                            child:InkWell(
                              onTap: (){

                              },
                              child: Center(child:  Text('Next')))
                          )   
                          // ...question['options'].map<Widget>((option) {
                          //   return Text(
                          //     option['title'].toString(),
                          //     style: TextStyle(color: Colors.black),
                          //   );
                          // }).toList(),
                        ],
                      ),
                  ],
                );
              },
            );
          }
        },
      ),
    )
           
//           FutureBuilder<List<quizhomemodel>>(
//                 future: fetchData(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return 
//                     Expanded(
//                       child: Container(
                       
//                       margin: EdgeInsets.only(left: 5,right: 5),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
//                         image: DecorationImage(
//                           fit: BoxFit.fitWidth,
//                           image: AssetImage("assets/bg.jpg"))),
//                       child:
//                        ListView.builder(
//                           shrinkWrap: true,
//                           scrollDirection: Axis.vertical,
//                           physics: ScrollPhysics(),
//                                     itemCount: 1,
//                                     itemBuilder: (BuildContext context, int index) {
//                         // var imageurl=snapshot.data![index].featured_image;
//                         // var linkapi="https://quranarbi.turk.pk/public/public/";
//                         var answer=snapshot.data![index];
//                         int sizefontapi=15;
//                         int borderwidth=0;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
                         
//                          if(snapshot.data![index].type_id=="2")...{
//                                            Container(
//                         padding: EdgeInsets.only(top: 12,bottom:12,right:8,left:8),
//                         margin: EdgeInsets.only(top:20,right: 5,left: 5,bottom: 7),
//                             width: MediaQuery.of(context).size.width*0.99,
//                             height: MediaQuery.of(context).size.height*0.15,
//                             decoration: BoxDecoration(
                              
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage("assets/images/question.png"))),
//                             child:Center(child: Image.network('https://quranarbi.turk.pk/public/public/${snapshot.data![index].featured_image}'),)
//                           ),
//                           }
                        
//                          else if(snapshot.data![index].type_id=="6")...{
                                               
//                               Container(
//                         padding: EdgeInsets.all(8),
//                         margin: EdgeInsets.only(top:20,right: 10,left: 10,bottom: 10),
//                           width: MediaQuery.of(context).size.width*0.99,
//                             height: MediaQuery.of(context).size.height*0.15,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage("assets/images/question.png"))),
//                             // child:Center(child: Html(
//                             //   data: """
//                             //     <div style="text-align: center;">
//                             //  " ${snapshot.data![index].title}"
//                             //     </div>
//                             //   """, ),
//                             //   )
//                               ),
//                               }
//                         else if(snapshot.data![index].type_id=="3")...{
                          
//                         //   // if(snapshot.data![index].audiourl==null||snapshot.data![index].audiourl=="")...{                          
//                         //  reusablebordercontainer(context, 0.90, 0.88, 5, reusableocontaineraudio(context, 0.88, 
//                         //        "Audio Link Missing", (){
//                         //         })),
                          
//                         //   }
//                         //   //  else if(snapshot.data![index].audiourl!=null||snapshot.data![index].audiourl!="")...{                          
                          
//                               Container(
//                         padding: EdgeInsets.all(8),
//                         margin: EdgeInsets.only(top:20,right: 10,left: 10,bottom: 10),
                        
//                             width: MediaQuery.of(context).size.width*0.99,
//                             height: MediaQuery.of(context).size.height*0.15,
//                             decoration: BoxDecoration(
                              
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage("assets/images/question.png"))),
//                             child:Center(child:reusableocontaineraudio(context, 0.8, 
//                               "",(){
                         
//                                 PlayAudio("https://quranarbi.turk.pk/public/public/${snapshot.data![index].audiourl}",context);}),)
//                           ),},
//                               Container(
//                                 margin: EdgeInsets.only(bottom: 10),
//                                padding: EdgeInsets.only(top: 10),
//                                     width: MediaQuery.of(context).size.width*0.95,
//                                     height: MediaQuery.of(context).size.height*0.25,
//                                     child:   
//                                     GridView.builder(
                                      
//                                        itemCount: 4,
//                                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                          crossAxisSpacing: 5,
//                           mainAxisSpacing: 5, 
//                                     mainAxisExtent: 80,
//                                     crossAxisCount: 2), itemBuilder: (context,index){
//                               var length=answer.options!.length;
//                                 return 
                                
                                
//                                 InkWell( 
//                                 onTap: (){
//                                   setState(() {
//                 selectedIdx = index; // Update the selected index
//               });
//                                   print(snapshot.data![index]);
//                                   print(index);
//                                   if(answer.options[index]['status']=="0"){
//                                   // if
//                                   // alerdialogans(context, "Wrong Answer!", 'Oops! That was incorrect. Please try again.');
//                                  setState(() {
                                   
//                                  Ansstatus=false;
//                                  print(Ansstatus);
//                                  });
//                                  }                                 
//                                  else if(answer.options[index]['status']=="1"){
//                                 //  setState(() {
//                                    setState(() {

//                               Ansstatus=true;
// print(Ansstatus);     
                                
//                                    });
//                                 //  });
//                                   // if
//                                   // alerdialogans(context, "Congratulations!", 'That\'s the correct answer.');
//                                  }
//                                   print(answer.options[index]['status']);
                               
//                                 },
//                                   child:
//                                   Container(
//                                     padding: EdgeInsets.all(2),
//                                     // margin: EdgeInsets.all(10),
//                                   // width: MediaQuery.of(context).size.width*0.8,
//                                   // height: MediaQuery.of(context).size.height*0.3,
//                                                       decoration: BoxDecoration(
                                                              
//                                         image: DecorationImage(
//                                           fit: BoxFit.contain,
//                                                     image: AssetImage("assets/images/ans.png")),
//                                  ),
//                                   child:Center(child:
//                                   Text('${answer.options[index]['title'].toString()}',style: TextStyle(
//                                     color: selectedIdx==index?Colors.green:Colors.black, 
//                                     fontWeight: selectedIdx==index?FontWeight.bold:FontWeight.normal,
//                                     fontSize: selectedIdx==index?20:16),
//                                   ))
//                                   ),
//                                 );
                              
//                                     }),
//                               ),
//                               InkWell(
//                                 onTap: (){
//                                   if(Ansstatus==false){
//                                   // if
//                                   alerdialogans(context, "Wrong Answer!", 'Oops! That was incorrect. Please try again.');
//                                  }                                 
//                                  else if(Ansstatus==true){
//                                   // if
//                                   alerdialogans(context, "Congratulations!", 'That\'s the correct answer.');
//                                  }
//                                 },
//                                 child: Container(
//                                       padding: EdgeInsets.all(5),
//                                       // margin: EdgeInsets.all(10),
//                                     width: MediaQuery.of(context).size.width*0.9,
//                                     height: MediaQuery.of(context).size.height*0.1,
//                                                         decoration: BoxDecoration(
                                                                
//                                           image: DecorationImage(
//                                             fit: BoxFit.fitWidth,
//                                                       image: AssetImage("assets/images/button.png")),
//                                    ),
//                                     child:Center(child:
//                                     Text("submit",style:TextStyle(color: Colors.white,fontSize: 25)
//                                     ))
//                                     ),
//                               ),
                      
                                                        
                      
                      
//                           ],
//                         );
//                                     }),
//                       ),
//                     );
//                   }  





//                   return SizedBox(
//                     height: MediaQuery.of(context).size.height*0.55,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
                      
                      
                      
//                       ],
                    
//                     ),
//                   );
//                 },
//                       ),




          // FutureBuilder<List<quizhomemodel>>(
          //       future: fetchData(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           return 
          //           Expanded(
          //             child: Container(
          //                              height:400,
          //               margin:  EdgeInsets.only(left: 5,right: 5),
          //               padding: EdgeInsets.all(15),
          //               decoration: BoxDecoration(
          //                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          //                 // image: DecorationImage(
          //                 //   fit: BoxFit.fitWidth,
          //                 //   image: AssetImage("assets/bg.jpg"))
          //                   ),
          //               child: ListView.builder(
          //                 shrinkWrap: true,
          //                 scrollDirection: Axis.vertical,
          //                 physics: ScrollPhysics(),
          //                           itemCount: 
          //                           snapshot.data!.length,
          //                           itemBuilder: (BuildContext context, int index) {
          //               // var imageurl=snapshot.data![index].featured_image;
          //               var linkapi="https://quranarbi.turk.pk/public/public/";
          //               int sizefontapi=15;
          //               int borderwidth=0;
          //               return Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text(snapshot.data![index].id.toString()),
          //                     // Text(snapshot.data![index].description.toString()),
          //                   // Text(
                        
          //                   //   snapshot.data![index].title==null?"null":snapshot.data![index].description.toString()
          //                   // )
                        
          //                 ],
          //               );
          //                           }),
          //             ),
          //           );
          //         }  





          //         return SizedBox(
          //           height: MediaQuery.of(context).size.height*0.55,
          //           width: MediaQuery.of(context).size.width,
          //           child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               CircularProgressIndicator(),
          //             ],
                    
          //           ),
          //         );
          //       },
          //             ),
                      // Text("",style: TextStyle(fontSize: ),)
          ],
          
        ),
      ),),
    );
  }
}