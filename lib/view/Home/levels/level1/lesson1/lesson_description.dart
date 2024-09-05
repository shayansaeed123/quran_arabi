import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../../function/functions.dart';
import '../../../../../model/images_get.dart';
import '../../../../../model/lesson_intro_data_items.dart';
import '../../../../../res/player.dart';
import '../../../../../res/reusable.dart';
import '../../../../../res/video.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:video_player/video_player.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;
import '../../../menubar.dart';
import '../../../networkheader.dart';

class LessonsDescription extends StatefulWidget {
   LessonsDescription({required this.sub_category_id,required this.lesson_id});
  String sub_category_id;
  String lesson_id;

  @override
  State<LessonsDescription> createState() => _LessonsDescriptionState(sub_category_id: sub_category_id,lesson_id:lesson_id);
}
YoutubeExplode youtubeExplode = YoutubeExplode();

class _LessonsDescriptionState extends State<LessonsDescription> {
  _LessonsDescriptionState({required this.sub_category_id,required this.lesson_id});
  String sub_category_id;
  String lesson_id;
   Timer? timer2;

  late Future<List<LessonIntroDataitems>> futureContents;

    Future<void> postData() async {
  var url = 'https://quranarbi.turk.pk/api/contents';
  
  var body = {
    'lesson_id': lesson_id,
    'sub_category_id': sub_category_id,
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
    // Successful request
    fetchData();
  
    print('Post request successful!');
    print("Id no");
    print(body);
    
    print(response.body);
    
  } else {
    // Request failed
    print('Post request failed with status: ${response.statusCode}');
  }
}
 
// AudioPlayer audioPlayer = AudioPlayer();

var notdatafournd=[];

  Future<List<LessonIntroDataitems>> fetchData() async {
     var url = 'https://quranarbi.turk.pk/api/contents';
  
  var body = {
    'lesson_id': lesson_id,
    // 'lesson_id': 28,

    'sub_category_id': sub_category_id,
  // 'sub_category_id':15
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
    // Successful request
    // fetchData();

    print('Post request successful!');
    print("Id no");
    print(body);
    print(response.body);
    
  } else {
    // Request failed
    print('Post request failed with status: ${response.statusCode}');
  }
    // var url =Uri.parse("https://quranarbi.turk.pk/api/contents");
    // final response = await http.get(url);
    if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    if(jsonResponse==null){
      
      return jsonResponse.map((data) => LessonIntroDataitems.fromJson(data)).toList();
    }
  return 
 jsonResponse.map((data) => LessonIntroDataitems.fromJson(data)).toList();
   
  } else {
    throw Exception('Unexpected error occured!');
  }
}


int imgwidth=1;



AudioPlayer audioPlayer = AudioPlayer();

void playAudioFromUrl(String url) async {
  var result = await audioPlayer.play() as int;

  if (result == 1) {
    // Success
    print('Audio playing');
  } else {
    // Error
    print('Error playing audio');
  }
}


