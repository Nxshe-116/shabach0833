
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shabach/pages/main_page.dart';
import 'package:shabach/welcome_screen/welcome_screen.dart';
import 'package:uuid/uuid.dart';

import 'components/constants.dart';
import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';




var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null) {
    // Logged In
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null) {
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
    else {
      runApp(const MyApp());
    }
  }
  else {
    // Not logged in
    runApp(const MyApp());
  }
}


// Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 10),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(children: [
          const SizedBox(height: 280,),
          Image.asset(
            "assets/logos/logo.png",
            width: size.width * 0.9,
          ),
          const SizedBox(height: 180,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Anything is possible when you have the right people there to support you.",
                    style: GoogleFonts.poppins(
                        color: kPrimaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w200)),
                Text("Misty Copeland",
                    style: GoogleFonts.poppins(
                          fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const SizedBox(height: 35,),
          Positioned(
            bottom: 0,
            child: Image.asset(
              "assets/loading.gif",
              height: 100,
              width: 100,
            ),
          )
        ]),
      ),
    );
  }
}



// Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}