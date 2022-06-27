import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shabach/welcome_screen/welcome_screen.dart';

import '../components/constants.dart';

import '../models/UserModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  backgroundColor: mainPrimaryColor,
                  radius: 60,
                  child: Icon(
                    LineIcons.user,
                    size: 60,
                    color: altPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Center(
                child: SizedBox(
                  width: size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nashe",
                          style: GoogleFonts.comfortaa(
                              color: kPrimaryColor, fontSize: 36)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
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
                    setState(() {});
                  },
                  child: Text(
                    "Manage Account Settings".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        color: altPrimaryColor,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Column(
            children: [
              Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(

                    onTap: () {},
                    subtitle: Text(
                      "Toggle Dark Mode, Delete Chats",
                      style: GoogleFonts.poppins(color: kPrimaryColor2),
                    ),
                    contentPadding:
                        const EdgeInsets.only(right: 30, left: 36),
                    title: Text(
                      "General Settings".toUpperCase(),
                      style: GoogleFonts.poppins(color: kPrimaryColor, fontWeight: FontWeight.w700),
                    ),
                    leading: const Icon(
                      LineIcons.cog,
                      color: kPrimaryColor2,
                      size: 30,
                    ),
                  )),
              Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(

                    onTap: () {},
                    subtitle: Text(
                      "Who we are, Contact Us",
                      style: GoogleFonts.poppins(color: kPrimaryColor2),
                    ),
                    contentPadding:
                    const EdgeInsets.only(right: 30, left: 36),
                    title: Text(
                      "about Shabach".toUpperCase(),
                      style: GoogleFonts.poppins(color: kPrimaryColor, fontWeight: FontWeight.w700),
                    ),
                    leading: const Icon(
                      LineIcons.infoCircle,
                      color: kPrimaryColor2,
                      size: 30,
                    ),
                  )),

              SizedBox(
                width: size.width,
                child: Card(

                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(

                      onTap:  () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  return const WelcomeScreen();
                                }
                            ),
                          );


                      },
                      subtitle: Text(
                        "Sign out of your Account",
                        style: GoogleFonts.poppins(color: kPrimaryColor2),
                      ),
                      contentPadding:
                      const EdgeInsets.only(right: 30, left: 36),
                      title: Text(
                        "Log out".toUpperCase(),
                        style: GoogleFonts.poppins(color: kPrimaryColor, fontWeight: FontWeight.w700),
                      ),
                      leading: const Icon(
                        LineIcons.alternateSignOut,
                        color: kPrimaryColor2,
                        size: 30,
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
