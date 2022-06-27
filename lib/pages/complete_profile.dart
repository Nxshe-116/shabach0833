import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import '../components/constants.dart';
import '../models/UIHelper.dart';
import '../models/UserModel.dart';

import 'main_page.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source) ;

    if(pickedFile != null) {
      cropImage(pickedFile);
    }
    else {
      if (kDebugMode) {
        print('No image selected.');
      }
      return;
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = (await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
            ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              cropFrameColor: mainPrimaryColor,
              toolbarColor: mainPrimaryColor,

              backgroundColor: altPrimaryColor,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: altPrimaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20
    )) as File?;

    // ignore: unnecessary_null_comparison
    if(croppedImage != null) {
      setState(() {
        imageFile = croppedImage ;
      });
    }
    else {
      if (kDebugMode) {
        print('Still no image selected.');
      }
      return;
    }
  }


  void showPhotoOptions() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Upload Profile Picture",),
        titleTextStyle: GoogleFonts.poppins( color: kPrimaryColor,fontSize:18) ,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: const Icon(LineIcons.images),
              title:  Text("Select from Gallery", style: GoogleFonts.poppins( color: kPrimaryColor,fontSize:18),),
            ),

            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: const Icon(LineIcons.camera),
              title:  Text("Take a photo", style: GoogleFonts.poppins( color: kPrimaryColor,fontSize:18),),),


          ],
        ),
      );
    });
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();

    if(fullname == "") {
      if (kDebugMode) {
        print("Please fill all the fields");
      }
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else {
      log("Uploading data..");
      uploadData();
    }
  }

  void uploadData() async {


    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;


    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
      log("Data uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
        }),
      );
    });
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

          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15
          ),
          child: ListView(
            children: [

              const SizedBox(height: 20,),

              TextButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  backgroundColor: mainPrimaryColor,
                  radius: 60,
                  backgroundImage: (imageFile != null) ? FileImage(imageFile!) : null,
                  child:  const Icon(LineIcons.user, size: 60,color: altPrimaryColor,),
                ),
              ),

              const SizedBox(height: 20,),

          TextFormField(
              autofocus: false,
              controller: fullNameController,


              textInputAction: TextInputAction.done,
              decoration: InputDecoration(

                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Username",
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
    );
  }
}