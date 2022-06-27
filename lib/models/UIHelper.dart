import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shabach/components/constants.dart';

class UIHelper {

  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
             Image.asset(
          "assets/loading.gif",
          height: 100,
          width: 100,
        ),

            const SizedBox(height: 30,),

            Text(title),

          ],
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      }
    );
  }


  static void showAlertDialog(BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:  Text("Ok".toUpperCase(), style: GoogleFonts.poppins(color: kPrimaryColor2,),),
        ),
      ],
    );

    showDialog(context: context, builder: (context) {
      return alertDialog;
    });
  }

}