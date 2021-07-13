import 'package:blog_app/app/chat_page.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/signin/fv_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GeneralChatPage extends StatefulWidget {
  final User user;

  GeneralChatPage({this.user});

  @override
  _GeneralChatPageState createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  get index => 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC6554A),
        title: Text(Language.messages),
      ),
      body: getBody(),
      backgroundColor: Color(0xfffff7f7),
    );
  }

  getBody() {
    if (this.widget.user == null) return fv_Register.create();
    return StreamBuilder(
        stream: getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
          if (!data.hasData) return CircularProgressIndicator();
          List<QueryDocumentSnapshot> list = data.data.docs;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              String lastMessage = list[index].data()["lastMessage"];
              String docId = list[index].data()["chatId"];
              return FutureBuilder(
                future: getUserData(list[index]),
                builder: (BuildContext context, AsyncSnapshot<User> data) {
                  if (!data.hasData) return CircularProgressIndicator();
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data.data.image != null
                          ? data.data.image
                          : "https://www.gravatar.com/avatar/"),
                    ),
                    title: Text(data.data.firstName + " " + data.data.lastName),
                    subtitle: Text(lastMessage == null ? " " : lastMessage),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: this.widget.user,
                            otherUser: data.data,
                            chatId: docId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        });
  }

  Stream<QuerySnapshot> getDocuments() {
    return FirebaseFirestore.instance
        .collection("chat")
        .where("users", arrayContains: this.widget.user.uid)
        .orderBy('lastMessageTime', descending: true)
        .limit(index != null ? index : 25)
        .snapshots();
  }

  Future<User> getUserData(QueryDocumentSnapshot doc) async {
    List<String> users = List<String>.from(doc.data()["users"]);
    String otherUid;
    if (this.widget.user.uid == users[0])
      otherUid = users[1];
    else
      otherUid = users[0];
    return await Database.getUserData(otherUid);
  }
}
