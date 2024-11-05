import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran_arabi/view/hadith/hadiths.dart';

class Chapters extends StatefulWidget {
  final String bookSlug;
  const Chapters({Key? key, required this.bookSlug}) : super(key: key);

  @override
  State<Chapters> createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  late String bookSlug;

  @override
  void initState() {
    super.initState();
    bookSlug = widget.bookSlug;
    chapters();
  }

  Future<List<Map<String, dynamic>>> chapters() async {
    final apiKey = Uri.encodeComponent(r'$2y$10$xDzjHBbWarkWPD5DUfa0H44mVNz5CEHxUAKqOGJxlqbxbTf9wHA');
    final response = await http.get(
      Uri.parse('https://www.hadithapi.com/api/${bookSlug}/chapters?apiKey=$apiKey'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 200) {
        List<dynamic> chaptersList = jsonData['chapters'];
        List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
            chaptersList.map((chapters) => chapters as Map<String, dynamic>));
        return dataList;
      } else {
        throw Exception('Books data not found in the response');
      }
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters of ${widget.bookSlug}'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 2, 129, 148),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chapters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No chapters available'),
            );
          } else {
            final chapters = snapshot.data!;
            return SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true, // Important to make GridView adjust its height
                physics: NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                padding: EdgeInsets.all(MediaQuery.sizeOf(context).height*0.01),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3.0,
                  mainAxisSpacing: 10,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Hadiths(bookSlug: bookSlug,chapterNumber: chapter['chapterNumber'],),));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.sizeOf(context).height*0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chapter ${chapter['chapterNumber']}: ${chapter['chapterEnglish']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 2, 129, 148),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                chapter['chapterArabic'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Al',
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 5),
                              Text(
                                chapter['chapterUrdu'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
