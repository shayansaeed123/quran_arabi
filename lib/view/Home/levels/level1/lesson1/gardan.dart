
import 'dart:async';
import 'dart:convert';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_arabi/view/Home/levels/level1/lesson1/audiowidgets.dart';
import '../../../../../function/functions.dart';
import '../../../../../model/images_get.dart';
import '../../../../../model/lesson_intro_data_items.dart';
import '../../../../../res/player.dart';
import '../../../../../res/reusable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../menubar.dart';
import '../../../networkheader.dart';
import 'Lessons.dart';

class Gardan extends StatefulWidget {
   Gardan({required this.sub_category_id,required this.lesson_id});
  String sub_category_id;
  String lesson_id;

  @override
  State<Gardan> createState() => _GardanState(sub_category_id: sub_category_id,lesson_id:lesson_id);
}
YoutubeExplode youtubeExplode = YoutubeExplode();

class _GardanState extends State<Gardan> {
  _GardanState({required this.sub_category_id,required this.lesson_id});
  String sub_category_id;
  String lesson_id;
   Timer? timer2;
Duration _position = Duration(seconds: 0);
var _progress = 0.0;

  late Future<List<LessonIntroDataitems>> futureContents;
   VideoPlayerController? _videoPlayerController;

   Future<List<LessonIntroDataitems>> gardandata() async {
  final response = await http.post(
    Uri.parse('https://quranarbi.turk.pk/api/contents'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'lesson_id': lesson_id,
      'sub_category_id': sub_category_id,
    }),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    List<LessonIntroDataitems> dataList = jsonData.map((json) => LessonIntroDataitems.fromJson(json)).toList();

    // Sort the list in descending order by a specific property (e.g., id)
    dataList.sort((a, b) => a.id.compareTo(b.id));  // Replace 'id' with the desired property

    return dataList;
  } else {
    throw Exception('Failed to load data');
  }
}

