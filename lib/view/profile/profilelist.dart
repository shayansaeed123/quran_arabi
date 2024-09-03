import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quran_arabi/model/lessson.dart';
import 'package:quran_arabi/view/profile/resultpage.dart';
import 'package:quran_arabi/database/mysharedpreferece.dart';



class myprofile extends StatefulWidget {
  const myprofile({super.key});

  @override
  State<myprofile> createState() => _myprofileState();
}

class _myprofileState extends State<myprofile> {
    late Future<List<Lesson>> futureLessons;

  @override
  void initState() {
    super.initState();
    futureLessons = fetchLessons();
    print(MySharedPrefrence().get_userid());
  }


Future<List<Lesson>> fetchLessons() async {
  print(MySharedPrefrence().get_userid());
  final response = await http.post(
    Uri.parse('https://quranarbi.turk.pk/api/appUserLessons'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'user_id': MySharedPrefrence().get_userid(),
    }),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Lesson.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load lessons');
  }
}
 

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Students List'),
    ),
      body: FutureBuilder<List<Lesson>>(
        future: futureLessons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
       return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
                  var lesson = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.0), 
                  ),
                  elevation: 5, 
                  child: ListTile(
                    contentPadding: EdgeInsets.all(6.0),
                    leading:Text(lesson.lessons[0].lessonTitle),
                    title: Text("First Attempt : ${lesson.lessons[0].attempted1.toString()}"),
                    subtitle: Text("second Attempt : ${lesson.lessons[0].attempted2.toString()}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reslut(lessonId: lesson.lessons[0].lessonId),
      ),
    );
                      },
                      child: Text("View Result"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const  Color.fromARGB(255, 2, 129, 148),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          }
        }
      )
  );
}
}


