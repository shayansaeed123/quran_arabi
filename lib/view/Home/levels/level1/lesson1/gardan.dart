import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quran_arabi/model/lesson_intro_data_items.dart';
import 'package:quran_arabi/res/allres.dart';
import 'package:quran_arabi/view/Home/levels/level1/lesson1/audiowidgets.dart';
import 'package:quran_arabi/view/Home/menubar.dart';
import 'package:html/parser.dart' as htmlParser;

class Gardan extends StatefulWidget {
  Gardan({required this.sub_category_id, required this.lesson_id});
  final String sub_category_id;
  final String lesson_id;

  @override
  State<Gardan> createState() => _GardanState();
}

class _GardanState extends State<Gardan> {
  late Future<List<LessonIntroDataitems>> futureContents;

  @override
  void initState() {
    super.initState();
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


String parseHtmlString(String htmlString) {
  final document = htmlParser.parse(htmlString);
  final String parsedString = document.body?.text ?? '';
  return parsedString;
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.01,
                child: Row(
                  children: [
                    TopMenu(false, false, false, false, false),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.09,
                right: 0,
                bottom: 0,
                left: 0,
                child: FutureBuilder<List<LessonIntroDataitems>>(
                  future: futureContents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    }
                    List<LessonIntroDataitems> data = snapshot.data!;
                    Map<String, List<LessonIntroDataitems>> groupedData = groupDataByGroupId(data);
                    return
                     ListView.builder(
        itemCount: groupedData.keys.length * 2,
        itemBuilder: (context, index) {
      if (index.isOdd) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset('assets/quranborder_line.png'),
        );
      }
      int itemIndex = index ~/ 2;
      String groupId = groupedData.keys.elementAt(itemIndex);
      List<LessonIntroDataitems> items = groupedData[groupId]!;
           var linkapi = "https://quranarbi.turk.pk/public/public/";
      double? fontSize = double.tryParse(items[0].font_size ?? "20");
      String? colorCode = items[0].text_color_code;
      Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
      String imageurl = items.length > 2 ? items[2].featured_image : '';
      String audiourl = items.length > 3 ? items[3].audiourl : '';
      if (items.length == 1) {
  return Container(
    padding: EdgeInsets.all(6),
    margin: EdgeInsets.symmetric(vertical: 10),
    color: Color.fromARGB(255, 2, 129, 148),
    child: Center(
      child: Text(
        items[0].text_type == '1'
          ? items[0].title_arbic ?? ''
          : items[0].description ?? '',
        style: TextStyle(
          fontFamily: items[0].text_type == '1'
            ? "Muhammadi Naskh" 
            : null, 
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    ),
  );
}
      // if (items.length == 1) {
      //   return Container(
      //     padding: EdgeInsets.all(10),
      //     margin: EdgeInsets.symmetric(vertical: 10),
      //     color: Color.fromARGB(255, 2, 129, 148),
      //     child: Center(
      //       child: Text(
      //         items[0].title_arbic ?? '',
      //         style: TextStyle(
      //           fontFamily: "Muhammadi Naskh",
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //   );
      // }
      
  
      
      return Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.sizeOf(context).width * 0.4,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 238, 242),
          border: Border.all(width: 2, color: Color.fromARGB(255, 2, 129, 148)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 2, color: Color.fromARGB(255, 2, 129, 148)),
              ),
              child: Column(
                children: [
                  imagereusableArabicIcon(
                    size: 40,
                    imageUrl: linkapi + imageurl,
                    onTapCallback: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Image.network(linkapi + imageurl),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 3),
                  IconButton(
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
                                      audioUrl: linkapi + audiourl,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      color: Colors.cyan[800],
                      Icons.volume_up,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                       parseHtmlString(items.isNotEmpty ? items[0].title_arbic : ''),
                      style: TextStyle(   
                        fontFamily: "Muhammadi Naskh",
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                         parseHtmlString(items.isNotEmpty ? items[0].description : ''),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
        },
      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class Gardan extends StatefulWidget {
//   Gardan({required this.sub_category_id, required this.lesson_id});
//   final String sub_category_id;
//   final String lesson_id;

//   @override
//   State<Gardan> createState() => _GardanState();
// }

// class _GardanState extends State<Gardan> {
//   late Future<List<LessonIntroDataitems>> futureContents;

//   @override
//   void initState() {
//     super.initState();
//     futureContents = gardandata();
//   }

//   Future<List<LessonIntroDataitems>> gardandata() async {
//     final response = await http.post(
//       Uri.parse('https://quranarbi.turk.pk/api/contents'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'lesson_id': widget.lesson_id, // Use widget.lesson_id
//         'sub_category_id': widget.sub_category_id, // Use widget.sub_category_id
//       }),
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       List<LessonIntroDataitems> dataList = jsonData
//           .map((json) => LessonIntroDataitems.fromJson(json))
//           .toList();

//       // dataList.sort((a, b) => a.id.compareTo(b.id));
//       return dataList;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Map<String, List<LessonIntroDataitems>> groupDataByGroupId(
//       List<LessonIntroDataitems> data) {
//     Map<String, List<LessonIntroDataitems>> groupedData = {};
//     for (var item in data) {
//       var groupId = item.groupId;
//       if (groupedData.containsKey(groupId)) {
//         groupedData[groupId]!.add(item);
//       } else {
//         groupedData[groupId] = [item];
//       }
//     }
//     return groupedData;
//   }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       decoration: BoxDecoration(color: Colors.white),
//       height: MediaQuery.sizeOf(context).height,
//       width: MediaQuery.sizeOf(context).width,
//       child: Stack(
//         children: [
//           Positioned(
//             top: MediaQuery.sizeOf(context).height * 0.03,
//             child: Row(
//               children: [
//                 TopMenu(true, true, true, true, true), 
//               ],
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.sizeOf(context).height * 0.07,
//             right: 0,
//             bottom: 0,
//             left: 0,
//             child: FutureBuilder<List<LessonIntroDataitems>>(
//               future: futureContents,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No data available'));
//                 }
//                 List<LessonIntroDataitems> data = snapshot.data!;
//                 Map<String, List<LessonIntroDataitems>> groupedData = groupDataByGroupId(data);
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: groupedData.keys.length * 2 - 1, 
//                   itemBuilder: (context, index) {
//                     if (index.isOdd) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Image.asset('assets/quranborder_line.png'),
//                       );
//                     }
                    
//                     int itemIndex = index ~/ 2;
//                     String groupId = groupedData.keys.elementAt(itemIndex);
//                     List<LessonIntroDataitems> items = groupedData[groupId]!;
//                     var imageurl = items[2].featured_image;
//                     var linkapi = "https://quranarbi.turk.pk/public/public/";
//                     double? fontSize = double.tryParse(items[0].font_size ?? "20");  
//                     String? colorCode = items[0].text_color_code;
//                     Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                     return Container(
//                       margin: EdgeInsets.all(5),
//                       width: MediaQuery.sizeOf(context).width * 0.4,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255,233, 238, 242),
//                         border: Border.all(width: 2,color: Color.fromARGB(255, 2, 129, 148)),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(18),
//                               border: Border.all(width: 2, color:  Color.fromARGB(255, 2, 129, 148)),
//                             ),
//                             child: Column(
//                               children: [
//                                 imagereusableArabicIcon(
//                                   size: 40,
//                                   imageUrl: linkapi + imageurl,
//                                   onTapCallback: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           content: SingleChildScrollView(
//                                             child: ListBody(
//                                               children: <Widget>[
//                                                 Image.network(linkapi + imageurl),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                                 SizedBox(height: 3),
//                                 IconButton(
//                                   onPressed: () {
//                                     print("Audio URL: ${linkapi + items[3].audiourl}");
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           content: SingleChildScrollView(
//                                             child: ListBody(
//                                               children: <Widget>[
//                                                 Center(
//                                                   child: AudioPlayerWidget(
//                                                     audioUrl: linkapi + items[3].audiourl,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                   icon: Icon(
//                                     color: Colors.cyan[800],
//                                     Icons.volume_up,
//                                     size: 40,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(
//                               padding: EdgeInsets.only(right: 15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     items.isNotEmpty ? items[0].title_arbic : '',
//                                     style: TextStyle(
//                                     fontFamily: "Muhammadi Naskh",
//                                       fontSize: fontSize,
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     items.isNotEmpty ? items[0].description : '',
//                                     style: TextStyle(
//                                     fontFamily: "Muhammadi Naskh",
//                                       fontSize: 15,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         height: MediaQuery.sizeOf(context).height,
//         width: MediaQuery.sizeOf(context).width,
//         child: Stack(
//           children: [
//             Positioned(
//               top: MediaQuery.sizeOf(context).height * 0.04,
//               child: Row(
//                 children: [
//                   TopMenu(false, false, false, false, false),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: MediaQuery.sizeOf(context).height * 0.09,
//               right: 0,
//               bottom: 0,
//               left: 0,
//               child: FutureBuilder<List<LessonIntroDataitems>>(
//                 future: futureContents,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('No data available'));
//                   }

//                   List<LessonIntroDataitems> data = snapshot.data!;
//                   Map<String, List<LessonIntroDataitems>> groupedData = groupDataByGroupId(data);
//                   return ListView.builder(
//                     itemCount: groupedData.keys.length,
//                     itemBuilder: (context, index) {
//                       String groupId = groupedData.keys.elementAt(index);
//                       List<LessonIntroDataitems> items = groupedData[groupId]!;
//                        var imageurl=items[2].featured_image;
//                         var linkapi="https://quranarbi.turk.pk/public/public/";
//                       return Container(
//                         margin: EdgeInsets.all(5),
//                         width: MediaQuery.sizeOf(context).width * 0.4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           border: Border.all(width: 2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(18),
//                                 border: Border.all(width: 2, color: Colors.black),
//                               ),
//                               child: Column(
//                                 children: [
//                               //  reusableArabicIcon(30, Icons.image),
//                         imagereusableArabicIcon(
//   size: 30,
//   imageUrl: linkapi + imageurl,
//   onTapCallback: () {
//         showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: SingleChildScrollView(
//                           child: ListBody(
//                             children: <Widget>[
//                               Image.network(linkapi + imageurl),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
    
//   },
// ),
//                                   // imagereusableArabicIcon(30, linkapi + imageurl),
//                                 // Text(linkapi + imageurl),
//                                   SizedBox(height: 3),
//                                   IconButton(
//                                     onPressed: () {
//                                     print("Audio URL: ${linkapi + items[3].audiourl}");
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: SingleChildScrollView(
//                           child: ListBody(
//                             children: <Widget>[
//                               Center(
//                                 child: AudioPlayerWidget(
//                                   audioUrl: linkapi + items[3].audiourl,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                                     },
//                                     icon: Icon(
//                                       Icons.volume_up,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ],
                                
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.only(right: 15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       items.isNotEmpty ? items[0].title_arbic : '',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       items.isNotEmpty ? items[0].description : '',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
                                  
//                                 ),
//                               ),
                              
//                             ),
                                
//                           ],
                          
//                         ),
                        
//                       );
                      
//                     },
                    
//                   );
                  
//                 },
                
//               ),
              
//             ),
        
//           ],
          
//         ),
        
//       ),
      
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
    
//       body: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         height: MediaQuery.sizeOf(context).height,
//         width: MediaQuery.sizeOf(context).width,
//         child: Stack(
//           children: [
//             Positioned(
//               top: MediaQuery.sizeOf(context).height * 0.04,
//               // right: 0,
//               // left: 0,
//               child: Row(
               
//                 children: [
//                          TopMenu(false, false, false, false, false),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: MediaQuery.sizeOf(context).height * 0.08,
//               right: 0,
//               bottom: 0,
//               left: 0,
//               child: ListView.builder(
//                   itemCount: 10,
//                   itemBuilder: (context, index) {
//                     return Container(
//     margin: EdgeInsets.all(5),
//     width: MediaQuery.sizeOf(context).width * 0.4,
//     decoration: BoxDecoration(
//         border: Border.all(width: 2), borderRadius: BorderRadius.circular(20)),
//     child: Row(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(width: 2, color: Colors.black)),
//           child: Column(
//             children: [
//               reusableArabicIcon(30, Icons.image),
//               SizedBox(
//                 height: 3,
//               ),
//               IconButton(
//                 onPressed: () {
//                   print("Speaking");
//                 },
//                 icon: Icon(
//                   Icons.volume_up,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.only(right: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   "شُروع اَللہ کے پاک نام سے جو بڑا مہر بان نہايت رحم والا ہے ۔",
//                   style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
//                     // return Column(
//                     //   children: [
//                     //     reusableArabicList(context, 0.97),
//                     //     arabicSeparator(context)
//                     //   ],
//                     // );
//                     // reusableArabicList(context, 0.97);
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'dart:convert';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:quran_arabi/res/allres.dart';
// import 'package:quran_arabi/view/Home/levels/level1/lesson1/audiowidgets.dart';
// import '../../../../../function/functions.dart';
// import '../../../../../model/images_get.dart';
// import '../../../../../model/lesson_intro_data_items.dart';
// import '../../../../../res/player.dart';
// import '../../../../../res/reusable.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart' as http;
// import '../../../menubar.dart';
// import '../../../networkheader.dart';
// import 'Lessons.dart';

// class Gardan extends StatefulWidget {
//    Gardan({required this.sub_category_id,required this.lesson_id});
//   String sub_category_id;
//   String lesson_id;

//   @override
//   State<Gardan> createState() => _GardanState(sub_category_id: sub_category_id,lesson_id:lesson_id);
// }
// YoutubeExplode youtubeExplode = YoutubeExplode();

// class _GardanState extends State<Gardan> {
//   _GardanState({required this.sub_category_id,required this.lesson_id});
//   String sub_category_id;
//   String lesson_id;
//    Timer? timer2;
// Duration _position = Duration(seconds: 0);
// var _progress = 0.0;

//    late Future<List<LessonIntroDataitems>> futureContents;
//   VideoPlayerController? _videoPlayerController;

//   Future<List<LessonIntroDataitems>> gardandata() async {
//     final response = await http.post(
//       Uri.parse('https://quranarbi.turk.pk/api/contents'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'lesson_id': 'some_lesson_id',
//         'sub_category_id': 'some_sub_category_id',
//       }),
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       List<LessonIntroDataitems> dataList = jsonData
//           .map((json) => LessonIntroDataitems.fromJson(json))
//           .toList();

//       dataList.sort((a, b) => a.id.compareTo(b.id));
//       return dataList;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Map<String, List<LessonIntroDataitems>> groupDataByGroupId(
//       List<LessonIntroDataitems> data) {
//     Map<String, List<LessonIntroDataitems>> groupedData = {};
//     for (var item in data) {
//       var groupId = item.groupId;
//       if (groupedData.containsKey(groupId)) {
//         groupedData[groupId]!.add(item);
//       } else {
//         groupedData[groupId] = [item];
//       }
//     }
//     return groupedData;
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureContents = gardandata();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Column(
//             children: [
//               TopMenu(false, false, false, false, false),
//               FutureBuilder<List<LessonIntroDataitems>>(
//                 future: futureContents,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var groupedData = groupDataByGroupId(snapshot.data!);
//                     return Expanded(
//                       child: ListView(
//                         children: groupedData.keys.map((groupId) {
//                           return GroupWidget(groupedData[groupId]!);
//                         }).toList(),
//                       ),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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


// class GroupWidget extends StatefulWidget {
//   final List<LessonIntroDataitems> items;

//   GroupWidget(this.items);

//   @override
//   _GroupWidgetState createState() => _GroupWidgetState();
// }

// class _GroupWidgetState extends State<GroupWidget> {
//   final AudioPlayer _player = AudioPlayer();
//   bool isPlaying = false;

//   Future<void> _init(String url) async {
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.speech());
//     await _player.setUrl(url);
//     _player.playingStream.listen((playing) {
//       setState(() {
//         isPlaying = playing;
//       });
//     });
//   }

//   void _playPause() {
//     if (isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

// @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         height: MediaQuery.sizeOf(context).height,
//         width: MediaQuery.sizeOf(context).width,
//         child: Stack(
//           children: [
//             Positioned(
//               top: MediaQuery.sizeOf(context).height * 0.08,
//               right: 0,
//               bottom: 0,
//               left: 0,
//               child: ListView.builder(
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         reusableArabicList(context, 0.97),
//                         arabicSeparator(context)
//                       ],
//                     );
//                     // reusableArabicList(context, 0.97);
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.8,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: (widget.items.length / 4).ceil(),
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       for (int j = 0; j < 4; j++)
//                         if (index * 4 + j < widget.items.length)
//                           Expanded(
//                             child: buildCard(widget.items[index * 4 + j]),
//                           ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildCard(LessonIntroDataitems content) {
//     var imageurl = content.featured_image;
//     var linkapi = "https://quranarbi.turk.pk/public/public/";

//     return Card(
//       color: Colors.grey[200],
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (content.type_id == "2" && imageurl != null)
//               Container(
//                 padding: EdgeInsets.all(2.0),
//                 width: 80,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Image.network(
//                   linkapi + imageurl,
//                   fit: BoxFit.cover,
//                 ),
//               ),
            
//             SizedBox(height: 10),

//             if (content.text_type == "1") 
//               Text(
//                 content.title_arbic ?? "",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontFamily: "Cairo",
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             if (content.text_type == "2") 
//               Text(
//                 content.description ?? "",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//             if (content.type_id == "3" && content.audiourl != null)
//               IconButton(
//                 icon: Icon(Icons.volume_up),
//                 color: Colors.black,
//                 onPressed: () {
//                   print("Audio URL: ${linkapi + content.audiourl}");
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: SingleChildScrollView(
//                           child: ListBody(
//                             children: <Widget>[
//                               Center(
//                                 child: AudioPlayerWidget(
//                                   audioUrl: linkapi + content.audiourl,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//updated one
//   @override
// Widget build(BuildContext context) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (int i = 0; i < 2; i += 4) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 for (int j = 0; j < 3; j++)
//                   if (i + j < widget.items.length)
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 6.0),
//                         child: Builder(
//                           builder: (context) {
//                             final content = widget.items[i + j];
//                             // widget.items.sort((a, b) => b.id.compareTo(a.id));
//                             double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                             String? colorCode = content.text_color_code;
//                             Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                             var imageurl = content.featured_image;
//                             var linkapi = "https://quranarbi.turk.pk/public/public/";
//                             Widget child;
//                             if (content.type_id == "6" && content.text_type == "1") {
//                               // Arabic Text Card with Audio Icon
//                               child = Container(
//                                 width: 120,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Center(
//                                       child: Text(
//                                         content.title_arbic ?? "",
//                                         style: TextStyle(
//                                           fontSize: fontSize,
//                                           fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//                                           color: textColor,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     if (content.type_id == "3" || content.text_type == "1")
//                                       Positioned(
//                                         bottom: 9.0,
//                                         right: 1.0,
//                                         child: IconButton(
//                                           icon: Icon(Icons.volume_up),
//                                           color: Colors.black,
//                                           onPressed: () {
//                                             print("Audio URL: ${linkapi + content.audiourl}");
//                                             // if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (BuildContext context) {
//                                                   return AlertDialog(
//                                                     content: SingleChildScrollView(
//                                                       child: ListBody(
//                                                         children: <Widget>[
//                                                           Center(
//                                                             child: AudioPlayerWidget(
//                                                               audioUrl: linkapi + content.audiourl!,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//                                             }
//                                           // },
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               );
//                             } 
//                             else if (content.type_id == "6" && content.text_type == "2") {
//                               // Non-Arabic Text Card
//                               child = Container(
//                                 height: 30,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     content.description ?? "",
//                                     style: TextStyle(
//                                       fontSize: fontSize,
//                                       fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//                                       color: textColor,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               );
//                             } else if (content.type_id == "2") {
//                               // Image Card
//                               child = Container(
//                                 height: 40,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: imageurl == null
//                                     ? Text("Image here")
//                                     : Image.network(linkapi + imageurl),
//                               );
//                             } else {
//                               child = SizedBox();
//                             }

//                             return GestureDetector(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       content: SingleChildScrollView(
//                                         child: ListBody(
//                                           children: <Widget>[
//                                             if (content.type_id == "6") ...[
//                                               Text(
//                                                 content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                                 style: TextStyle(
//                                                   fontSize: fontSize,
//                                                   fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//                                                   color: textColor,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ],
//                                             if (content.type_id == "2") ...[
//                                               imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                             ],
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                               child: child,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//               ],
//             ),
//             if (i + 3 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//           ],
//         ],
//       ),
//     ),
//   );
// }
// }

// @override
// Widget build(BuildContext context) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (int i = 0; i < 2; i += 4) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 for (int j = 0; j < 3; j++)
//                   if (i + j < widget.items.length)
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 6.0),
//                         child: Builder(
//                           builder: (context) { 
//                             final content = widget.items[i + j];
//                               widget.items.sort((a, b) => b.id.compareTo(a.id));
//                             double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                             String? colorCode = content.text_color_code;
//                             Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                             var imageurl = content.featured_image;
//                             var linkapi = "https://quranarbi.turk.pk/public/public/";
//                             Widget child;
//                             if (content.type_id == "6" && content.text_type == "1") {
//                               // Arabic Text Card with Audio Icon
//                               child = Container(
//                                 width: 120,
//                              height: 60,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Center(
//                                       child: Text(
//                                          content.title_arbic ?? "",
//                                         // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                         style: TextStyle(
//                                           fontSize: fontSize,
//                                           fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//                                           color: textColor,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     if (content.type_id == "3" || content.text_type == "1")
//                                       Positioned(
//                                         // top: 90,
//                                         bottom: 9.0,
//                                         right: 1.0,
//                                         child: IconButton(
//                                           icon: Icon(Icons.volume_up),
//                                           color: Colors.black,
//                                           onPressed: () {
//                                             print("Audio URL: ${linkapi + content.audiourl}");
//                                             // if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (BuildContext context) {
//                                                   return AlertDialog(
//                                                     content: SingleChildScrollView(
//                                                       child: ListBody(
//                                                         children: <Widget>[
//                                                           Center(
//                                                             child: AudioPlayerWidget(
//                                                               audioUrl: linkapi + content.audiourl!,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//                                             }
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                             );
//                             } 

//                            else if (content.type_id == "6" && content.text_type == "2") {
//                               // Arabic Text Card with Audio Icon
//                               child = Container(
//                              height: 30,
//                              width: 20,
//                                 child: Center(
//                                   child: Text(
//                                       content.description ?? "",
//                                     // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                     style: TextStyle(
//                                       fontSize: fontSize,
//                                       fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//                                       color: textColor,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               );
//                             } 
//                             else if (content.type_id == "2") {
//                               child = Container(
//                                 height: 40,
//                                 width: 20,
//                                 child: imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl));
//                             } 
//                             // else if (content.type_id == "3") {
//                             //   child = SizedBox(); 
//                             // } 
//                             else {
//                               child = SizedBox();
//                             }

//                             return GestureDetector(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       content: SingleChildScrollView(
//                                         child: ListBody(
//                                           children: <Widget>[
//                                             if (content.type_id == "6") ...[
//                                               Text(
//                                                 content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                                 style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ],
//                                             // if (content.type_id == "3") ...[
//                                             //   // content.audiourl == null || content.audiourl!.isEmpty
//                                             //     // ? Text("Audio Link Missing")
//                                             //     // :
//                                             //      Column(
//                                             //         children: [
//                                             //           Center(
//                                             //             child: AudioPlayerWidget(
//                                             //               audioUrl: linkapi + content.audiourl!,
//                                             //             ),
//                                             //           ),
                                                      
//                                             //         ],
                                                    
//                                             //       ),
                                                  
//                                             // ],
//                                             if (content.type_id == "2") ...[
//                                               imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                             ],
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                               child: reusablebordercontainer(context, 1, 0.4, 1, child),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//               ],
//             ),
//             if (i + 3 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//           ],
//         ],
//       ),
//     ),
//   );
// }
// }
  
// @override
// Widget build(BuildContext context) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (int i = 0; i < widget.items.length; i += 4) ...[
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 15,
//                 childAspectRatio: widget.items[i].type_id == "6" && widget.items[i].text_type == '1' ? 1 / 1.2 : 1,
//                 // childAspectRatio: 1 / (widget.items[i].type_id == "6" && widget.items[i].text_type == '1' ? 0.9 : 1), // Adjust height for Arabic text cards
//               ),
//               itemCount: widget.items.length -1,
//               itemBuilder: (context, index) {
//                 widget.items.sort((a, b) => b.id.compareTo(a.id));
//                    final content = widget.items[index + 1]; 
//                 // final content = widget.items[i + index];
//                 double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                 String? colorCode = content.text_color_code;
//                 Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                 var imageurl = content.featured_image;
//                 var linkapi = "https://quranarbi.turk.pk/public/public/";
//                 Widget child;
//             if (content.type_id == "6") {
//   // Arabic Text Card with Audio Icon
//   child = Stack(
//     alignment: Alignment.center,
//     children: [
//       Center(
//         child: Text(
//           content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//           style: TextStyle(
//             fontSize: fontSize,
//             fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//             color: textColor,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       if (content.text_type == "1") 
//         Positioned(
//           top: 90,
//           bottom: 2.0,
//           right: 1.0,
//           child: IconButton(
//             icon: Icon(Icons.volume_up),
//             color: Colors.black,
//             onPressed: () {
//               if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       content: SingleChildScrollView(
//                         child: ListBody(
//                           children: <Widget>[
//                             Center(
//                               child: AudioPlayerWidget(
//                                 audioUrl: linkapi + content.audiourl!,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//     ],
//   );
// }
//                 else if (content.type_id == "2") {
//                   child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
//                 } 
//                 else if (content.type_id == "3") {
//               child = SizedBox(); 
// }
//                 // else if (content.type_id == "3") {
//                 //   // Separate Audio Card
//                 //   child = content.audiourl == null || content.audiourl!.isEmpty
//                 //       ? Text("Audio Link Missing")
//                 //       : IconButton(
//                 //           icon: Icon(Icons.volume_up),
//                 //           onPressed: () {
//                 //             showDialog(
//                 //               context: context,
//                 //               builder: (BuildContext context) {
//                 //                 return AlertDialog(
//                 //                   content: SingleChildScrollView(
//                 //                     child: ListBody(
//                 //                       children: <Widget>[
//                 //                         Center(
//                 //                           child: AudioPlayerWidget(
//                 //                             audioUrl: linkapi + content.audiourl!,
//                 //                           ),
//                 //                         ),
//                 //                       ],
//                 //                     ),
//                 //                   ),
//                 //                 );
//                 //               },
//                 //             );
//                 //           },
//                 //         );
//                 // } 
//                 else {
//                   child = SizedBox();
//                 }
//                 return GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           content: SingleChildScrollView(
//                             child: ListBody(
//                               children: <Widget>[

//   //                                  if (content.type_id == "6") ...[
//   // // Arabic Text Card with Audio Icon
//   // child = Stack(
//   //   alignment: Alignment.center,
//   //   children: [
//   //     Center(
//   //       child: Text(
//   //         content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//   //         style: TextStyle(
//   //           fontSize: fontSize,
//   //           fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//   //           color: textColor,
//   //         ),
//   //         textAlign: TextAlign.center,
//   //       ),
//   //     ),
//   //     if (content.text_type == "1") // Show volume icon only for Arabic text
//   //       Positioned(
//   //         bottom: 2.0,
//   //         right: 8.0,
//   //         child: IconButton(
//   //           icon: Icon(Icons.volume_up),
//   //           color: Colors.black,
//   //           onPressed: () {
//   //             if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//   //               showDialog(
//   //                 context: context,
//   //                 builder: (BuildContext context) {
//   //                   return AlertDialog(
//   //                     content: SingleChildScrollView(
//   //                       child: ListBody(
//   //                         children: <Widget>[
//   //                           Center(
//   //                             child: AudioPlayerWidget(
//   //                               audioUrl: linkapi + content.audiourl!,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               );
//   //             }
//   //           },
//   //         ),
//   //       ),
//   //   ],
                                   
//   // ),
//   //                                  ],

//                                 if (content.type_id == "6") ...[
//                                   Text(
//                                     content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                     style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                        ],
//                                   if (content.type_id == "3") ...[
//                                        content.audiourl == null || content.audiourl!.isEmpty
//                                       ? Text("Audio Link Missing")
//                                       : Column(
//                                           // mainAxisSize: MainAxisSize.min, 
//                                           children: [
//                                             Center(
//                                               child: AudioPlayerWidget(
//                                                 audioUrl: linkapi + content.audiourl!,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                   ],
                           
//                                 if (content.type_id == "2") ...[
//                                   imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                 ],
                                 
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: reusablebordercontainer(context, 1, 0.4, 1, child),
//                 );
//               },
//             ),
//             if (i + 3 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//           ],    
//         ],
//       ),
//     ),
//   );
// }
// }

//    @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             for (int i = 0; i < widget.items.length; i += 4) ...[
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 15,
//                 ),
//                 itemCount: widget.items.length,
//                 itemBuilder: (context, index) {
//                   widget.items.sort((a, b) => b.id.compareTo(a.id));
//                   final content = widget.items[i + index];
//                   double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                   String? colorCode = content.text_color_code;
//                   Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                   var imageurl = content.featured_image;
//                   var linkapi = "https://quranarbi.turk.pk/public/public/";
//                   Widget child;
//                   if (content.type_id == "6" && content.text_type == '1') {
//                                     Text(
//                                            content.title_arbic ?? "",
//                                       // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                       textAlign: TextAlign.center,
//                                     );
//                   }
//                                    if (content.type_id == "6" && content.text_type == '2'){
//                                     Text(
//                                            content.description ?? "",
//                                       // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 2 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                       textAlign: TextAlign.center,
//                                     );
//                                    }
//                   // if (content.type_id == "6") {
//                   //   child = Center(
//                   //     child: Text(
//                   //       content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                   //       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                   //       textAlign: TextAlign.center,
//                   //     ),
//                   //   );
//                   // } 
//                   else if (content.type_id == "2") {
//                     // Handle image
//                     child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
//                   } else if (content.type_id == "3") {
//                     // Handle audio
//                     child = content.audiourl == null || content.audiourl!.isEmpty
//                         ? Text("Audio Link Missing")
//                         : IconButton(
//                             icon: Icon(Icons.volume_up),
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     content: SingleChildScrollView(
//                                       child: ListBody(
//                                         children: <Widget>[
//                                           Center(
//                                             child: AudioPlayerWidget(
//                                               audioUrl: linkapi + content.audiourl!,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           );
//                   } else {
//                     child = SizedBox();
//                   }
//                   return GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             content: SingleChildScrollView(
//                               child: ListBody(
//                                 children: <Widget>[
//                                   if (content.type_id == "6" && content.text_type == '1') ...[
//                                     Text(
//                                            content.title_arbic ?? "",
//                                       // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                    if (content.type_id == "6" && content.text_type == '2') ...[
//                                     Text(
//                                            content.description ?? "",
//                                       // content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 2 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                   if (content.type_id == "2") ...[
//                                     imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                   ],
//                                   if (content.type_id == "3") ...[
//                                     content.audiourl == null || content.audiourl!.isEmpty
//                                         ? Text("Audio Link Missing")
//                                         : Column(
//                                             // mainAxisSize: MainAxisSize.min, 
//                                             children: [
//                                               Center(
//                                                 child: AudioPlayerWidget(
//                                                   audioUrl: linkapi + content.audiourl!,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: reusablebordercontainer(context, 1, 0.4, 1, child),
//                   );
//                 },
//               ),
//               if (i + 3 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//             ],    
//           ],
//         ),
//       ),
//     );
//   }
// }





//correct one 
// class GroupWidget extends StatefulWidget {
//   final List<LessonIntroDataitems> items;
//   GroupWidget(this.items);

//   @override
//   State<GroupWidget> createState() => _GroupWidgetState();
// }

// class _GroupWidgetState extends State<GroupWidget> {
//   @override
// Widget build(BuildContext context) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (int i = 0; i < widget.items.length; i += 4) ...[
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 15,
//               ),
//               itemCount: (i + 4 <= widget.items.length) ? 4 : widget.items.length - i,
//               itemBuilder: (context, index) {
//                 final content = widget.items[i + index];
//                 double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                 String? colorCode = content.text_color_code;
//                 Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                 var imageurl = content.featured_image;
//                 var linkapi = "https://quranarbi.turk.pk/public/public/";
                
//                 Widget child;

//                 if (content.type_id == "6") {
//                   child = Center(
//                     child: Text(
//                       content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                       style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Alvi", color: textColor),
//                       textAlign: TextAlign.center,
//                     ),
//                   );
//                 } else if (content.type_id == "2") {
//                   // Handle image
//                   child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
//                 } 
//                 else if (content.type_id == "3") {
//                   // Handle audio
//                   child = content.audiourl == null || content.audiourl!.isEmpty
//                       ? Text("Audio Link Missing")
//                       : IconButton(
//                           icon: Icon(Icons.volume_up_rounded),
//                           onPressed: () {
//                             PlayAudio("https://quranarbi.turk.pk/public/public/" + content.audiourl!, context);
//                           },
//                         );
//                 } 
//                 else {
//                   child = SizedBox();
//                 }
//                 return GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           content: SingleChildScrollView(
//                             child: ListBody(
//                               children: <Widget>[
//                                 if (content.type_id == "6") ...[
//                                   Text(
//                                     content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                     style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Alvi", color: textColor),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                                 if (content.type_id == "2") ...[
//                                   imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                 ],
//                                 if (content.type_id == "3") ...[
//                                   content.audiourl == null || content.audiourl!.isEmpty
//                                       ? Text("Audio Link Missing")
//                                       : IconButton(
//                                           icon: Icon(Icons.volume_up_rounded),
//                                           onPressed: () {
//                                             PlayAudio("https://quranarbi.turk.pk/public/public/" + content.audiourl!, context);
//                                           },
//                                         ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: reusablebordercontainer(context, 1, 0.4, 1, child),
//                 );
//               },
//             ),
//             if (i + 4 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//           ],
//         ],
//       ),
//     ),
//   );
// }
// }




// class GroupWidget extends StatefulWidget {
//   final List<LessonIntroDataitems> items;
//   GroupWidget(this.items);

//   @override
//   State<GroupWidget> createState() => _GroupWidgetState();
// }

// class _GroupWidgetState extends State<GroupWidget> {
//   final AudioPlayer _player = AudioPlayer();
//   bool isPlaying = false;
//   String audioUrl = "";

//   Future<void> _init(String url) async {
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.speech());
//     await _player.setUrl(url);
//     _player.playingStream.listen((playing) {
//       setState(() {
//         isPlaying = playing;
//       });
//     });
//   }

//   void _playPause() {
//     if (isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//   }

//   void _seekForward() async {
//     Duration position = await _player.position;
//     Duration duration = await _player.duration ?? Duration.zero;
//     if (position + Duration(seconds: 10) < duration) {
//       _player.seek(position + Duration(seconds: 10));
//     }
//   }

//   void _seekBackward() async {
//     Duration position = await _player.position;
//     if (position - Duration(seconds: 10) > Duration.zero) {
//       _player.seek(position - Duration(seconds: 10));
//     }
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

  
// @override
// Widget build(BuildContext context) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           for (int i = 0; i < widget.items.length; i += 4) ...[
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 15,
//                 childAspectRatio: widget.items[i].type_id == "6" && widget.items[i].text_type == '1' ? 1 / 1.2 : 1,
//                 // childAspectRatio: 1 / (widget.items[i].type_id == "6" && widget.items[i].text_type == '1' ? 0.9 : 1), // Adjust height for Arabic text cards
//               ),
//               itemCount: widget.items.length -1,
//               itemBuilder: (context, index) {
//                 widget.items.sort((a, b) => b.id.compareTo(a.id));
//                    final content = widget.items[index + 1]; 
//                 // final content = widget.items[i + index];
//                 double? fontSize = double.tryParse(content.font_size ?? "14.0");
//                 String? colorCode = content.text_color_code;
//                 Color textColor = colorCode != null ? Color(int.parse("0xff" + colorCode)) : Colors.black;
//                 var imageurl = content.featured_image;
//                 var linkapi = "https://quranarbi.turk.pk/public/public/";
//                 Widget child;
//             if (content.type_id == "6") {
//   // Arabic Text Card with Audio Icon
//   child = Stack(
//     alignment: Alignment.center,
//     children: [
//       Center(
//         child: Text(
//           content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//           style: TextStyle(
//             fontSize: fontSize,
//             fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//             color: textColor,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       if (content.text_type == "1") 
//         Positioned(
//           top: 90,
//           bottom: 2.0,
//           right: 1.0,
//           child: IconButton(
//             icon: Icon(Icons.volume_up),
//             color: Colors.black,
//             onPressed: () {
//               if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       content: SingleChildScrollView(
//                         child: ListBody(
//                           children: <Widget>[
//                             Center(
//                               child: AudioPlayerWidget(
//                                 audioUrl: linkapi + content.audiourl!,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//     ],
//   );
// }
//                 else if (content.type_id == "2") {
//                   child = imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl);
//                 } 
//                 else if (content.type_id == "3") {
//               child = SizedBox(); 
// }
//                 // else if (content.type_id == "3") {
//                 //   // Separate Audio Card
//                 //   child = content.audiourl == null || content.audiourl!.isEmpty
//                 //       ? Text("Audio Link Missing")
//                 //       : IconButton(
//                 //           icon: Icon(Icons.volume_up),
//                 //           onPressed: () {
//                 //             showDialog(
//                 //               context: context,
//                 //               builder: (BuildContext context) {
//                 //                 return AlertDialog(
//                 //                   content: SingleChildScrollView(
//                 //                     child: ListBody(
//                 //                       children: <Widget>[
//                 //                         Center(
//                 //                           child: AudioPlayerWidget(
//                 //                             audioUrl: linkapi + content.audiourl!,
//                 //                           ),
//                 //                         ),
//                 //                       ],
//                 //                     ),
//                 //                   ),
//                 //                 );
//                 //               },
//                 //             );
//                 //           },
//                 //         );
//                 // } 
//                 else {
//                   child = SizedBox();
//                 }
//                 return GestureDetector(
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           content: SingleChildScrollView(
//                             child: ListBody(
//                               children: <Widget>[

//   //                                  if (content.type_id == "6") ...[
//   // // Arabic Text Card with Audio Icon
//   // child = Stack(
//   //   alignment: Alignment.center,
//   //   children: [
//   //     Center(
//   //       child: Text(
//   //         content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//   //         style: TextStyle(
//   //           fontSize: fontSize,
//   //           fontFamily: content.text_type == "1" ? "Cairo" : "Muhammadi Naskh",
//   //           color: textColor,
//   //         ),
//   //         textAlign: TextAlign.center,
//   //       ),
//   //     ),
//   //     if (content.text_type == "1") // Show volume icon only for Arabic text
//   //       Positioned(
//   //         bottom: 2.0,
//   //         right: 8.0,
//   //         child: IconButton(
//   //           icon: Icon(Icons.volume_up),
//   //           color: Colors.black,
//   //           onPressed: () {
//   //             if (content.audiourl != null && content.audiourl!.isNotEmpty) {
//   //               showDialog(
//   //                 context: context,
//   //                 builder: (BuildContext context) {
//   //                   return AlertDialog(
//   //                     content: SingleChildScrollView(
//   //                       child: ListBody(
//   //                         children: <Widget>[
//   //                           Center(
//   //                             child: AudioPlayerWidget(
//   //                               audioUrl: linkapi + content.audiourl!,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               );
//   //             }
//   //           },
//   //         ),
//   //       ),
//   //   ],
                                   
//   // ),
//   //                                  ],

//                                 if (content.type_id == "6") ...[
//                                   Text(
//                                     content.text_type == "1" ? content.title_arbic ?? "" : content.description ?? "",
//                                     style: TextStyle(fontSize: fontSize, fontFamily: content.text_type == 1 ? "Cairo" : "Muhammadi Naskh", color: textColor),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                        ],
//                                   if (content.type_id == "3") ...[
//                                        content.audiourl == null || content.audiourl!.isEmpty
//                                       ? Text("Audio Link Missing")
//                                       : Column(
//                                           // mainAxisSize: MainAxisSize.min, 
//                                           children: [
//                                             Center(
//                                               child: AudioPlayerWidget(
//                                                 audioUrl: linkapi + content.audiourl!,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                     // IconButton(
//                                     //   icon: Icon(Icons.volume_up),
//                                     //   color: Colors.black,
//                                     //   onPressed: () {
//                                     //     showDialog(
//                                     //       context: context,
//                                     //       builder: (BuildContext context) {
//                                     //         return AlertDialog(
//                                     //           content: SingleChildScrollView(
//                                     //             child: ListBody(
//                                     //               children: <Widget>[
//                                     //                 Center(
//                                     //                   child: AudioPlayerWidget(
//                                     //                     audioUrl: linkapi + content.audiourl!,
//                                     //                   ),
//                                     //                 ),
//                                     //               ],
//                                     //             ),
//                                     //           ),
//                                     //         );
//                                     //       },
//                                     //     );
//                                     //   },
//                                     // ),
//                                   ],
                           
//                                 if (content.type_id == "2") ...[
//                                   imageurl == null ? Text("Image here") : Image.network(linkapi + imageurl),
//                                 ],
//                                 // if (content.type_id == "3") ...[
//                                 //   content.audiourl == null || content.audiourl!.isEmpty
//                                 //       ? Text("Audio Link Missing")
//                                 //       : Column(
//                                 //           // mainAxisSize: MainAxisSize.min, 
//                                 //           children: [
//                                 //             Center(
//                                 //               child: AudioPlayerWidget(
//                                 //                 audioUrl: linkapi + content.audiourl!,
//                                 //               ),
//                                 //             ),
//                                 //           ],
//                                 //         ),
//                                 // ],
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: reusablebordercontainer(context, 1, 0.4, 1, child),
//                 );
//               },
//             ),
//             if (i + 3 < widget.items.length) Divider(thickness: 1, color: Colors.black),
//           ],    
//         ],
//       ),
//     ),
//   );
// }
// }
