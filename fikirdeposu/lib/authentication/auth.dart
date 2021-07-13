import 'package:blog_app/models/user.dart' as localUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth {
  static final _auth = FirebaseAuth.instance;

  static localUser.User _userFromFirebase(User user) {
    return user != null ? localUser.User(uid: user.uid) : null;
  }

  static Stream<localUser.User> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  static Future<localUser.User> createUserWithGoogle(String tel, String bio,
      AuthCredential credential, GoogleSignInAccount account) async {
    try {
      final authResult = await _auth.signInWithCredential(credential);
      final reference =
          FirebaseFirestore.instance.doc('users/${authResult.user.uid}');

      String lastName = account.displayName.contains(" ")
          ? account.displayName.split(" ").last
          : "";

      String lastSplitter = "";
      int i = 0;
      for (String s in account.displayName.split(" ")) {
        if (i != account.displayName.split(" ").length - 1) {
          lastSplitter += s + " ";
        }
        i++;
      }

      String firstName = account.displayName.contains(" ")
          ? lastSplitter
          : account.displayName;

      Map<String, dynamic> data = localUser.User(
              uid: '${authResult.user.uid}',
              email: account.email,
              lastName: lastName,
              firstName: firstName,
              tel: tel,
              bio: bio)
          .toMap();
      await reference.set(data);
      User user = authResult.user;
      return _userFromFirebase(user);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        throw PlatformException(
            code: 'Weak Password',
            details: 'Password length should be atleas 6 characters');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw PlatformException(
            code: 'Invalid Email',
            details: 'The email address is badly formatted.');
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw PlatformException(
            code: 'Email Already exists', details: 'Login into the app');
      } else {
        throw PlatformException(
            code: 'Some error occured',
            details: 'Try again later or check your internet connection');
      }
    }
  }

  static Future<localUser.User> createUserWithEmailAndPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String tel,
      String bio) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final reference =
          FirebaseFirestore.instance.doc('users/${authResult.user.uid}');
      Map<String, dynamic> data = localUser.User(
              uid: '${authResult.user.uid}',
              email: email,
              firstName: firstName,
              lastName: lastName,
              tel: tel,
              bio: bio)
          .toMap();
      await reference.set(data);
      User user = authResult.user;
      return _userFromFirebase(user);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        throw PlatformException(
            code: 'Weak Password',
            details: 'Password length should be atleas 6 characters');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw PlatformException(
            code: 'Invalid Email',
            details: 'The email address is badly formatted.');
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw PlatformException(
            code: 'Email Already exists', details: 'Login into the app');
      } else {
        throw PlatformException(
            code: 'Some error occured',
            details: 'Try again later or check your internet connection');
      }
    }
  }

  static Future<localUser.User> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = authResult.user;
      print(user.uid);
      return _userFromFirebase(user);
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        throw PlatformException(
            code: 'Weak Password',
            details: 'Password length should be atleast 6 characters');
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        throw PlatformException(
            code: 'Invalid Email',
            details: 'The email address is badly formatted');
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw PlatformException(
            code: 'User not Found',
            details:
                'There is no user record corresponding to this credentials, create an account');
      } else {
        throw PlatformException(
            code: 'Some error occured',
            details: 'Try again later or check your internet connection');
      }
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
