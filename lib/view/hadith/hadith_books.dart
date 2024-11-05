import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_arabi/function/functions.dart';
import 'package:quran_arabi/model/images_get.dart';
import 'package:quran_arabi/view/Home/menubar.dart';
import 'package:quran_arabi/view/Home/networkheader.dart';
import 'package:http/http.dart' as http;
import 'package:quran_arabi/view/hadith/chapters.dart';
import 'package:quran_arabi/view/hadith/hadiths.dart';

class HadithBooks extends StatefulWidget {
  const HadithBooks({super.key});

  @override
  State<HadithBooks> createState() => _HadithBooksState();
}

class _HadithBooksState extends State<HadithBooks> {
  Future<List<Map<String, dynamic>>> hadithBooks() async {
    final apiKey = Uri.encodeComponent(
        r'$2y$10$xDzjHBbWarkWPD5DUfa0H44mVNz5CEHxUAKqOGJxlqbxbTf9wHA');
    final response = await http.get(
      Uri.parse('https://www.hadithapi.com/api/books?apiKey=$apiKey'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 200 && jsonData['books'] is List) {
        List<dynamic> booksList = jsonData['books'];
        List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
            booksList.map((book) => book as Map<String, dynamic>));
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // db_helper.initDb();
    hadithBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.cyan,
                Color(0xff00838f),
              ])),
        ),
        SafeArea(
          child: Container(
            color: Colors.grey[50],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<imageget>>(
                    future: imagedata(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                var imageurl =
                                    snapshot.data![index].featured_image;
                                var linkapi = "https://quranarbi.turk.pk/";
                                return Column(
                                  children: [
                                    if (snapshot.data![index].id == 3) ...{
                                      Headernetwork.with_text_ur(
                                          linkapi + imageurl,
                                          '',
                                          Colors.white,
                                          false,
                                          '',
                                          true),
                                      //             Headernetwork(linkapi+imageurl, '', Colors.black,
                                      // true)
                                    }
                                  ],
                                );
                              });
                        }
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
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
                  TopMenu(false, false, false, false, false, false, false),
                  Container(
                    width: double.infinity,
                    child: FutureBuilder(
                        future: hadithBooks(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length - 2,
                              itemBuilder: (BuildContext context, int index) {
                                print("hadith data ${snapshot.data}");
                                print(
                                    'book name ${snapshot.data![index]['bookSlug']}');
                                return hadith_widget(
                                    snapshot.data![index]['bookName'],
                                    snapshot.data![index]['hadiths_count'],
                                    snapshot.data![index]['id'],
                                    snapshot.data![index]['bookSlug']);
                              },
                            );
                          } else {
                            Text('No data');
                          }
                          return Center(
                            child: Text(
                              'Loading...',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class hadith_widget extends StatelessWidget {
  var bookslug, en, name, length, number;

  hadith_widget(

      // this.en,
      this.name,
      this.length,
      this.number,
      this.bookslug);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chapters(
              bookSlug: bookslug,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
        color: Colors.white,
        child: Container(
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(5)),
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          // 'سورۃ' + ar,
                          name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'new1',
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hadith ' + length.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
