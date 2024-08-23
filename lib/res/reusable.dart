import 'package:flutter/material.dart';


Widget reusablebordercontainer(BuildContext context, double width, double height, double borderWidth, Widget child,) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(width: borderWidth,color:  Color.fromARGB(255, 2, 129, 148)),
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.all(6),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
  );
}


// Container reusablebordercontainer(BuildContext context, double borderwidth,double width, double circleraduis,Widget widget){
//   return
//  Container(
//                          width: MediaQuery.of(context).size.width*width,
//                        margin: EdgeInsets.only(top: 15),
//                       // padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(circleraduis),
//                      border: Border.all(
//                      color: Colors.cyan,
//                      width: borderwidth,
//                         ),
//                        ),
//                        child: Center(child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                          children: [
//                            widget,
//                          ],
//                        )),
//                        );
//                        }
InkWell reusablecontainervideo(BuildContext context, double width, String title,Function ontap){
  return InkWell(
    onTap: ()
    {
      
ontap();
     
      
    },
    child: Container(
      width: MediaQuery.of(context).size.width*width,
          margin: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                   begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.cyan,
                  Color(0xff00838f),
                ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Text(title,style: TextStyle(color: Colors.white,fontFamily: 'Alvi',fontSize: 25),),
              Icon(Icons.play_circle, color: Colors.white, size: 40,),
            ],
          ),
        ),
  );
}

InkWell reusableocontaineraudio(BuildContext context, double width, String title,Function ontap){
  return InkWell(
    onTap: ()
    {
      
ontap();
    //  keytool -genkey -v -keystore f:\upload-keystore1.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias uploadkeystore1
        // keytool -genkey -v -keystore d:\upload-keystore2.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias uploadkeystore2
    },
    child: Container(
      width: MediaQuery.of(context).size.width*width,
          margin: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                   end: Alignment.topLeft,
                begin: Alignment.bottomRight,
                colors: <Color>[
                  Colors.cyan,
                  Color(0xff00838f),
                ])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Text(title,style: TextStyle(color: Colors.white,fontFamily: 'Alvi',fontSize: 25),),
              SizedBox(height: MediaQuery.of(context).size.height*0.06,child: 
              Image.asset("assets/images/audiobtn.png")              // Icon(Icons.volume_up, color: Colors.white, size: 45,),
          )],
          ),
        ),
  );
}