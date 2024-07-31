// import 'dart:async';
// import 'dart:math' show pi;
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:qurani_arabi_flutter/qiblaah/qiblah_maps.dart';
// import 'loading_indicator.dart';
// import 'location_error_widget.dart';

// class QiblahCompass extends StatefulWidget {
//   @override
//   _QiblahCompassState createState() => _QiblahCompassState();
// }

// class qibladesign extends StatelessWidget {
//   final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Stack(
//           children: [
//             Image(
//               image: AssetImage("assets/images/screen_pattern_bg.jpg"),
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//             Container(
//               alignment: AlignmentDirectional.topCenter,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 padding: const EdgeInsets.only(top: 0),
//                 child: Column(
//                   children: const [
//                     Image(
//                       image: AssetImage("assets/images/top2.png"),
//                       width: double.infinity,
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 60,
//                 top: 230,
//                 right: 60,
//                 bottom: 0,
//               ),
//               child: RichText(
//                 textAlign: TextAlign.center,
//                 text: const TextSpan(
//                     text: "Qibla Finder\n",
//                     style: TextStyle(
//                       fontSize: 33,
//                       fontWeight: FontWeight.normal,
//                       color: Colors.black,
//                     ),
//                     children: [
//                       TextSpan(
//                           text: "Locate the qibla , wherever you are",
//                           style: TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.black,
//                             fontWeight: FontWeight.normal,
//                           ))
//                     ]),
//               ),
//             ),
//             FutureBuilder(
//               future: _deviceSupport,
//               builder: (_, AsyncSnapshot<bool?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingIndicator();
//                 }
//                 if (snapshot.hasError)
//                   return Center(
//                     child: Text("Error: ${snapshot.error.toString()}"),
//                   );

//                 if (snapshot.data!)
//                   return QiblahCompass();
//                 else
//                   return QiblahMaps();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _QiblahCompassState extends State<QiblahCompass> {
//   final _locationStreamController =
//       StreamController<LocationStatus>.broadcast();
//   get stream => _locationStreamController.stream;

//   @override
//   void initState() {
//     _checkLocationStatus();
//     qibladesign();
//     super.initState();
//   }

//   Widget _title() {
//     return RichText(
//       textAlign: TextAlign.center,
//       text: const TextSpan(
//           text: "Qibla",
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.w700,
//             color: Color(0xff02AE90),
//           ),
//           children: [
//             TextSpan(
//                 text: "Continue with Email",
//                 style: TextStyle(
//                   fontSize: 15.0,
//                   color: Colors.grey,
//                 ))
//           ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         qibladesign(),
//         Container(
//           alignment: Alignment.center,
//           margin: EdgeInsets.only(top: 180),
//           padding: const EdgeInsets.all(8.0),
//           child: StreamBuilder(
//             stream: stream,
//             builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting)
//                 return LoadingIndicator();
//               if (snapshot.data!.enabled == true) {
//                 switch (snapshot.data!.status) {
//                   case LocationPermission.always:
//                   case LocationPermission.whileInUse:
//                     return QiblahCompassWidget();
//                   case LocationPermission.denied:
//                     return LocationErrorWidget(
//                       error: "Location service permission denied",
//                       callback: _checkLocationStatus,
//                     );

//                   case LocationPermission.deniedForever:
//                     return LocationErrorWidget(
//                       error: "Location service Denied Forever !",
//                       callback: _checkLocationStatus,
//                     );
//                   // case GeolocationStatus.unknown:
//                   //   return LocationErrorWidget(
//                   //     error: "Unknown Location service error",
//                   //     callback: _checkLocationStatus,
//                   //   );
//                   default:
//                     return const SizedBox();
//                 }
//               } else {
//                 return LocationErrorWidget(
//                   error: "Please enable Location service",
//                   callback: _checkLocationStatus,
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _checkLocationStatus() async {
//     final locationStatus = await FlutterQiblah.checkLocationStatus();
//     if (locationStatus.enabled &&
//         locationStatus.status == LocationPermission.denied) {
//       await FlutterQiblah.requestPermissions();
//       final s = await FlutterQiblah.checkLocationStatus();
//       _locationStreamController.sink.add(s);
//     } else {
//       _locationStreamController.sink.add(locationStatus);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _locationStreamController.close();
//     FlutterQiblah().dispose();
//   }
// }

// class QiblahCompassWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return LoadingIndicator();

//         final qiblahDirection = snapshot.data!;

//         return Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Transform.rotate(
//               angle: (qiblahDirection.direction * (pi / 180) * -1),
//               child: img(),
//               alignment: Alignment.center,
//             ),
//             Transform.rotate(
//               angle: (qiblahDirection.qiblah * (pi / 180) * -1),
//               alignment: Alignment.center,
//               child: imgg(),
//             ),
//             // Positioned(
//             //   bottom: 8,
//             //   child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
//             // ),
//           ],
//         );
//       },
//     );
//   }
// }

// class img extends StatelessWidget {
//   const img({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: const Image(
//         image: AssetImage("assets/images/dial.png"),
//         fit: BoxFit.contain,
//         height: 230,
//       ),
//     );
//   }
// }

// class imgg extends StatelessWidget {
//   const imgg({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: const Image(
//         image: AssetImage("assets/images/round.png"),
//         fit: BoxFit.contain,
//         height: 600,
//       ),
//     );
//   }
// }
