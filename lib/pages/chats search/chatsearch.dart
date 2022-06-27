import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../../components/constants.dart';
import '../../main.dart';
import '../../models/ChatRoomModel.dart';
import '../../models/UserModel.dart';
import '../chat_room.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();

    if(snapshot.docs.isNotEmpty) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    }
    else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
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
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Column(
            children: [

              TextFormField(
                  autofocus: false,
                  controller: searchController,
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
                    suffixIcon:const Icon(LineIcons.search, color: mainPrimaryColor,),

                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Search using Email",
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

              const SizedBox(height: 20,),
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
                      child:  Text(
                        "Search".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, color: altPrimaryColor, fontWeight: FontWeight.bold),
                      )),
                ),
              ),

              const SizedBox(height: 20,),

              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").where("email", isEqualTo: searchController.text).where("email", isNotEqualTo: widget.userModel.email).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      if(snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        if(dataSnapshot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);

                              if(chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoomPage(
                                        targetUser: searchedUser,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                        chatroom: chatroomModel,
                                      );
                                    }
                                ));
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(searchedUser.profilepic!),
                              backgroundColor: mainPrimaryColor,
                            ),
                            title: Text(searchedUser.fullname!),
                            subtitle: Text(searchedUser.email!),
                            trailing:  const Icon(LineIcons.angleRight),
                          );
                        }
                        else {
                          return const Text("No results found!");
                        }

                      }
                      else if(snapshot.hasError) {
                        return const Text("An error occurred!");
                      }
                      else {
                        return const Text("No results found!");
                      }
                    }
                    else {
                      return const CircularProgressIndicator();
                    }
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}