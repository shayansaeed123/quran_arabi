import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Hadiths extends StatefulWidget {
  final String bookSlug;
  Hadiths({super.key, required this.bookSlug});

  @override
  State<Hadiths> createState() => _HadithsState();
}

class _HadithsState extends State<Hadiths> {
  late String bookSlug;

  @override
  void initState() {
    super.initState();
    bookSlug = widget.bookSlug;
  }

  Future<List<Map<String, dynamic>>> hadiths() async {
    final apiKey = Uri.encodeComponent(r'$2y$10$xDzjHBbWarkWPD5DUfa0H44mVNz5CEHxUAKqOGJxlqbxbTf9wHA');
    final response = await http.get(
      Uri.parse('https://www.hadithapi.com/api/hadiths?apiKey=$apiKey&book=$bookSlug'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 200 && jsonData['hadiths']['data'] is List) {
        List<dynamic> hadithsList = jsonData['hadiths']['data'];
        List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
            hadithsList.map((hadiths) => hadiths as Map<String, dynamic>));
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
        title: Text(bookSlug,style: TextStyle(fontFamily: 'Al'),),
        backgroundColor: Color.fromARGB(255, 2, 129, 148),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: hadiths(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading data',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Hadiths found',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final hadith = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hadith ${hadith['hadithNumber'] ?? index + 1}', // Show hadith number
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          hadith['hadithArabic'] ?? 'No Arabic text available',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Al',
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          hadith['hadithUrdu'] ?? 'No Urdu translation available',
                          style: TextStyle(
                            fontFamily: 'Al',
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
