import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shabach/log_in/settings.dart';
import 'package:shabach/pages/chats.dart';
import 'package:shabach/pages/search.dart';
import '../components/constants.dart';
import '../models/UserModel.dart';


import 'home.dart';


class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
   List<Widget> screens = [
     const Home(),
     const SearchPage(),
     const Text("Journal"),
     const Center(child: CircularProgressIndicator()),
     const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: screens[currentIndex],

        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: kPrimaryColor2,

                      gap: 8,
                      activeColor: kPrimaryColor,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: Colors.white,
                      color: Colors.blueGrey,
                      tabs:   [
                        const GButton(
                          icon: LineIcons.home,
                        ),
                        const GButton(
                          icon: LineIcons.search,

                        ),
                        const GButton(
                          icon: LineIcons.book,
                          iconActiveColor: altPrimaryColor,
                          backgroundColor: mainPrimaryColor,


                        ),
                        GButton(
                          icon: LineIcons.alternateCommentAlt,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Chats(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
                              }),
                            );
                          },

                        ),
                        const GButton(
                          icon: LineIcons.user,

                        ),

                      ],
                      selectedIndex: currentIndex,
                      onTabChange: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    )
                )
            )
        )

    );
  }
  }