import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shabach/components/constants.dart';
import 'package:shabach/welcome_screen/welcome_screen.dart';

import '../models/UIHelper.dart';
import '../models/UserModel.dart';
import '../pages/complete_profile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else if(password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch", "The passwords you entered do not match!");
    }
    else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, "An error occurred", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        if (kDebugMode) {
          print("New User Created!");
        }
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
              }
          ),
        );
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  const Icon(LineIcons.undo, color: kPrimaryColor,size: 30,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const WelcomeScreen();
                },
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Register", style: GoogleFonts.comfortaa(
                        color: kPrimaryColor2,
                        fontSize: 35,

                    ),),

                    const SizedBox(height: 20,),

                    TextFormField(

                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,

                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(

                          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Email",
                          hintStyle:  GoogleFonts.poppins( color: Colors.grey),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                          ),
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(0),
                          ),
                        )),

                    const SizedBox(height: 25,),
                    TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,

                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(

                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Password",
                            hintStyle:  GoogleFonts.poppins( color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryColor2, width: 15.0),
                              borderRadius: BorderRadius.circular(0),)
                        )),

                    const SizedBox(height: 25,),

                    TextFormField(
                        autofocus: false,
                        controller: cPasswordController,
                        obscureText: true,
                        validator: (value) {
                          RegExp regex =  RegExp(r'^.{6,}$');

                          if (!regex.hasMatch(value!)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },

                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(

                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Confirm Password",
                            hintStyle:  GoogleFonts.poppins( color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor2, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryColor2, width: 15.0),
                              borderRadius: BorderRadius.circular(0),)
                        )),

                    const SizedBox(height: 20,),



                  ],

                ),
                SizedBox(

                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor2,
                    child: MaterialButton(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () {
                          checkValues();
                        },
                        child:  Text(
                          "Next".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, color: altPrimaryColor, fontWeight: FontWeight.bold),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}