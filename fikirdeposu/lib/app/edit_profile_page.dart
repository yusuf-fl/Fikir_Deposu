import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String uid;

  EditProfilePage({this.uid});

  static Widget create({String uid}) {
    return EditProfilePage(uid: uid);
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user;
  bool loading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController eMailController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  void _getUserDetails() async {
    print('${widget.uid}');
    var data = await Database.getUserData(widget.uid);
    setState(() {
      user = data;
      this.firstNameController.text = this.user.firstName;
      this.lastNameController.text = this.user.lastName;
      this.eMailController.text = this.user.email;
      this.bioController.text = this.user.bio;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    eMailController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xffC6554A),
        title: Text(
          Language.profile,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.withOpacity(.2),
                        backgroundImage: NetworkImage(user != null
                            ? user.image != null
                                ? user.image
                                : "https://w7.pngwing.com/pngs/104/119/png-transparent-orange-and-white-logo-computer-icons-icon-design-person-person-miscellaneous-logo-silhouette.png"
                            : "https://w7.pngwing.com/pngs/104/119/png-transparent-orange-and-white-logo-computer-icons-icon-design-person-person-miscellaneous-logo-silhouette.png"),
                      ),
                      Positioned(
                        right: -10,
                        top: -15,
                        child: IconButton(
                          icon: Icon(
                            MdiIcons.cameraPlus,
                            color: Color(0xff607D8B),
                          ),
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();

                            var tempImage = await picker.getImage(
                                source: ImageSource.gallery);

                            final Reference firebaseStorageRef =
                                FirebaseStorage.instance.ref().child(
                                    'user_images/${basename(tempImage.path)}');
                            final UploadTask task = firebaseStorageRef
                                .putFile(File(tempImage.path));
                            var link = await task
                                .then((value) => value.ref.getDownloadURL());
                            this.user.image = link.toString();
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(this.widget.uid)
                                .update(user.toMap());
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: firstNameController,
                    cursorColor: Color(0xffC6554A),
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffC6554A),
                    ),
                    decoration: InputDecoration(
                      labelText: Language.name,
                      labelStyle: TextStyle(
                        color: Color(0xffC6554A),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameController,
                    cursorColor: Color(0xffC6554A),
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffC6554A),
                    ),
                    decoration: InputDecoration(
                      labelText: Language.surname,
                      labelStyle: TextStyle(color: Color(0xffC6554A)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: eMailController,
                    cursorColor: Color(0xffC6554A),
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffC6554A),
                    ),
                    decoration: InputDecoration(
                      labelText: Language.email,
                      labelStyle: TextStyle(
                        color: Color(0xffC6554A),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: bioController,
                    cursorColor: Color(0xffC6554A),
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffC6554A),
                    ),
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: Language.bio,
                      labelStyle: TextStyle(
                        color: Color(0xffC6554A),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffC6554A),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  _postButton(context),
                  SizedBox(height: 15),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _postButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xffC6554A),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          String newFirstName = this.firstNameController.text;
          String newLastName = this.lastNameController.text;
          String newEMail = this.eMailController.text;
          String newBio = this.bioController.text;

          if (newFirstName.length > 0 &&
              newLastName.length > 0 &&
              newEMail.length > 0) {
            user.firstName = newFirstName;
            user.lastName = newLastName;
            user.email = newEMail;
            user.bio = newBio;
            FirebaseFirestore.instance
                .collection("users")
                .doc(this.widget.uid)
                .update(user.toMap());
          }
        },
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Text(
                  Language.profile,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
