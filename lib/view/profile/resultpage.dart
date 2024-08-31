import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class reslut extends StatefulWidget {
   final int lessonId;

  reslut({required this.lessonId});
  // const reslut({super.key});

  @override
  State<reslut> createState() => _reslutState();
}

class _reslutState extends State<reslut> {
   List<dynamic> _result = [];

  @override
  void initState() {
    super.initState();
    fetchResult();
  }



Future<void> fetchResult() async {
  final url = Uri.parse('https://quranarbi.turk.pk/api/appUserResults');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, 
      body: jsonEncode({
        'lesson_id': widget.lessonId,
        'user_id': '9',
      }), 
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      setState(() {
        _result = data; // Update the _result list with the fetched data
      });

      print(_result);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
}

@override
Widget build(BuildContext context) {
   final screenHeight = MediaQuery.of(context).size.height;
  final cardHeight = screenHeight * 0.14; 
  return Scaffold(
    appBar: AppBar(
      title: Text('Students Result'),
    ),
    body: _result.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _result.length,
            itemBuilder: (context, index) {
              final item = _result[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0), 
                child: Container(
                  height: cardHeight,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/question.png'), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                  child: Center(
                    child: Padding( 
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(10.0), 
                        ),
                        color: Colors.transparent, 
                        elevation: 0, 
                        child: ListTile(
                          leading: Text('Q no : ${item['question_id']} )'),
                          title: Text('No Of Attempts : ${item['no_of_attempts']}'),
                          trailing: item['status'] == "1"
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : item['status'] == "2"
                                  ? Icon(Icons.cancel, color: Colors.red)
                                  : Icon(Icons.help, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
  );
}
}