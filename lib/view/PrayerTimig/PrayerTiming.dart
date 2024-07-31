import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

import '../../function/functions.dart';
import '../../model/images_get.dart';
import '../Home/header.dart';
import '../Home/menubar.dart';
import '../Home/networkheader.dart';

class PrayerTiming extends StatefulWidget {
  @override
  State<PrayerTiming> createState() => _PrayerTimingState();
}

class _PrayerTimingState extends State<PrayerTiming> {
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
                                return Column(children: [if(snapshot.data![index].id==2)...{
                                  Headernetwork.with_text_ur(linkapi+imageurl, '',
                      Colors.white, false, 'آج کی نمازیں', true),
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
                  // Header.with_text_ur("assets/images/mountains.jpg", '',
                  //     Colors.black, false, 'آج کی نمازیں', true),
                  TopMenu(false, true, false, false, false),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        //   side: BorderSide(
                        //   style: BorderStyle.solid,
                        //   width: 2,
                        //   color: Colors.cyan,
                        // ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          time_tab('fajr', Prayer.fajr),
                          Container(
                            height: 1,
                            color: Colors.cyan,
                          ),
                          time_tab('dhuhr', Prayer.dhuhr),
                          Container(
                            height: 1,
                            color: Colors.cyan,
                          ),
                          time_tab('asr', Prayer.asr),
                          Container(
                            height: 1,
                            color: Colors.cyan,
                          ),
                          time_tab('maghrib', Prayer.maghrib),
                          Container(
                            height: 1,
                            color: Colors.cyan,
                          ),
                          time_tab('isha', Prayer.isha),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

String namaz_time(var namaz) {
  final myCoordinates = Coordinates(24.8607, 67.0011);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  int? hour = prayerTimes.timeForPrayer(namaz)?.hour;
  String time_txt;

  if (hour! > 12) {
    time_txt =
        '${hour - 12}:${prayerTimes.timeForPrayer(namaz)?.minute.toString().padLeft(2, '0')} PM';
  } else if (hour == 12) {
    time_txt =
        '${hour}:${prayerTimes.timeForPrayer(namaz)?.minute.toString().padLeft(2, '0')} PM';
  } else {
    time_txt =
        '${hour}:${prayerTimes.timeForPrayer(namaz)?.minute.toString().padLeft(2, '0')} AM';
  }

  return time_txt;
}

String current_namaz() {
  final myCoordinates = Coordinates(24.8607, 67.0011);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);
  return prayerTimes.currentPrayer().name.toString().toUpperCase();
}

class time_tab extends StatelessWidget {
  var title;
  var color_value;
  var namaz;

  time_tab(this.title, this.namaz) {
    if (current_namaz()
            .toUpperCase()
            .compareTo(title.toString().toUpperCase()) ==
        0) {
      color_value = Colors.cyan;
    } else {
      color_value = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title.toString().toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
                    color: color_value,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                namaz_time(namaz),
                style: TextStyle(fontSize: 17, color: color_value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
