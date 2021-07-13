import 'package:blog_app/app/fv_create_new_post_page3.dart';
import 'package:blog_app/app/fv_profile_page.dart';
import 'package:blog_app/app/general_chat_page.dart';
import 'package:blog_app/app/general_favorites_page.dart';
import 'package:blog_app/app/post_view_card.dart';
import 'package:blog_app/authentication/auth.dart';
import 'package:blog_app/language/language.dart';
import 'package:blog_app/language/language_enum.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/database_services.dart';
import 'package:blog_app/widgets/page_view_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  int mainPageIndex = 0;
  User user;
  String lastSearch;

  void _onItemTapped(int index) {
    setState(() {
      mainPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffC6554A),
        elevation: 0,
        title: Row(
          children: [
            Text(
              Language.ornek,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Switch(
              value: LanguageEnum.tr_TR == Language.languageEnum,
              onChanged: (b) {
                setState(
                  () {
                    Language.changeLanguage(
                      LanguageEnum.tr_TR == Language.languageEnum
                          ? LanguageEnum.en_US
                          : LanguageEnum.tr_TR,
                    );
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneralChatPage(
                    user: this.user,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: getBody(),
      bottomNavigationBar: CurvedNavigationBar(
        //key: _bottomNavigationKey,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(MdiIcons.heart, size: 25),
          Icon(Icons.add, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Color(0xffC6554A),
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        index: mainPageIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget getBody() {
    return StreamBuilder(
      stream: Auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        return FutureBuilder(
          future: Database.getUserData(
              snapshot.data == null ? null : snapshot.data.uid),
          builder: (context, data) {
            User user = data.data;
            this.user = user;
            List<Widget> _navigationNavigatorIndexPages = <Widget>[
              getHomePage(user),
              fv_FavoritePostsPage(
                user: user,
              ),
              fv_CreateNewPostPage(
                user: user,
              ),
              fv_ProfilePage(
                user: user,
              ),
            ];

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: _navigationNavigatorIndexPages[mainPageIndex],
            );
          },
        );
      },
    );
  }

  Widget listViewBuilder({List<Post> posts, User user}) {
    return SingleChildScrollView(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostViewCard(
            post: posts[index],
            user: user,
          );
        },
      ),
    );
  }

  getPlaceHolders(User user) {
    var screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Post>>(
      stream: Database.getAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var posts = snapshot.data;
          // if(posts == null){
          //   posts = [];
          // }
          if (posts.isEmpty) {
            return Center(
              child: Text(
                Language.noIdea,
                style: TextStyle(color: Colors.grey, fontSize: 30),
              ),
            );
          }
          posts.sort((a, b) {
            var adate = a.datetime; //before -> var adate = a.expiry;
            var bdate = b.datetime; //var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenWidth,
                      height: screenWidth * 9 / 25,
                      child: PageViewCard(
                        post: posts,
                        user: user,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: Color(0xffC6554A),
                          size: 30,
                        ),
                        Text(
                          Language.ideaArea,
                          style:
                              TextStyle(color: Color(0xffC6554A), fontSize: 25),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Color(0xffC6554A),
                          size: 30,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: listViewBuilder(posts: posts, user: user),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
        );
      },
    );
  }

  Future<List<Post>> _getALlPosts(String text) async {
    lastSearch = text;
    List<Post> postList = [];
    print(text);
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('posts')
        .where("title", whereIn: [text]).get();
    for (DocumentSnapshot innerData in data.docs) {
      postList.add(Post.fromMap(innerData.data()));
    }
    return postList;
  }

  getHomePage(User user) {
    return SearchBar<Post>(
      searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
      headerPadding: EdgeInsets.symmetric(horizontal: 10),
      listPadding: EdgeInsets.symmetric(horizontal: 10),
      onSearch: _getALlPosts,
      hintText: Language.search,
      loader: CircularProgressIndicator(),
      searchBarController: _searchBarController,
      placeHolder: getPlaceHolders(user),
      cancellationWidget: Text("Cancel"),
      emptyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Fikir bulunamadı...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      crossAxisCount: 1,
      onItemFound: (Post post, int index) {
        return PostViewCard(
          post: post,
          user: user,
        );
      },
    );
  }
}
