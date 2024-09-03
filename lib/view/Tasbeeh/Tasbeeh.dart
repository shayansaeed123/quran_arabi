import 'package:flutter/material.dart';
// import 'package:qurani_arabi_flutter/view/Home/header.dart';
// import 'package:qurani_arabi_flutter/view/Home/menubar.dart';

import '../../function/functions.dart';
import '../../model/images_get.dart';
import '../Home/menubar.dart';
import '../Home/networkheader.dart';
import 'package:quran_arabi/database/mysharedpreferece.dart';


class Tasbeeh extends StatefulWidget {
  Tasbeeh({required this.imagepath});
  var imagepath;
  @override
  State<Tasbeeh> createState() => _TasbeehState(
    imagepath:imagepath
    );
}

class _TasbeehState extends State<Tasbeeh> {
  _TasbeehState({
    required this.imagepath
    });
  var imagepath;
  var count = 0;

  void increment() {
    setState(() {
      count = count + 1;
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 30,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                //     FutureBuilder<List<imageget>>(
                // future: imagedata(),
                // builder: (context, snapshot) {
                //   if (snapshot.hasData) {
                //     if(snapshot.connectionState==ConnectionState.done){
                //       return  ListView.builder(
                //           shrinkWrap: true,
                //           scrollDirection: Axis.vertical,
                //           physics: ScrollPhysics(),
                //                     itemCount: 
                //                     snapshot.data!.length,
                //                     itemBuilder: (BuildContext context, int index) { 
                //                     var imageurl=snapshot.data![index].featured_image;
                //                     var linkapi="https://quranarbi.turk.pk/";
                //                     return Column(children: [if(snapshot.data![index].id==5)...{
                //                       Headernetwork.with_text_ur(linkapi+imageurl, '',
                //         Colors.black, false, 'تسبیح', true),
                //           //             Headernetwork(linkapi+imageurl, '', Colors.black,
                //           // true)
                //                     }],); 
                //                     });  
                  
                //     }}
                //   return SizedBox(
                //     height: MediaQuery.of(context).size.height,
                //     width: MediaQuery.of(context).size.width,
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         CircularProgressIndicator(),
                //       ],
                //     ),
                //   );
                // },
                //         ),
                  Headernetwork.with_text_ur(imagepath, '',
                        Colors.white, false, 'تسبیح', true),
                    TopMenu(false, false, false, false, false,false),
                     Container(
                        height: MediaQuery.of(context).size.height*0.40,
                    width: MediaQuery.of(context).size.width*0.97,
                        child: Card(
                          margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.solid,
                              width: 2,
                              color: Colors.cyan,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                         
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
                            children: [
                              Text(
                                count.toString().padLeft(2, '0'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50, color: Colors.cyan),
                                textDirection: TextDirection.rtl,
                              ),
                            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width*0.32,
                                    decoration: BoxDecoration(color: Colors.cyan,borderRadius: BorderRadius.circular(40)),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          reset();
                                        },
                                        child: Text(
                                          '↻ Reset',
                                        textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.white,fontWeight: FontWeight.bold),
                                          
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width*0.30,
                                    decoration: BoxDecoration(color: Colors.cyan,borderRadius: BorderRadius.circular(40)),
                                   
                                    child: Center(
                                      child: InkWell(onTap: () {
                                      increment();},child:  Text(
                                      '+ Count',
                                      style: TextStyle(
                                      fontSize: 22, color: Colors.white,fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                    ),
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
          ],
        ),
      ),
    );
  }
}
