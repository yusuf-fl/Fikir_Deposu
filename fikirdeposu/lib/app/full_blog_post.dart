import 'package:blog_app/app/chat_page.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FullBlogPost extends StatefulWidget {
  final Post post;
  final User user;

  FullBlogPost({@required this.post, this.user});

  @override
  _FullBlogPostState createState() => _FullBlogPostState();
}

class _FullBlogPostState extends State<FullBlogPost> {
  @override
  void initState() {
    log();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xffC6554A),
        elevation: 0,
        title: Text(
          '${widget.post.type}',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (this.widget.user != null)
            if (!checkOwner())
              IconButton(
                icon: Icon(
                  favorite() ? MdiIcons.heart : MdiIcons.heartOutline,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await subscribe();
                },
              ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
                    Image.network(widget.post.image),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      color: Color(0xFFFFFFFF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Fikir İsmi",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF565656))),
                          Text('${this.widget.post.title} ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF565656))),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF999999),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      color: Color(0xFFFFFFFF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Fiyat",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF565656))),
                          Text("৳ ${(widget.post.price)}".toUpperCase(),
                              style: TextStyle(
                                  color: (widget.post.price) != null
                                      ? Color(0xFFf67426)
                                      : Color(0xFF0dc2cd),
                                  fontFamily: 'Roboto-Light.ttf',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      color: Color(0xFFFFFFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Kategori",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF565656))),
                          SizedBox(
                            height: 15,
                          ),
                          Text("${widget.post.type}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4c4c4c))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 20, bottom: 20),
                      color: Color(0xFFFFFFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Açıklama",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF565656))),
                          SizedBox(
                            height: 15,
                          ),
                          Text("${widget.post.content}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4c4c4c))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: getNavBar(),
    );
  }

  getNavBar() {
    if (this.widget.user != null) if (this.widget.user.uid ==
        this.widget.post.userUid)
      return Container(
        height: 0,
        width: 0,
      );

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: 195.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                side: BorderSide(color: Color(0xFFfef2f2))),
            child: RaisedButton(
              elevation: 0,
              onPressed: () async {
                String chatRoomId;

                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection("chat")
                    .where("users", whereIn: [
                  [
                    this.widget.user.uid,
                    this.widget.post.userUid,
                  ],
                  [
                    this.widget.post.userUid,
                    this.widget.user.uid,
                  ]
                ]).get();

                if (snapshot.docs.length == 1) {
                  chatRoomId = snapshot.docs[0].id;
                } else {
                  chatRoomId = this.widget.user.uid.toString() +
                      "-" +
                      this.widget.post.userUid.toString();
                  DateTime time = DateTime.now();
                  await FirebaseFirestore.instance
                      .collection("chat")
                      .doc(chatRoomId)
                      .set({
                    'chatId': chatRoomId,
                    'lastMessage': '',
                    'lastMessageTime': time.millisecondsSinceEpoch,
                    'lastSender': this.widget.user.uid,
                    'users': [this.widget.post.userUid, this.widget.user.uid],
                  });
                }
                User otherUser =
                    await Database.getUserData(this.widget.post.userUid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      otherUser: otherUser,
                      user: this.widget.user,
                      chatId: chatRoomId,
                    ),
                  ),
                );
              },
              color: Color(0xFFfef2f2),
              textColor: Colors.white,
              child: Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                child: Text("İLETİŞİME GEÇ".toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFff665e))),
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 195.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                side: BorderSide(color: Color(0xFFfef2f2))),
            child: RaisedButton(
              elevation: 0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  side: BorderSide(color: Color(0xFFff665e))),
              onPressed: () {},
              color: Color(0xFFff665e),
              textColor: Colors.white,
              child: Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                child: Text("FİKRİ SATIN AL".toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkOwner() {
    return (this.widget.post.email == this.widget.user.email);
  }

  favorite() {
    return this.widget.post.favorites.contains(this.widget.user.uid);
  }

  Future<void> subscribe() async {
    setState(() {
      if (this.widget.post.favorites.contains(this.widget.user.uid)) {
        this.widget.post.favorites.remove(this.widget.user.uid);
      } else {
        this.widget.post.favorites.add(this.widget.user.uid);
      }
    });
    String path = "posts/post_${this.widget.post.datetime}";
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(this.widget.post.toMap());
  }

  void log() async {
    if (widget.user == null) {
      String locale = await Devicelocale.currentLocale;
      DateTime time = DateTime.now();
      FirebaseFirestore.instance.collection("logs").add(
        {
          "location": locale,
          "time": time.toString(),
          "category": widget.post.title,
        },
      );
    }
  }
}
