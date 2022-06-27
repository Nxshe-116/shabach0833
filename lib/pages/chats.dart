
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shabach/pages/main_page.dart';

import '../components/constants.dart';
import '../models/ChatRoomModel.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import 'chat_room.dart';
import 'chats search/chatsearch.dart';

class Chats extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Chats({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

title:Text('Chats', style: GoogleFonts.roboto(fontSize:30, color: kPrimaryColor, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  const Icon(LineIcons.undo, color: kPrimaryColor,size: 30,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
              }),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active) {
                if(snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participants = chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);

                      return Container(
                        decoration:  const BoxDecoration(
                          border: Border(
                            /*  top: BorderSide(
                              color: kPrimaryColor,
                              width: 0.4,
                            ),*/
                            bottom: BorderSide(
                              color: kPrimaryColor,
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: FutureBuilder(
                          future: FirebaseHelper.getUserModelById(participantKeys[0]),
                          builder: (context, userData) {
                            if(userData.connectionState == ConnectionState.done) {
                              if(userData.data != null) {
                                UserModel targetUser = userData.data as UserModel;

                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                          chatroom: chatRoomModel,
                                          firebaseUser: widget.firebaseUser,
                                          userModel: widget.userModel,
                                          targetUser: targetUser,
                                        );
                                      }),
                                    );
                                  },
                                  leading: CircleAvatar(

                                    backgroundColor: mainPrimaryColor,
                                    backgroundImage: NetworkImage(targetUser.profilepic.toString()),

                                  ),
                                  title: Text(targetUser.fullname.toString(), style: GoogleFonts.poppins( color: kPrimaryColor,fontSize: 20)),
                                  subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString(), style: GoogleFonts.poppins( color: kPrimaryColor2, fontSize: 15)) :  Text("Say hi to your new friend!", style: GoogleFonts.poppins( color: kPrimaryColor2, fontSize: 15)),
                                );
                              }
                              else {
                                return Container();
                              }
                            }
                            else {
                              return Container();
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                else if(snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong "),
                  );
                }
                else {
                  return const Center(
                    child: Text("No Chats"),
                  );
                }
              }
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainPrimaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
            }));
          },
    child: const Icon(LineIcons.search, color: altPrimaryColor),
    ),
    );

  }
}