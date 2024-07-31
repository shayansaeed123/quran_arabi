
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_arabi/accounts/googlesignin.dart';

import 'view/Home/dashboard.dart';
import 'view/register/login/login.dart';
// import 'package:qurani_arabi_flutter/view/Home/dashboard.dart';
// import 'package:qurani_arabi_flutter/view/register/login/login.dart';
AudioPlayer? player;
Future<void> main() async {
  //  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  player = AudioPlayer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Qurani Arabi',
      debugShowCheckedModeBanner: false,
      home: Home(),
      // home: SignInScreen(),
    );
  }
}




// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:quran_arabi/model/lesson_intro_data_items.dart';
//  import 'package:http/http.dart' as http;



// class ContentList extends StatefulWidget {
//   @override
//   _ContentListState createState() => _ContentListState();
// }

// class _ContentListState extends State<ContentList> {
//    late Future<List<LessonIntroDataitems>> futureContents;

// // Future<List<LessonIntroDataitems>> fetchData() async {
// //   final response = await http.get(Uri.parse('https://quranarbi.turk.pk/api/contents'));
// //   if (response.statusCode == 200) {
// //     List<dynamic> jsonData = json.decode(response.body);
// //     return jsonData.map((json) => LessonIntroDataitems.fromJson(json)).toList();
// //   } else {
// //     throw Exception('Failed to load data');
// //   }
// // }


// Future<List<LessonIntroDataitems>> fetchData() async {
//   final response = await http.post(
//     Uri.parse('https://quranarbi.turk.pk/api/contents'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'lesson_id': '24',
//       'sub_category_id': '15',
//     }),
//   );

//   if (response.statusCode == 200) {
//     List<dynamic> jsonData = json.decode(response.body);
//     return jsonData.map((json) => LessonIntroDataitems.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// Map<String, List<LessonIntroDataitems>> groupDataByGroupId(List<LessonIntroDataitems> contents) {
//   Map<String, List<LessonIntroDataitems>> groupedData = {};
//   for (var content in contents) {
//     if (!groupedData.containsKey(content.groupId)) {
//       groupedData[content.groupId] = [];
//     }
//     groupedData[content.groupId]!.add(content);
//   }
//   return groupedData;
// }

//   @override
//   void initState() {
//     super.initState();
//     futureContents = fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Grouped Contents'),
//       ),
//       body: FutureBuilder<List<LessonIntroDataitems>>(
//         future: futureContents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             var groupedData = groupDataByGroupId(snapshot.data!);
//             return ListView(
//               children: groupedData.keys.map((groupId) {
//                 return ExpansionTile(
//                   title: Text('Group ID: $groupId'),
//                   children: groupedData[groupId]!.map((content) {
//                     return ListTile(
//                       title: Text(content.title),
//                       subtitle: Text(content.description),
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: ContentList()));
