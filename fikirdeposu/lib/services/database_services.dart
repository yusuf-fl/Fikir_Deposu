import 'package:blog_app/models/post.dart';
import 'package:blog_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class Database {
  static Future<User> getUserData(String uid) async {
    if (uid == null) return null;
//    print(uid);
    String path = 'users/$uid/';
//    print(path);
    final reference = FirebaseFirestore.instance.doc(path);
    final data =
        await reference.get().then((value) => User.fromMap(value.data()));
//    print(data.uid);
    return data;
  }

  static Stream<List<Post>> getAllUsersPosts(String uid) {
    String path = "users/$uid/posts/";
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((e) => Post.fromMap(e.data())).toList());
  }

  static Stream<List<Post>> getAllUserFavoritePosts(String uid) {
    String path = "posts/";
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots =
        reference.where("favorites", arrayContains: uid).snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((e) => Post.fromMap(e.data())).toList());
  }

  static Stream<List<Post>> getMostPopularPosts() {
    String path = "posts/";
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots =
        reference.orderBy("favorites", descending: true).snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((e) => Post.fromMap(e.data())).toList());
  }

  static Stream<List<Post>> getAllPosts() {
    String path = "posts/";
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((e) => Post.fromMap(e.data())).toList());
  }

  static Future<void> createPost(String uid, Post post) async {
    try {
      String path = "users/$uid/posts/post_${post.datetime}";
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(post.toMap());
      String path2 = "posts/post_${post.datetime}";
      final reference2 = FirebaseFirestore.instance.doc(path2);
      await reference2.set(post.toMap());
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        details: e.details,
      );
    }
  }

  static Future<void> deletePost(String uid, Post post) async {
    try {
      String path = "users/$uid/posts/post_${post.datetime}";
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.delete();
      String path2 = "posts/post_${post.datetime}";
      final reference2 = FirebaseFirestore.instance.doc(path2);
      await reference2.delete();
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        details: e.details,
      );
    }
  }

  static Future<void> savePost(String uid, Post post) async {
    try {
      String path = "users/$uid/saved_posts/post_${post.datetime}";
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(post.toMap());
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        details: e.details,
      );
    }
  }

  static Future<void> unsavePost(String uid, Post post) async {
    try {
      String path = "users/$uid/saved_posts/post_${post.datetime}";
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.delete();
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        details: e.details,
      );
    }
  }
}