Map<String, List<LessonIntroDataitems>> groupDataByGroupId(List<LessonIntroDataitems> data) {
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
  void initState() {
    super.initState();
    futureContents = fetchData();
    groupDataByGroupId;
    audioPlayer;
  }


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


// @override
// void initstate(){
//   super.initState();
//   super.initState();
//       fetchData();
//       postData();
//       audioPlayer;
// }
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
   @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        body: Container(
        child: Column(
          children: [
        // FutureBuilder<List<imageget>>(
        //       future: imagedata(),
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           if(snapshot.connectionState==ConnectionState.done){
        //             return  ListView.builder(
        //                 shrinkWrap: true,
        //                 scrollDirection: Axis.vertical,
        //                           itemCount: snapshot.data!.length,
        //                           itemBuilder: (BuildContext context, int index) {
        //                           var imageurl=snapshot.data![index].featured_image;
        //                           var linkapi="https://quranarbi.turk.pk/";
        //                           return Column(children: [if(snapshot.data![index].id==7)...{
        //                        Headernetwork(linkapi+imageurl, '', Colors.white, true),
        //                 //             Headernetwork(linkapi+imageurl, '', Colors.black,
        //                 // true)
        //                           }],);
        //                           });
        //           }}
        //         return SizedBox(
        //           height: MediaQuery.of(context).size.height*0.2,
        //           width: MediaQuery.of(context).size.width,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               CircularProgressIndicator(),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
          TopMenu(false, false, false, false, false),
              FutureBuilder<List<LessonIntroDataitems>>(
                future: gardandata(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var groupedData = groupDataByGroupId(snapshot.data!);
                    return Expanded(
                      child: ListView(
                        children: groupedData.keys.map((groupId) {
                          return SingleChildScrollView(child: GroupWidget(groupedData[groupId]!));
                        }).toList(),
                      ),
                    );
                  }
                  
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
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
        ),
      ),
    );
  }
}
              //  video_button('قرآنی عربی کا تعارف', 'intro.mp4'),
                            // 'قُلْ اِنَّ صَلَاتِيْ وَنُسُكِيْ وَمَحْيَايَ وَمَمَاتِيْ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ',
     
    //       FutureBuilder<List<LessonIntroDataitems>>(
    //             future: fetchData(),
    //             builder: (context, snapshot) {
    //               if (snapshot.hasData) {
    //                 return 
    //                 Expanded(
    //                   child: Container(
    //                                    height:400,
    //                     margin:  EdgeInsets.only(left: 5,right: 5),
    //                     padding: EdgeInsets.all(15),
    //                     decoration: BoxDecoration(
    //                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
    //                       // image: DecorationImage(
    //                       //   fit: BoxFit.fitWidth,
    //                       //   image: AssetImage("assets/bg.jpg"))
    //                         ),
    //                     child: ListView.builder(
    //                       shrinkWrap: true,
    //                       scrollDirection: Axis.vertical,
    //                       physics: ScrollPhysics(),
    //                                 itemCount: 
    //                                 snapshot.data!.length,
    //                                 itemBuilder: (BuildContext context, int index) {
    //                                   // String? fontFamily = snapshot.data![index].fontFamily;
    // double? fontSize = double.tryParse(snapshot.data![index].font_size) ?? 14.0;  // Default font size if not provided
    // String? colorCode = snapshot.data![index].text_color_code;

    // // Convert color code to Color object
    // Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;

    //                     var imageurl=snapshot.data![index].featured_image;
    //                     var linkapi="https://quranarbi.turk.pk/public/public/";
    //                     int sizefontapi=15;
    //                     int borderwidth=0;
    //                     return Column(
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         // Text(snapshot.data![index].id.toString()),
    //                           // Text(snapshot.data![index].description.toString()),
    //                         // Text(
                        
    //                         //   snapshot.data![index].title==null?"null":snapshot.data![index].description.toString()
    //                         // )
    //                     if(snapshot.data![index].type_id=="4")...{
    //                           if(snapshot.data![index].videolink==null||snapshot.data![index].videolink=="")...{
    //                           reusablebordercontainer(context, 0.90, 0.88, 5, reusablecontainervideo(context, 0.88, 
    //                            "Video Link Missing", (){
                              
    //                           //           );
    //                            }))
    //                           }
    //                           else if(snapshot.data![index].videolink!=null||snapshot.data![index].videolink!="")...{
    //                           reusablebordercontainer(context, 0.90, 0.88, 5, reusablecontainervideo(context, 0.88, 
    //                           snapshot.data![index].title.toString(), (){
    //                             Navigator.push(context, MaterialPageRoute(builder: (context)=>
    //                         HomeScreen(videolink:snapshot.data![index].videolink.toString())
    //                         ));})) 
    //                         }}
    //                     else if(snapshot.data![index].type_id=="2")...{
    //                                        reusablebordercontainer(context, 2,0.88 ,5,
    //                     imageurl==null?Text("image here"):
    //                     Image.network(linkapi+imageurl),
    //                     )
    //                       }
                        
    //                            else if(snapshot.data![index].type_id=="6")...{
                                               
    //                            if(snapshot.data![index].text_type==1||snapshot.data![index].text_type!=null)...{

    //                              reusablebordercontainer(
    //   context, 
    //   2, 
    //   0.88, 
    //   5, 
    //   Text(
    //     snapshot.data![index].description.toString(),
    //     style: TextStyle(
    //       fontSize: fontSize,
    //        fontFamily: "Cairo",
    //       color: textColor,
    //     ),
    //     textAlign: TextAlign.center,
    //   ),
    // ),
    //                             // reusablebordercontainer(context, 2,0.88 ,5,Text("${snapshot.data![index].description.toString()}"),
    //                           //  ),
    //                           //   Html(
    //                           // data: """
    //                           //   <div style="text-align: center;">
    //                           // ${snapshot.data![index].description.toString()}
    //                           //   </div>
    //                           // """,
    //                           // style:{"body":Style(
    //                           //   fontFamily: "Cairo",
    //                           //   color: Color(int.parse("0xff"+"${snapshot.data![index].text_color_code.toString()}")),  
    //                           // fontSize: FontSize( double.parse(snapshot.data![index].font_size))
    //                           // )}
                              
    //                           // ),
                            
    //                            }
    //                            else if(snapshot.data![index].text_type==2||snapshot.data![index].text_type!=null)...{
    //                             //  reusablebordercontainer(context, 2,0.88 ,5,Text(' ${snapshot.data![index].description.toString()}')
    //                               //  ),

    //                                reusablebordercontainer(
    //   context, 
    //   2, 
    //   0.88, 
    //   5, 
    //   Text(
    //     snapshot.data![index].description.toString(),
    //     style: TextStyle(
    //       fontSize: fontSize,
    //       fontFamily: "Alvi",
    //       color: textColor,
    //     ),
    //     textAlign: TextAlign.center,
    //   ),
    // ),
                                  
    //                           //   Html(
    //                           // data: """
    //                           //   <div style="text-align: center;">
    //                           // ${snapshot.data![index].description.toString()}
    //                           //   </div>
    //                           // """,
    //                           // style:{"body":Style(
    //                           //   fontFamily: "Alvi",
    //                           //   color: Color(int.parse("0xff"+"${snapshot.data![index].text_color_code.toString()}")),  
    //                           // // fontSize: FontSize(snapshot.data![index].font_size.toDouble())
    //                           // )}
    //                           // ),
    //                           // Text(snapshot.data![index].description.toString())
                             
    //                             }   }
                        
                        
                        
                        
                        
    //                     else if(snapshot.data![index].type_id=="3")...{
                          
    //                       if(snapshot.data![index].audiourl==null||snapshot.data![index].audiourl=="")...{                          
    //                      reusablebordercontainer(context, 0.90, 0.88, 5, reusableocontaineraudio(context, 0.88, 
    //                            "Audio Link Missing", (){
    //                             }))
                          
    //                       }
    //                        else if(snapshot.data![index].audiourl!=null||snapshot.data![index].audiourl!="")...{                          
                          
    //                           reusablebordercontainer(context, 0.90, 0.88, 5, reusableocontaineraudio(context, 0.88, 
    //                           "",(){
                         
    //                             PlayAudio("https://quranarbi.turk.pk/public/public/"+"${snapshot.data![index].audiourl}",context);})) }}
                          
    //                       ],
    //                     );
    //                                 }),
    //                   ),
    //                 );
    //               }  

    //               return SizedBox(
    //                 height: MediaQuery.of(context).size.height*0.55,
    //                 width: MediaQuery.of(context).size.width,
    //                 child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     CircularProgressIndicator(),
    //                   ],
                    
    //                 ),
    //               );
                // },
                //       ),
                      // Text("",style: TextStyle(fontSize: ),)
        



// class GroupWidget extends StatelessWidget {
//   final List<LessonIntroDataitems> items;

//   GroupWidget(this.items);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: items.map((content) {
//         double? fontSize = double.tryParse(content.font_size) ?? 14.0;
//         String? colorCode = content.text_color_code;
//         Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//         var imageurl = content.featured_image;
//         var linkapi = "https://quranarbi.turk.pk/public/public/";

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (content.type_id == "6") ...[
//               if (content.text_type == 1 || content.text_type != null) ...[
//                 reusablebordercontainer(
//                   context,
//                   2,
//                   0.88,
//                   5,
//                   Text(
//                     content.description.toString(),
//                     style: TextStyle(fontSize: fontSize, fontFamily: "Cairo", color: textColor),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ] else if (content.text_type == 2 || content.text_type != null) ...[
//                 reusablebordercontainer(
//                   context,
//                   2,
//                   0.88,
//                   5,
//                   Text(
//                     content.description.toString(),
//                     style: TextStyle(fontSize: fontSize, fontFamily: "Alvi", color: textColor),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ]
//             ] else if (content.type_id == "2") ...[
//               reusablebordercontainer(context, 2, 0.88, 5, imageurl == null ? Text("image here") : Image.network(linkapi + imageurl))
//             ] else if (content.type_id == "3") ...[
//               if (content.audiourl == null || content.audiourl.isEmpty) ...[
//                 reusablebordercontainer(context, 0.90, 0.88, 5, reusableocontaineraudio(context, 0.88, "Audio Link Missing", () {}))
//               ] else ...[
//                 reusablebordercontainer(context, 0.90, 0.88, 5, reusableocontaineraudio(context, 0.88, "", () {
//                   PlayAudio("https://quranarbi.turk.pk/public/public/" + content.audiourl, context);
//                 }))
//               ]
//             ],
//           ],
//         );
//       }).toList(),
//     );
//   }
// }
// class GroupWidget extends StatelessWidget {
//   final List<LessonIntroDataitems> items;
//   GroupWidget(this.items);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       crossAxisCount: 4,
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//       children: items.map((content) {
//         double? fontSize = double.tryParse(content.font_size ?? "14.0");
//         String? colorCode = content.text_color_code;
//         Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//         var imageurl = content.featured_image;
//         var linkapi = "https://quranarbi.turk.pk/public/public/";

//         Widget child;
//         if (content.type_id == "6") {
//           // Handle Arabic text and translation
//           child = Text(
//             content.description ?? "",
//             style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Alvi", color: textColor),
//             textAlign: TextAlign.center,
//           );
//         } else if (content.type_id == "2") {
//           // Handle image
//           child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
//         } 
//         else if (content.type_id == "3") {
//           // Handle audio
//           child = content.audiourl == null || content.audiourl!.isEmpty
//               ? Text("Audio Link Missing")
//               : IconButton(
//                   icon: Icon(Icons.volume_up_rounded),
//                   onPressed: () {
//                     PlayAudio("https://quranarbi.turk.pk/public/public/" + content.audiourl!, context);
//                   },
//       );
//         } 
//         else {
//           child = SizedBox();
//         }
//         return reusablebordercontainer(context, 1, 0.4, 1, child);
//       }).toList(),
//     );
//   }
// }


class GroupWidget extends StatefulWidget {
  final List<LessonIntroDataitems> items;
  GroupWidget(this.items);

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  String audioUrl = "";

  Future<void> _init(String url) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    await _player.setUrl(url);
    _player.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });
  }

  void _playPause() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _seekForward() async {
    Duration position = await _player.position;
    Duration duration = await _player.duration ?? Duration.zero;
    if (position + Duration(seconds: 10) < duration) {
      _player.seek(position + Duration(seconds: 10));
    }
  }

  void _seekBackward() async {
    Duration position = await _player.position;
    if (position - Duration(seconds: 10) > Duration.zero) {
      _player.seek(position - Duration(seconds: 10));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }


   @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // for (int i = 0; i < widget.items.length; i += 4) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 15,
                ),
                itemCount: widget.items.length,
                // itemCount: (i + 4 <= widget.items.length) ? 4 : widget.items.length - i,
                itemBuilder: (context, index) {
                  widget.items.sort((a, b) => b.id.compareTo(a.id));
                  final content = widget.items[index];
                  double? fontSize = double.tryParse(content.font_size ?? "14.0");
                  String? colorCode = content.text_color_code;
                  Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
                  var imageurl = content.featured_image;
                  var linkapi = "https://quranarbi.turk.pk/public/public/";
                  Widget child;
                  if (content.type_id == "6") {
                    child = Center(
                      child: Text(
                        content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
                        style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "new2" : "new2", color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (content.type_id == "2") {
                    // Handle image
                    child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
                  } else if (content.type_id == "3") {
                    // Handle audio
                    child = content.audiourl == null || content.audiourl!.isEmpty
                        ? Text("Audio Link Missing")
                        : IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Center(
                                            child: AudioPlayerWidget(
                                              audioUrl: linkapi + content.audiourl!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                  } else {
                    child = SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  if (content.type_id == "6") ...[
                                    Text(
                                      content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
                                      style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "new2" : "new2", color: textColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                  if (content.type_id == "2") ...[
                                    imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
                                  ],
                                  if (content.type_id == "3") ...[
                                    content.audiourl == null || content.audiourl!.isEmpty
                                        ? Text("Audio Link Missing")
                                        : Column(
                                            // mainAxisSize: MainAxisSize.min, 
                                            children: [
                                              Center(
                                                child: AudioPlayerWidget(
                                                  audioUrl: linkapi + content.audiourl!,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: reusablebordercontainer(context, 1, 0.4, 1, child),
                  );
                },
              ),
              // if (i + 4 < widget.items.length) Divider(thickness: 1, color: Colors.black),
            ],
          // ],
        ),
      ),
    );
  }
}