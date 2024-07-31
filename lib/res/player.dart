// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// PlayAudio(var url, BuildContext context) async {
//   if (url == 'null' || url == '') {
//     SnackBar snackdemo = SnackBar(
//       content: Row(
//         children: [
//           Expanded(child: Text('Audio not found')),
//           Icon(
//             Icons.volume_off,
//             color: Colors.white,
//           ),
//         ],
//       ),
//       backgroundColor: Colors.blue,
//       elevation: 10,
//       behavior: SnackBarBehavior.floating,
//       margin: EdgeInsets.all(5),
//       duration: Duration(milliseconds: 800),
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackdemo);
//   } else if (url == 'non') {
//   } else {
//     final player = AudioPlayer();
//     await player.setUrl('https://quranarbi.turk.pk/' + url);
//     // await player.setUrl('https://quranarbi.turk.pk/public/audio' + url);
//     player.play();
//   }
// }

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

PlayAudio(var url, BuildContext context) async {
  if (url == 'null' || url == '') {
    SnackBar snackdemo = SnackBar(
      content: Row(
        children: [
          Expanded(child: Text('Audio not found')),
          Icon(
            Icons.volume_off,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
      duration: Duration(milliseconds: 800),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
  } else if (url == 'non') {
  } else {
    final player = AudioPlayer();
    // await player.setUrl("https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3");
    
    await player.setUrl(url);
    // await player.setUrl('https://quranarbi.turk.pk/public/audio' + url);
    await player.play(); // Await the player.play() method
  }
}
