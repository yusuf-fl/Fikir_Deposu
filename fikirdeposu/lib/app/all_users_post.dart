import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllUsersPost extends StatefulWidget {
  final User user;

  AllUsersPost({this.user});

  @override
  _AllUsersPostState createState() => _AllUsersPostState();
}

class _AllUsersPostState extends State<AllUsersPost> {
  _delete(Post post) async {
    await Database.deletePost(widget.user.uid, post);
    Fluttertoast.showToast(
      msg: "Post silindi!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Swipe Left to delete Post",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xffC6554A),
        elevation: 0,
        title: Text(
          'Fikirlerim',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Post>>(
            stream: Database.getAllUsersPosts(widget.user.uid),
            initialData: [],
            builder: (context, snapshot) {
              var posts = snapshot.data;
              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    'Henüz fikir paylaşılmadı!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                    ),
                  ),
                );
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('${DateTime.now().toIso8601String()}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) => _delete(posts[index]),
                    child: PostViewCard(
                      post: posts[index],
                      user: this.widget.user,
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
