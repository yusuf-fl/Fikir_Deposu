import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/widgets/constants/constants.dart';
import 'package:flutter/material.dart';

class AllUsersFavoritePosts extends StatefulWidget {
  final User user;

  AllUsersFavoritePosts({this.user});

  @override
  _AllUsersFavoritePostsState createState() => _AllUsersFavoritePostsState();
}

class _AllUsersFavoritePostsState extends State<AllUsersFavoritePosts> {
  @override
  void initState() {
    super.initState();
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
            stream: Database.getAllUserFavoritePosts(widget.user.uid),
            initialData: [],
            builder: (context, snapshot) {
              var posts = snapshot.data;
              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    'Henüz favori bir fikriniz yok!',
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
