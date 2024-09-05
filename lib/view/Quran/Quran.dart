import 'package:flutter/material.dart';
// import 'package:qurani_arabi_flutter/view/Quran/db_helper.dart';

import '../../function/functions.dart';
import '../../model/Surah.dart';
import '../../model/images_get.dart';
import '../Home/header.dart';
import '../Home/menubar.dart';
import '../Home/networkheader.dart';
import 'Surah.dart';
import 'db_helper.dart';

class Quran extends StatefulWidget {
  const Quran({Key? key}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  DatabaseHelper db_helper = new DatabaseHelper();
  late List<SurahModal> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // db_helper.initDb();
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
                if(snapshot.connectionState==ConnectionState.done){
                  return  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                                itemCount: 
                                snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) { 
                                var imageurl=snapshot.data![index].featured_image;
                                var linkapi="https://quranarbi.turk.pk/";
                                return Column(children: [if(snapshot.data![index].id==3)...{
                                  Headernetwork.with_text_ur(linkapi+imageurl, '',
                      Colors.white, false, '', true),
                      //             Headernetwork(linkapi+imageurl, '', Colors.black,
                      // true)
                                }],); 
                                });  
              
                }}
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.55,
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
                   TopMenu(false, false, false, false, false,false,false),
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<List<SurahModal>>(
                        future: db_helper.initDb(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return surah_widget(
                                    snapshot.data![index].surah_name_ar,
                                    snapshot.data![index].surah_name_en,
                                    snapshot.data![index].surah_name,
                                    snapshot.data![index].surah_length,
                                    snapshot.data![index].id);
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

class surah_widget extends StatelessWidget {
  var ar, en, name, length, number;

  surah_widget(this.ar, this.en, this.name, this.length, this.number);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Surah(number, 'سورۃ ' + ar),
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
                          'سورۃ' + ar,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Al',
                              color: Colors.blue),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            en,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 13, color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            'Verses ' + length.toString(),
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
