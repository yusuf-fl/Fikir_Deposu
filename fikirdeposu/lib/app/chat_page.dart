import 'package:blog_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final User otherUser;
  final String chatId;

  ChatPage(
      {@required this.user, @required this.otherUser, @required this.chatId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int index = 15;
  final TextEditingController messageController = TextEditingController();

  Future<void> callback() async {
    String text = messageController.text;
    setState(() {
      messageController.clear();
    });
    DateTime time = DateTime.now();
    if (text.length > 1) {
      await _firestore
          .collection("chat")
          .doc(this.widget.chatId)
          .collection("messages")
          .add({
        'message': text,
        'sender': this.widget.user.uid,
        'date': time.millisecondsSinceEpoch,
      });
      await _firestore.collection("chat").doc(this.widget.chatId).update({
        'lastMessage': text,
        'lastSender': this.widget.user.uid,
        'lastMessageTime': time.millisecondsSinceEpoch
      });
    } else {
      Fluttertoast.showToast(msg: "Mesaj çok kısa");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getDocuments() {
    Stream<QuerySnapshot> stream_1 = _firestore
        .collection("chat")
        .doc(this.widget.chatId)
        .collection("messages")
        .orderBy('date', descending: true)
        .snapshots();
    return stream_1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC6554A),
        title: Text(this.widget.otherUser.firstName +
            " " +
            this.widget.otherUser.lastName),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.contain,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstIn),
            image: new AssetImage('images/acik_logo.png'),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: getDocuments(),
                builder: (context, AsyncSnapshot<QuerySnapshot> data) {
                  if (!data.hasData) {
                    return CircularProgressIndicator();
                  }

                  return LazyLoadScrollView(
                    onEndOfPage: () {
                      setState(() {
                        this.index += 5;
                      });
                    },
                    scrollDirection: Axis.vertical,
                    child: SafeArea(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: data.data.docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              getMessageWidget(data.data.docs[index], index),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Mesaj giriniz"),
                      controller: messageController,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        MdiIcons.send,
                        color: Colors.blue,
                      ),
                      onPressed: () => callback())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMessageWidget(DocumentSnapshot doc, int index) {
    Map data = doc.data();
    String senderString = data["sender"].toString();
    bool me = senderString == widget.user.uid;
    String text = data["message"];
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(data["date"].toString()));
    final hourFormatter = DateFormat('HH:mm');
    String formattedDate = hourFormatter.format(date);

    return Row(
      mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .5, minWidth: 50),
          decoration: BoxDecoration(
            color: me ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(me ? 0 : 15),
              topLeft: Radius.circular(!me ? 0 : 15),
              bottomLeft: Radius.circular(!me ? 0 : 15),
              bottomRight: Radius.circular(me ? 0 : 15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.4),
                offset: Offset(0, 2),
                spreadRadius: 1,
                blurRadius: 4,
              )
            ],
          ),
          padding: const EdgeInsets.only(bottom: 4, top: 4, left: 10, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                            color: me ? Colors.white : Colors.black,
                            fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    color: me ? Colors.white : Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
