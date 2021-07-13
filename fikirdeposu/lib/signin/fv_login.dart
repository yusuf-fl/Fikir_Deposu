import 'package:blog_app/app/home_page.dart';
import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/signin/fv_register.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:blog_app/widgets/customized_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class fv_Login extends StatefulWidget {
  static Widget create() {
    return fv_Login();
  }

  @override
  _fv_LoginState createState() => _fv_LoginState();
}

class _fv_LoginState extends State<fv_Login> {
  bool loading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _submit() async {
    try {
      setState(() {
        loading = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;

      await Auth.signInUserWithEmailAndPassword(email, password);
      Navigator.pop(context);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
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
                  'images/koyu_logo.png',
                  height: 200,
                  width: MediaQuery.of(context).size.width - 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
                              labelText: Language.name,
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
                                        Colors.blueGrey),
                                  )
                                : Text(Language.login),
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
                                builder: (context) => fv_Register.create(),
                              ),
                            );
                          },
                          child: Text(Language.sec),
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
