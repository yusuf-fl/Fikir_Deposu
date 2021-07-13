import 'package:blog_app/models/user.dart';
import 'package:blog_app/signin/fv_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class fv_ProfilePage extends StatefulWidget {
  final User user;

  fv_ProfilePage({this.user});

  @override
  _fv_ProfilePageState createState() => _fv_ProfilePageState();
}

class _fv_ProfilePageState extends State<fv_ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.user == null
          ? fv_Register.create()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                                width: 10,
                              ),
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey.withOpacity(.2),
                                backgroundImage: NetworkImage(this
                                            .widget
                                            .user
                                            .image !=
                                        null
                                    ? widget.user.image
                                    : "https://w7.pngwing.com/pngs/104/119/png-transparent-orange-and-white-logo-computer-icons-icon-design-person-person-miscellaneous-logo-silhouette.png"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              widget.user == null
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blueGrey),
                                      ),
                                    )
                                  : Text(
                                      '${widget.user.bio}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '${widget.user.firstName} ${widget.user.lastName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
