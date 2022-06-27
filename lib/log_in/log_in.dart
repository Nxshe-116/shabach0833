
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shabach/components/constants.dart';

import '../models/UIHelper.dart';
import '../models/UserModel.dart';
import '../pages/main_page.dart';
import '../sign_up/sign_up.dart';
import '../welcome_screen/welcome_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void  checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging In..");

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      // Close the loading dialog
      Navigator.pop(context);

      // Show Alert Dialog
      UIHelper.showAlertDialog(context, "An error occurred", "Incorrect Username or Password");
    }

    if(credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      if (kDebugMode) {
        print("Log In Successful!");
      }
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return HomePage(userModel: userModel, firebaseUser: credential!.user!);
            }
        ),
      );
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Log In", style: GoogleFonts.comfortaa(
                      color: kPrimaryColor2,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.start,),

                    const SizedBox(height: 20,),

                    TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
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
                              borderSide: const BorderSide(color: kPrimaryColor2, width: 15.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        )),

                    const SizedBox(height: 25,),

                    TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          RegExp regex =  RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },

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
                          "Login".toUpperCase(),
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

           Text("Don't have an account?", style: GoogleFonts.poppins(
              fontSize: 16
          ),),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return const SignUpPage();
                    }
                ),
              );
            },
            child:  Text("Sign Up", style:  GoogleFonts.poppins(
                fontSize: 16,
              color: kPrimaryColor2
            ),),
          ),

        ],
      ),
    );
  }
}