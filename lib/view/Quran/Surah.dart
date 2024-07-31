import 'package:flutter/material.dart';
// import 'package:qurani_arabi_flutter/view/Quran/db_helper.dart';

import '../../model/Ayah.dart';
import '../../model/Word.dart';
import 'db_helper.dart';


class Surah extends StatefulWidget {
  var surah_id;
  var surah_name;

  Surah(this.surah_id, this.surah_name);

  @override
  State<Surah> createState() => _SurahState();
}

class _SurahState extends State<Surah> {
  DatabaseHelper db_helper = new DatabaseHelper();

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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 2, bottom: 4),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                        Colors.cyan,
                        Color(0xff00838f),
                      ])),
                  child: Center(
                    child: Text(
                      widget.surah_name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Al',
                          color: Colors.white),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      Builder(builder: (context) {
                        if (widget.surah_id != 9) {
                          return bismillah_widget();
                        } else {
                          return Container();
                        }
                      }),
                      Container(
                        width: double.infinity,
                        child: FutureBuilder<List<AyahModal>>(
                            future:
                                db_helper.SurahDb(widget.surah_id.toString()),
                            builder: (context, snapshot) {
                              print('surah_id: ' + widget.surah_id.toString());
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ayah_widget(
                                        snapshot.data![index].list, index);
                                  },
                                );
                              } else {
                                Text('No data');
                              }
                              return Center(
                                child: Text(
                                  'Loading...',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class ayah_widget extends StatelessWidget {
  List<WordModal> list;
  int index;
  var color_val = Colors.grey[50];

  ayah_widget(
    this.list,
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    if (index % 2 == 0) {
      color_val = Color(0xEAE7E7E7);
    } else {
      color_val = Colors.grey[50];
    }

    return Container(
      color: color_val,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              children: GenerateLine(list),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '(' + (index + 1).toString() + ')',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class bismillah_widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Builder(builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِیْمِ',
                        style: TextStyle(
                            fontFamily: 'Al',
                            fontSize: 19,
                            color: Colors.black),
                      ),
                    );
                  }),
                ),
                Container(
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Builder(builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        'اللہ کے نام سے شروع جو نہایت مہربان ، رحمت والاہے ۔',
                        style: TextStyle(
                            fontFamily: 'Alvi',
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class table_item extends StatelessWidget {
  var txt_value;
  var url;
  var color_value;
  bool is_ur = false;
  bool is_ar = false;
  bool is_en = false;

  table_item.ar(this.txt_value, this.url, this.color_value) {
    this.is_ar = true;
  }

  table_item.ur(this.txt_value, this.url, this.color_value) {
    this.is_ur = true;
  }

  table_item.en(this.txt_value, this.url, this.color_value) {
    this.is_en = true;
  }

  double wid(BuildContext context) {
    if (MediaQuery.of(context).size.width > 500) {
      return MediaQuery.of(context).size.width / 7.5;
    } else {
      return MediaQuery.of(context).size.width / 4.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // PlayAudio(url, context);
      },
      child: Card(
        margin: EdgeInsets.all(0),
        child: Container(
          width: wid(context),
          alignment: AlignmentDirectional.center,
          color: Colors.white,
          child: Builder(builder: (context) {
            if (is_ur) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  txt_value,
                  style: TextStyle(
                      fontFamily: 'Alvi', fontSize: 14, color: color_value),
                ),
              );
            } else if (is_ar) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  txt_value,
                  style: TextStyle(
                      fontFamily: 'Al', fontSize: 19, color: color_value),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  txt_value,
                  style: TextStyle(fontSize: 14, color: color_value),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

class word extends StatelessWidget {
  var ar, ur;

  word(this.ar, this.ur);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      child: Column(
        children: [
          table_item.ar(ar, 'null', Colors.black),
          SizedBox(height: 2),
          table_item.ur(ur, 'null', Colors.black),
        ],
      ),
    );
  }
}

List<Widget> GenerateLine(List<WordModal> list) {
  List<Widget> items = [];

  for (int i = 0; i < list.length; i++) {
    items.add(word(list[i].arabic_word, list[i].urdu_meaning));
  }

  return items;
}
