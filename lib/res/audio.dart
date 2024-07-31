
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// import '../main.dart';

// class Audiotesting extends StatelessWidget {
//   Audiotesting({required this.audiolink});
//   String audiolink;
 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
    
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Audioplayertesting(audiolink:audiolink),

//       ),
//     );
//   }
// }

// class AppRoutes {
//   static String home = "/";
// }

// Duration _position = Duration(seconds: 0);
// var _progress = 0.0;

// class Audioplayertesting extends StatefulWidget {
//    Audioplayertesting({required this.audiolink});
//   String audiolink;

//   @override
//   State<Audioplayertesting> createState() => _AudioplayertestingState(audiolink: audiolink);
// }

// class _AudioplayertestingState extends State<Audioplayertesting> {
//  _AudioplayertestingState({required this.audiolink});
//  String audiolink;
//   Timer? timer2;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(color: Colors.cyan,),
//         backgroundColor: Color.fromARGB(199, 52, 52, 52),
//         // title: const Text('Tubeloid'),
//         // centerTitle: true,
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {},
//         //     icon: const Icon(Icons.menu_outlined),
//         //   )
//         // ],
//       ),
//       backgroundColor: Color.fromARGB(199, 52, 52, 52),
      
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // if(player!.setUrl("https://quranarbi.turk.pk/"+"${audiolink}"))
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: LinearProgressIndicator(
//               backgroundColor: Colors.cyan,
//               color: Colors.cyanAccent,
//               // valueColor: Colors.yellow,
//               value: _progress,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextButton(
//                   onPressed: () {
//                     player!.setUrl("https://quranarbi.turk.pk/"+"${audiolink}")
//                     // setAsset('assets/mb3.mp3')
//                     .then((value) {
//                       return {
//                         _position = value!,
//                         player!.playerStateStream.listen((state) {
//                           if(state.processingState==ProcessingState.buffering){
//                             CircularProgressIndicator();
//                           }else{
//                             if (state.playing) {
//                             setState(() {
//                               _progress = .1;
//                             });
//                           } else
//                             switch (state.processingState) {
//                               case ProcessingState.idle:
//                                 break;
//                               case ProcessingState.loading:
//                                 break;
//                               case ProcessingState.buffering:
//                                 break;
//                               case ProcessingState.ready:
//                                 setState(() {
//                                   _progress = 0;
//                                   timer2!.cancel();
//                                 });
//                                 break;
//                               case ProcessingState.completed:
//                                 setState(() {
//                                   _progress = 1;
//                                 });
//                                 break;
//                             }
//                           }
                          
//                         }),
//                         player!.play(),
//                         timer2 =
//                             Timer.periodic(new Duration(seconds: 1), (timer) {
//                           setState(() {
//                             _progress += .05;
//                           });
//                         })
//                       };
//                     });
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width*0.45,
//                     // height:MediaQuery.of(context).size.height*.06,
//                     decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               gradient: LinearGradient(
//                    begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: <Color>[
//                   Colors.cyan,
//                   Color(0xff00838f),
//                 ])),child: Center(child: ListTile(leading: Icon(Icons.play_arrow,color: Colors.white,size: 30,),title: Text("Play",style: TextStyle(fontSize: 25,color: Colors.white),)))))
//                   // Icon(
//                     // _progress > 0 ? Icons.pause : Icons.play_arrow,
//                     // size: 45,
//                     // color: Colors.cyan,


//                   // )),
              
//               // IconButton(
//               //     onPressed: () {
//               //       player!.stop();
                    
//               //       // timer2!.cancel();
//               //     },
    
                  
//               //     icon: Icon(
//               //       Icons.replay_outlined,
//               //       size: 45,
//               //       color: Colors.cyan,
                    
//               //     )),
                 
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }