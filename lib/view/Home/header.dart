import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:libcalendar/libcalendar.dart';

class Header extends StatefulWidget {
  var bg_img;
  var title;
  Color color;
  bool search_visibility;
  bool urdu = false;
  var search_text = '';

  Header(this.bg_img, this.title, this.color, this.search_visibility);
  Header.with_text(this.bg_img, this.title, this.color, this.search_visibility,
      this.search_text);
  Header.with_text_ur(this.bg_img, this.title, this.color,
      this.search_visibility, this.search_text, this.urdu);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height*0.30,
          // Background
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.bg_img), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 30,left: 5,right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Now',
                      style: TextStyle(fontSize: 12, color: widget.color),
                    ),
                    Text(
                      current_namaz_name(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Upcoming',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      coming_namaz_name(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      coming_namaz_time(),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '',
                      // islamic_day(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      '',
                      // islamic_date(),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.color,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      day(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: widget.color,
                      ),
                    ),
                    Text(
                      date(),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          alignment: AlignmentDirectional.center,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ),
        ),
        
      ],
    );
  }
}

String date() {
  DateTime internetTime = DateTime.now();
  // DateTime date = new DateTime(now.year, now.month, now.day);
  return DateFormat('d-MMM-y').format(internetTime).toString();
}

String day() {
  DateTime internetTime = DateTime.now();
  // DateTime date = new DateTime(now.year, now.month, now.day);
  return DateFormat('EEEE').format(internetTime).toString();
}

// String islamic_date() {
//   var arr = [
//     'Muharram',
//     'Safar',
//     'Rabi al-Awwal',
//     'Rabi al-Thani',
//     'Jumada al-Awwal',
//     'Jumada al-Thani',
//     'Rajab',
//     'Shabaan',
//     'Ramadan',
//     'Shawwal',
//     'Dhu al-Qadah',
//     'Dhu al-Hijjah'
//   ];

//   DateTime internetTime = DateTime.now();
//   // DateTime date = new DateTime(now.year, now.month, now.day);
//   DateTime islamic = fromGregorianToIslamic(
//       internetTime.year, internetTime.month, internetTime.day);

//   String date =
//       arr[islamic.month - 1].toString() + ', ' + islamic.year.toString();

//   return date;
// }

// String islamic_day() {
//   DateTime internetTime = DateTime.now();
//   // DateTime date = new DateTime(now.year, now.month, now.day);
//   DateTime islamic = fromGregorianToIslamic(
//       internetTime.year, internetTime.month, internetTime.day);

//   return islamic.day.toString();
// }

String current_namaz_name() {
  final myCoordinates = Coordinates(24.8607, 67.0011);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  return prayerTimes.currentPrayer().name.toString().toUpperCase();
}

String coming_namaz_name() {
  final myCoordinates = Coordinates(24.8607, 67.0011);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  return prayerTimes.nextPrayer().name.toString().toUpperCase();
}

String coming_namaz_time() {
  final myCoordinates = Coordinates(24.8607, 67.0011);
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.hanafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  int? hour = prayerTimes.timeForPrayer(prayerTimes.nextPrayer())?.hour;
  String time_txt;

  if (hour! > 12) {
    time_txt =
        '${hour - 12}:${prayerTimes.timeForPrayer(prayerTimes.nextPrayer())?.minute.toString().padLeft(2, '0')} PM';
  } else if (hour == 12) {
    time_txt =
        '${hour}:${prayerTimes.timeForPrayer(prayerTimes.nextPrayer())?.minute.toString().padLeft(2, '0')} PM';
  } else {
    time_txt =
        '${hour}:${prayerTimes.timeForPrayer(prayerTimes.nextPrayer())?.minute.toString().padLeft(2, '0')} AM';
  }

  return time_txt;
}
