import 'package:flutter/material.dart';

Widget reusableArabicIcon(double? size, IconData? icon) {
  return IconButton(
    onPressed: () {
      print("Pressed $icon");
    },
    icon: Icon(
      icon,
      size: size,
    ),
  );
}
Widget imagereusableArabicIcon({
  double? size,
  required String imageUrl,
  required VoidCallback onTapCallback,
}) {
  return GestureDetector(
    onTap: onTapCallback,
    child: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all( color:  Color.fromARGB(255, 2, 129, 148), width: 2), // Circular black border
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: size, 
            height: size,
            fit: BoxFit.cover, 
          ),
        ),
      ),
    ),
  );
}

reusableArabicList(BuildContext context, double width) {
  return
   Container(
    margin: EdgeInsets.all(5),
    width: MediaQuery.sizeOf(context).width * width,
    decoration: BoxDecoration(
        border: Border.all(width: 2), borderRadius: BorderRadius.circular(20)),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2, color: Colors.black)),
          child: Column(
            children: [
              reusableArabicIcon(30, Icons.image),
              SizedBox(
                height: 3,
              ),
              IconButton(
                onPressed: () {
                  print("Speaking");
                },
                icon: Icon(
                  Icons.volume_up,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "شُروع اَللہ کے پاک نام سے جو بڑا مہر بان نہايت رحم والا ہے ۔",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget arabicSeparator(BuildContext context) {
  return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        margin: EdgeInsets.all(5),
        height: 5,
        width: MediaQuery.sizeOf(context).width * 0.9,
        decoration: BoxDecoration(color: Colors.black),
      ));
}