import 'dart:math';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shabach/log_in/log_in.dart';
import 'package:shabach/sign_up/sign_up.dart';

import '../components/constants.dart';




class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,

           children: [

             ClipPath(
               clipper: CustomClipPath(),

                 child: Image.asset("assets/background.png",
                   fit: BoxFit.cover,
                ),

             ),


             Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children:  [
                 SizedBox(
                   width: size.width*0.45,
                   height: 60,
                   child: TextButton(
                       onPressed: () {
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                             builder: (context) {
                               return const LoginPage();
                             },
                           ),
                         );
                       },
                       child: Text(
                           "Log In".toUpperCase(),
                           style: GoogleFonts.poppins(color: kPrimaryColor2,fontSize: 20, fontWeight: FontWeight.bold)),
                       style: ButtonStyle(
                           padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                           foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColor2),
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                               RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(8),
                                   side: const BorderSide(color: kPrimaryColor2,width: 2)

                               )
                           )
                       ),

                   ),
                 ),
                 const SizedBox(width: 10),
                 SizedBox(
                   width: size.width*0.45,
                   height: 60,
                   child: TextButton(
                       child: Text(
                           "Register".toUpperCase(),
                           style:GoogleFonts.poppins(color:Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),

                       style: ButtonStyle(
                           backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor2),
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(8),
                                   side: const BorderSide(color: kPrimaryColor2)
                               )
                           )
                       ),
                     onPressed: () {
                       Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                           builder: (context) {
                             return const SignUpPage();
                           },
                         ),
                       );
                     },

                   ),
                 )
               ],
             )
           ],
         )
        );
  }

}
class CustomClipPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height= size.height*0.85;

    final path = Path();

   //Point<double> topLeft = const Point(0, 0);
    Point<double> topRight =  Point(width, 0);
    Point<double> anchor1 =  Point(width/4, height-90);
    Point<double> anchor2 =  Point(width*0.75, height+50);
    Point<double> anchor3 =  Point(width, height);
    Point<double> bottomLeft =  Point(0, height);
    Point<double> bottomRight =  Point(width, height);
    Point<double> bottomMid =  Point(width/2, height-20);


  path.lineTo(bottomLeft.x, bottomLeft.y);
  path.quadraticBezierTo(anchor1.x, anchor1.y, bottomMid.x, bottomMid.y);
  path.cubicTo(anchor2.x, anchor2.y, anchor3.x, anchor3.y, bottomRight.x, bottomRight.y);
  path.lineTo(topRight.x,topRight.y);
   path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }

}
