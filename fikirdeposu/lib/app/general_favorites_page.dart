import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class fv_FavoritePostsPage extends StatefulWidget {
  final User user;

  fv_FavoritePostsPage({this.user});

  @override
  _fv_FavoritePostsPageState createState() => _fv_FavoritePostsPageState();
}

class _fv_FavoritePostsPageState extends State<fv_FavoritePostsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: Database.getMostPopularPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> posts) {
          if (!posts.hasData) {
            return CircularProgressIndicator();
          }
          List<Post> realPosts = clearLowerPosts(posts.data);
          if (realPosts.length > 0)
            return ListView.builder(
              itemCount: realPosts.length,
              itemBuilder: (context, index) {
                Post post = realPosts[index];
                return PostViewCard(
                  user: this.widget.user,
                  post: post,
                );
              },
            );
          else
            return Center(
              child: Text(
                "Popüler fikir bulunamadı!",
              ),
            );
        },
      ),
    );
  }

  List<Post> clearLowerPosts(List<Post> data) {
    List<Post> realPosts = [];
    for (Post p in data) {
      if (p.favorites.length >= 6) {
        realPosts.add(p);
      }
    }
    return realPosts;
  }
}
