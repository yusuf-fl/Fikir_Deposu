import 'dart:async';
import 'dart:io';

import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/signin/fv_login.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class fv_CreateNewPostPage extends StatefulWidget {
  final User user;

  fv_CreateNewPostPage({this.user});

  static Widget create({User user}) {
    return fv_CreateNewPostPage();
  }

  @override
  _fv_CreateNewPostPageState createState() => _fv_CreateNewPostPageState();
}

class _fv_CreateNewPostPageState extends State<fv_CreateNewPostPage> {
  Map<String, String> _chosenValue = Constants.categories[0];
  bool loading = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _keywordsController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  PickedFile _selectedImage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  _uploadImage() async {
    ImagePicker picker = ImagePicker();
    // ignore: deprecated_member_use
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = tempImage;
    });
  }

  Future<void> _post(BuildContext context, User user) async {
    try {
      setState(() {
        loading = true;
      });

      String title = _titleController.text;
      String content = _contentController.text;
      String keywords = _keywordsController.text;
      String price = _priceController.text;
      Map<String, String> type = _chosenValue;
      if (title == null ||
          content == null ||
          keywords == null ||
          _selectedImage == null ||
          price == null) {
        throw PlatformException(
          code: 'Field empty error',
          details: 'None of the field can be empty',
        );
      } else {
        final Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('post_images/${basename(_selectedImage.path)}');
        final UploadTask task =
            firebaseStorageRef.putFile(File(_selectedImage.path));
        var link = await task.then((value) => value.ref.getDownloadURL());
        String datetime = DateTime.now().toIso8601String();
        List<String> realKeywords = [];
        if (keywords.contains(",")) {
          realKeywords = keywords.split(",");
        } else {
          realKeywords.add(keywords);
        }

        await Database.createPost(
          user.uid,
          Post(
            userUid: user.uid,
            title: title,
            content: content,
            type: type.keys.first,
            keywords: realKeywords,
            datetime: datetime,
            image: link,
            price: double.parse(price),
            favorites: [],
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
          ),
        );
      }
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: backgroundColor,
            title: new Text("${e.code}"),
            content: new Text("${e.details}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
          stream: Auth.onAuthStateChanged,
          builder: (context, snapshot) {
            User firstUser = snapshot.data;
            if (firstUser == null) {
              return fv_Login.create();
            }

            return FutureBuilder(
                future: Database.getUserData(firstUser.uid),
                builder: (context, data) {
                  if (!data.hasData) {
                    return Container();
                  }
                  User user = data.data;
                  return Stack(
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
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  Language.idea6,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontFamily: "Cursive",
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                      0xffC6554A,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                  // or Alignment.topLeft
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _titleTextField(),
                              SizedBox(height: 15),
                              _keywordsTextField(),
                              SizedBox(height: 15),
                              _priceTextField(),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Color(0xffC6554A),
                                      style: BorderStyle.solid,
                                      width: 2),
                                ),
                                child: DropdownButton<Map<String, String>>(
                                  dropdownColor: Colors.white,
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    color: Color(0xffC6554A),
                                  ),
                                  value: _chosenValue,
                                  isExpanded: true,
                                  underline: Container(),
                                  items: Constants.categories.map<
                                      DropdownMenuItem<Map<String, String>>>(
                                    (Map<String, String> value) {
                                      return DropdownMenuItem<
                                          Map<String, String>>(
                                        value: value,
                                        child: Text(
                                          value.keys.first,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffC6554A),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (Map<String, String> value) {
                                    setState(() {
                                      _chosenValue = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              _addImageButton(),
                              SizedBox(height: 15),
                              _contentTextField(),
                              SizedBox(height: 15),
                              _postButton(context, user),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
          }),
    );
  }

  Widget _addImageButton() {
    return SizedBox(
      height: 50,
      child: FlatButton(
        onPressed: _uploadImage,
        color: Colors.white.withOpacity(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Color(0xffC6554A),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: <Widget>[
            _selectedImage != null
                ? Text(
                    '${basename(_selectedImage.path)}',
                    style: TextStyle(color: Colors.blueGrey),
                  )
                : Text(
                    Language.idea3,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffC6554A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _postButton(BuildContext context, User user) {
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
        onPressed: () => _post(context, user),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Text(
                  Language.idea5,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _contentTextField() {
    return TextFormField(
      controller: _contentController,
      cursorColor: Color(0xffC6554A),
      style: TextStyle(
          fontSize: 18, color: Color(0xffC6554A), fontWeight: FontWeight.bold),
      autocorrect: true,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: Language.idea4,
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
    );
  }

  Widget _titleTextField() {
    return TextFormField(
      controller: _titleController,
      cursorColor: Color(0xffC6554A),
      style: TextStyle(
          fontSize: 18, color: Color(0xffC6554A), fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: Language.idea,
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
    );
  }

  Widget _keywordsTextField() {
    return TextFormField(
      controller: _keywordsController,
      cursorColor: Color(0xffC6554A),
      style: TextStyle(
          fontSize: 18, color: Color(0xffC6554A), fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: Language.idea1,
        hintText: "Virgül(,) ile ayırın",
        hintStyle:
            TextStyle(color: Color(0xffC6554A), fontWeight: FontWeight.w400),
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
    );
  }

  Widget _priceTextField() {
    return TextFormField(
      controller: _priceController,
      cursorColor: Color(0xffC6554A),
      style: TextStyle(
          fontSize: 18, color: Color(0xffC6554A), fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: Language.idea3,
        hintStyle:
            TextStyle(color: Color(0xffC6554A), fontWeight: FontWeight.w400),
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
    );
  }
}
