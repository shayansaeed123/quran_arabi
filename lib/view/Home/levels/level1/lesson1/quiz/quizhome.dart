
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
   List<int?> selectedIndices = [];
  List<String?> selectedOptions = [];
  List<dynamic> alldata = [];
  bool isLoading = true;
  String Qstatus = '';
  String questionId = '';

 

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer;
    fetchDataQuestion();
    print(lesson_id);
  }
int selectedIdx = -1;


Future<void> fetchDataQuestion() async {
  print('gfjgdfg');
    var url = 'https://quranarbi.turk.pk/api/question';
    var body = {
      'lesson_id': lesson_id, // Ensure lesson_id is defined
    };
    print('object $lesson_id');
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('quizzz res ${response.body}');
        setState(() {
          alldata = json.decode(response.body);
          selectedIndices = List<int?>.filled(alldata.length, null);
          selectedOptions = List<String?>.filled(alldata.length, null);
          isLoading = false;
        });
      } else {
        print('Post request failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


Future<void> answer() async {
  var url = 'https://quranarbi.turk.pk/api/userAnswer';  
  print('lessen id $lesson_id');
  var body = {
    'user_id': '6',
    'question_id': questionId.toString(),
    'status': Qstatus.toString(),
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
    print('Ans response ${response.body}');
  } else {
    print('Post request failed with status: ${response.statusCode}');
  }
    if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
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

// single work 
// bool selected=false;
// int? selectedIndex;
// String selectedOption = '';
// List<dynamic> alldata = [];
// Future<List<dynamic>> fetchDataQuestion() async {
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
//     alldata = json.decode(response.body);
//     // if(jsonResponse==null){
//     //   return jsonResponse.map((data) => quizhomemodel.fromJson(data)).toList();
//     // }
//     print('all data $alldata');
//   return alldata;
//   } else {
//     throw Exception('Unexpected error occured!');
//   }
// } 


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
      child: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : alldata.isEmpty
                    ? Center(child: Text('No data found'))
                    : ListView.builder(
                        itemCount: alldata.length + 1, // Additional item for the "Next" container
                        itemBuilder: (context, index) {
                          if (index == alldata.length) {
                            // Show the "Next" container at the end of the list
                            return Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage("assets/images/button.png"),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Your next button action
                                },
                                child: Center(child: Text('Next')),
                              ),
                            );
                          }
                          var question = alldata[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 12, bottom: 12, right: 8, left: 8),
                                    margin: EdgeInsets.only(
                                        top: 20, right: 5, left: 5, bottom: 7),
                                    width:
                                        MediaQuery.of(context).size.width * 0.99,
                                    height:
                                        MediaQuery.of(context).size.height * 0.15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/question.png"),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        question['title'].toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 3 / 1.5,
                                    ),
                                    itemCount: question['options'].length,
                                    itemBuilder: (context, optionIndex) {
                                      var option =
                                          question['options'][optionIndex];
                                      var status =
                                         question['options'][optionIndex]
                                              ['status'];
                                      var question_id =
                                         question['options'][optionIndex]
                                              ['question_id'];     
                                      bool isSelected = selectedIndices.length >
                                              index &&
                                          selectedIndices[index] == optionIndex;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndices[index] = optionIndex;
                                            questionId = question_id;
                                            Qstatus = status;
                                            selectedOptions[index] = status;
                                            print('status $Qstatus');
                                            print('Question Id $questionId');
                                            print(selectedOptions);
                                           setState(() {});
                                            answer();
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/images/ans.png"),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  option['title'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          0.015),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    )


// single work
    // Expanded(
    //           child: Column(
    //             children: [
    //                         Expanded(
    //                 child: FutureBuilder<List<dynamic>>(
    //                   future: fetchDataQuestion(),
    //                   builder: (context, snapshot) {
    //                     if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(child: CircularProgressIndicator());
    //                     } else if (snapshot.hasError) {
    //           return Text('Error: ${snapshot.error}');
    //                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //           return Text('No data found');
    //                     } else {
    //           return ListView.builder(
    //             itemCount: snapshot.data!.length,
    //             itemBuilder: (context, index) {
    //               var question = snapshot.data![index];
    //               return Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   if (question['id'] == 6)
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                       padding: EdgeInsets.only(top: 12,bottom:12,right:8,left:8),
    //                       margin: EdgeInsets.only(top:20,right: 5,left: 5,bottom: 7),
    //                           width: MediaQuery.of(context).size.width*0.99,
    //                           height: MediaQuery.of(context).size.height*0.15,
    //                           decoration: BoxDecoration(
                                
    //                             image: DecorationImage(
    //                               fit: BoxFit.cover,
    //                               image: AssetImage("assets/images/question.png"))),
    //                           child:Center(child: Text(
    //                           question['title'].toString(),
    //                           style: TextStyle(color: Colors.black),
    //                         ),)
    //                         ),   
    //                       GridView.builder(
    //           shrinkWrap: true,
    //           physics: NeverScrollableScrollPhysics(),
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2, // Number of columns in the grid
    //             crossAxisSpacing: 10.0,
    //             mainAxisSpacing: 10.0,
    //             childAspectRatio: 3 / 1.5,
    //           ),
    //           itemCount: question['options'].length,
    //           itemBuilder: (context, optionIndex) {
    //             var option = question['options'][optionIndex];
    //             var status = question['options'][optionIndex]['status'];
    //             bool isSelected = selectedIndex == optionIndex;
    //             return GestureDetector(
    //               onTap: () {
    //                 setState(() {
    //                   selectedIndex = optionIndex;
    //                   selectedOption = status;
    //                   print(selectedOption);
    //                 });
    //               },
    //               child: Stack(
    //                 children: [
    //                   Container(
    //                     // width: MediaQuery.of(context).size.width * 0.99,
    //                     // height: MediaQuery.of(context).size.height * 0.05,
    //                     decoration: BoxDecoration(
    //                       image: DecorationImage(
    //                         fit: BoxFit.cover,
    //                         image: AssetImage("assets/images/ans.png"),
    //                       ),
    //                     ),
    //                     child: Center(
    //                       child: Text(
    //                         option['title'].toString(),
    //                         style: TextStyle(color: Colors.black),
    //                       ),
    //                     ),
    //                   ),
    //                   if (isSelected)
    //                     Positioned(
    //                       top: 8,
    //                       right: 8,
    //                       child: Icon(
    //                         Icons.check_circle,
    //                         color: Colors.green,
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //             );
    //           },
    //                     ),
    //                         SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                            
    //                         // ...question['options'].map<Widget>((option) {
    //                         //   return Text(
    //                         //     option['title'].toString(),
    //                         //     style: TextStyle(color: Colors.black),
    //                         //   );
    //                         // }).toList(),
    //                       ],
    //                     ),
    //                 ],
    //               );
    //             },
    //           );
    //                     }
    //                   },
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //         Container(
    //                         width: MediaQuery.of(context).size.width*1,
    //                         height: MediaQuery.of(context).size.height*0.1,
    //                         decoration: BoxDecoration(
    //                           image: DecorationImage(
    //                             fit: BoxFit.fitHeight,
    //                             image: AssetImage("assets/images/button.png"))),
    //                         child:InkWell(
    //                           onTap: (){

    //                           },
    //                           child: Center(child:  Text('Next')))
    //                       ),
      
          ],
          
        ),
      ),),
    );
  }
}