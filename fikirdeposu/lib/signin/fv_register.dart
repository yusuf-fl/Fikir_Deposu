import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/signin/fv_login.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:blog_app/widgets/customized_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class fv_Register extends StatefulWidget {
  static Widget create() {
    return fv_Register();
  }

  @override
  _fv_RegisterState createState() => _fv_RegisterState();
}

class _fv_RegisterState extends State<fv_Register> {
  bool loading = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telController.dispose();
    _bioController.dispose();
  }

  Future<void> googleSignIn() async {
    String tel = _telController.text;
    String bio = _bioController.text;
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount account = await _googleSignIn.signIn();

    if (account != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      Auth.createUserWithGoogle(tel, bio, credential, account);
    }
  }

  Future<void> _submit() async {
    try {
      setState(() {
        loading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String tel = _telController.text;
      String bio = _bioController.text;
      if (firstName.isEmpty || lastName.isEmpty) {
        throw PlatformException(
            code: 'Field empty error',
            details: 'First Name and Last Name Cannot be empty');
      } else {
        await Auth.createUserWithEmailAndPassword(
            email, password, firstName, lastName, tel, bio);
        Navigator.pop(context);
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
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'images/acik_logo.png',
                  height: 200,
                  width: MediaQuery.of(context).size.width - 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomizedWidget(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: TextField(
                                controller: _firstNameController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    labelText: Language.name,
                                    hintText: 'Ali'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: CustomizedWidget(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: TextField(
                                controller: _lastNameController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    labelText: Language.surname,
                                    hintText: 'Yıldız'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              labelText: Language.email,
                              hintText: 'test@abc.com'),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          controller: _passwordController,
                          cursorColor: Colors.black,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: Language.password,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          controller: _telController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: Language.tel,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          controller: _bioController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: Language.tel,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: RaisedButton(
                            color: backgroundColor,
                            elevation: 0,
                            onPressed: loading ? () {} : _submit,
                            child: loading
                                ? CircularProgressIndicator(
                                    backgroundColor: backgroundColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blueGrey))
                                : Text(Language.reg),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    CustomizedWidget(
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: RaisedButton(
                            color: backgroundColor,
                            elevation: 0,
                            onPressed: loading ? () {} : googleSignIn,
                            child: loading
                                ? CircularProgressIndicator(
                                    backgroundColor: backgroundColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blueGrey))
                                : Text(Language.google),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      Language.or,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: FlatButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => fv_Login.create(),
                              ),
                            );
                          },
                          child: Text(Language.sec1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
