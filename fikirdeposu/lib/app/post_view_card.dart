import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'full_blog_post.dart';

class PostViewCard extends StatefulWidget {
  final Post post;
  final User user;
  final Database database;

  PostViewCard({this.post, this.user, this.database});

  @override
  _PostViewCardState createState() => _PostViewCardState();
}

class _PostViewCardState extends State<PostViewCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var docRef = FirebaseFirestore.instance
            .collection('views')
            .doc(this.widget.post.title);
        var doc = await docRef.get();

        if (!doc.exists) {
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            transaction.set(docRef, {"count": 1});
          });
        }
        Map<String, dynamic> data = doc.data();

        if (data != null) {
          int count = data["count"] != null ? data["count"] : 0;
          count++;
          data["count"] = count;
        } else {
          data = {"count": 1};
        }

        await FirebaseFirestore.instance
            .collection('views')
            .doc(this.widget.post.title)
            .update(data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullBlogPost(
              post: widget.post,
              user: this.widget.user,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.4),
                      Color(0xffC6554A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${widget.post.title}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(
                      MdiIcons.eye,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FutureBuilder(
                        future: countFuture(),
                        builder: (context, count) {
                          if (!count.hasData)
                            return SpinKitFadingFour(
                              size: 25,
                              color: Colors.white,
                            );

                          return Text(
                            count.data.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> countFuture() async {
    var doc = await FirebaseFirestore.instance
        .collection("views")
        .doc(this.widget.post.title)
        .get();
    if (doc.exists) {
      return doc.data()["count"];
    }

    return 0;
  }
}