String parseHtmlString(String htmlString) {
  final document = htmlParser.parse(htmlString);
  final String parsedString = document.body?.text ?? '';
  return parsedString;
}

  @override
  void initState() {
    super.initState();
    // fetchData();
    //   postData();
      audioPlayer;
    futureContents = gardandata();
  
  }

  Future<List<LessonIntroDataitems>> gardandata() async {
    final response = await http.post(
      Uri.parse('https://quranarbi.turk.pk/api/contents'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lesson_id': widget.lesson_id, 
        'sub_category_id': widget.sub_category_id, 
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<LessonIntroDataitems> dataList = jsonData
          .map((json) => LessonIntroDataitems.fromJson(json))
          .toList();
      // dataList.sort((a, b) => a.id.compareTo(b.id));
      return dataList;
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  Map<String, List<LessonIntroDataitems>> groupDataByGroupId(
      List<LessonIntroDataitems> data) {
    Map<String, List<LessonIntroDataitems>> groupedData = {};
    for (var item in data) {
      var groupId = item.groupId;
      if (groupedData.containsKey(groupId)) {
        groupedData[groupId]!.add(item);
      } else {
        groupedData[groupId] = [item];
      }
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
            TopMenu(false, false, false, false, false,false,false),
              //  video_button('قرآنی عربی کا تعارف', 'intro.mp4'),  
                            // 'قُلْ اِنَّ صَلَاتِيْ وَنُسُكِيْ وَمَحْيَايَ وَمَمَاتِيْ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ',
          FutureBuilder<List<LessonIntroDataitems>>(
                future: futureContents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return 
                    Expanded(
                      child: Container(
                              height:400,
                        margin:  EdgeInsets.only(left: 5,right: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                          // image: DecorationImage(
                          //   fit: BoxFit.fitWidth,
                          //   image: AssetImage("assets/bg.jpg"))
                            ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      // String? fontFamily = snapshot.data![index].fontFamily;
    double? fontSize = double.tryParse(snapshot.data![index].font_size) ?? 14.0;
    String? colorCode = snapshot.data![index].text_color_code;

    Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
                        var imageurl=snapshot.data![index].featured_image;
                        var linkapi="https://quranarbi.turk.pk/public/public/";
                        int sizefontapi=15;
                        int borderwidth=0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(snapshot.data![index].id.toString()),
                              // Text(snapshot.data![index].description.toString()),
                            // Text(
                        
                            //   snapshot.data![index].title==null?"null":snapshot.data![index].description.toString()
                            // )
                        if(snapshot.data![index].type_id=="4")...{
                              if(snapshot.data![index].videolink==null||snapshot.data![index].videolink=="")...{
                              reusablebordercontainer(context, 0.90, 0.88, 3, reusablecontainervideo(context, 0.88,
                               "Video Link Missing", (){
                              //           );
                               }))
                              }
                              else if(snapshot.data![index].videolink!=null||snapshot.data![index].videolink!="")...{
                              reusablebordercontainer(context, 0.90, 0.88, 3, reusablecontainervideo(context, 0.88, 
                              snapshot.data![index].title?.toString() ?? 'Default Title',
                              // snapshot.data![index].title.toString(),
                               (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            HomeScreen(videolink:snapshot.data![index].videolink.toString())
                            ));})) 
                            }}
                        else if(snapshot.data![index].type_id=="2")...{
                                           reusablebordercontainer(context, 2,0.88 ,3,
                        imageurl==null?Text("image here"):
                        Image.network(linkapi+imageurl),
                        )
                          }
                               else if(snapshot.data![index].type_id=="6")...{
                               if(snapshot.data![index].text_type=="1")...{  
          reusablebordercontainer(
      context, 
      2, 
      0.88, 
      3, 
      Text(
        parseHtmlString(snapshot.data![index].title_arbic?.toString() ?? ''),
        // snapshot.data![index].title_arbic?.toString() ?? 'Default title arabic',
        // snapshot.data![index].description.toString(),
        style: TextStyle(
          fontSize: fontSize,
           fontFamily: "Muhammadi Naskh",
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    ),
   },
   if (snapshot.data![index].text_type == "2") ...{
  reusablebordercontainer(
    context,
    2,
    0.88,
    3,
    Text(
      parseHtmlString(snapshot.data![index].description?.toString() ?? ''),
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
      textAlign: TextAlign.center,
    ),
  ),

  //  if(snapshot.data![index].text_type=="2")...{  
  //     reusablebordercontainer(
  //     context, 
  //     2, 
  //     0.88, 
  //     3, 
  //     Text(
  //       snapshot.data![index].description?.toString() ?? '',
  //       // snapshot.data![index].description.toString(),
  //       style: TextStyle(
  //         fontSize: fontSize,
  //         color: textColor,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //   ),
  
                                  
                              //   Html(
                              // data: """
                              //   <div style="text-align: center;">
                              // ${snapshot.data![index].description.toString()}
                              //   </div>
                              // """,
                              // style:{"body":Style(
                              //   fontFamily: "Alvi",
                              //   color: Color(int.parse("0xff"+"${snapshot.data![index].text_color_code.toString()}")),  
                              // // fontSize: FontSize(snapshot.data![index].font_size.toDouble())
                              // )}
                              // ),
                              // Text(snapshot.data![index].description.toString())
                             
                                // } 
                                  }
                        
                          }
                        else if(snapshot.data![index].type_id=="3")...{
                          
                          if(snapshot.data![index].audiourl==null||snapshot.data![index].audiourl=="")...{                          
                         reusablebordercontainer(context, 0.90, 0.88, 3, reusableocontaineraudio(context, 0.88, 
                               "Audio Link Missing", (){
                                }))
                          
                          }
                           else if(snapshot.data![index].audiourl!=null||snapshot.data![index].audiourl!="")...{                          
                          
                              reusablebordercontainer(context, 0.90, 0.88, 3, reusableocontaineraudio(context, 0.88, 
                              "",(){
                         
                                PlayAudio("https://quranarbi.turk.pk/public/public/"+"${snapshot.data![index].audiourl}",context);})) }
                                }
                          ],
                        );
                                    }),
                      ),
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
          ],
        ),
      ),),
    );
  }
} 