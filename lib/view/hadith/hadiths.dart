import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Hadiths extends StatefulWidget {
  final String bookSlug;
  final String chapterNumber;
  Hadiths({super.key, required this.bookSlug, required this.chapterNumber});

  @override
  State<Hadiths> createState() => _HadithsState();
}

class _HadithsState extends State<Hadiths> {
  late String bookSlug;
  late String chapterNumber;
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _hadithsList = [];
  List<Map<String, dynamic>> _filteredHadiths = [];
  late Future<void> _hadithsFuture;

  @override
  void initState() {
    super.initState();
    bookSlug = widget.bookSlug;
    chapterNumber = widget.chapterNumber;
    _searchController = TextEditingController();
    _hadithsFuture = _fetchHadiths(); // Fetch data once during initState
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHadiths() async {
    final apiKey = Uri.encodeComponent(r'$2y$10$xDzjHBbWarkWPD5DUfa0H44mVNz5CEHxUAKqOGJxlqbxbTf9wHA');
    final response = await http.get(
      Uri.parse('https://www.hadithapi.com/api/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=${chapterNumber}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 200 && jsonData['hadiths']['data'] is List) {
        setState(() {
          _hadithsList = List<Map<String, dynamic>>.from(jsonData['hadiths']['data']);
          _filteredHadiths = _hadithsList; // Initialize the filtered list with all hadiths
        });
      } else {
        throw Exception('Hadiths data not found in the response');
      }
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }

  void _filterHadiths(String query) {
    setState(() {
      _filteredHadiths = _hadithsList.where((hadith) {
        final arabicText = hadith['hadithArabic'] ?? '';
        final urduText = hadith['hadithUrdu'] ?? '';
        final hadithNumber = hadith['hadithNumber']?.toString() ?? '';
        
        return arabicText.contains(query) ||
               urduText.contains(query) ||
               hadithNumber.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bookSlug,
          style: TextStyle(fontFamily: 'Al'),
        ),
        backgroundColor: Color.fromARGB(255, 2, 129, 148),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Hadith',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterHadiths, // Filter results as the user types
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<void>(
                future: _hadithsFuture, // Use the initialized future
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading data',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  } else if (_filteredHadiths.isEmpty) {
                    return Center(
                      child: Text(
                        'No Hadiths found',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _filteredHadiths.length,
                    itemBuilder: (BuildContext context, int index) {
                      final hadith = _filteredHadiths[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hadith ${hadith['hadithNumber'] ?? index + 1}',
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
          ],
        ),
      ),
    );
  }
}
