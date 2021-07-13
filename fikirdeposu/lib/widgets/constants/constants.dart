import 'package:blog_app/language/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static final List<Map<String, String>> categories = [
    {Language.cat: "images/teknoloji.jpg"},
    {Language.cat1: "images/spor.jpg"},
    {Language.cat2: "images/fashion.png"},
    {Language.cat3: "images/social.jpg"},
    {Language.cat4: "images/finance.jpeg"},
    {Language.cat5: "images/sinema.png"},
    {Language.cat6: "images/music.jpg"},
    {Language.cat7: "images/grafik.png"},
    {Language.cat8: "images/tech.jpg"},
    {Language.cat9: "images/siyaset.jpg"},
    {Language.cat10: "images/e-ticaret.png"},
    {Language.cat11: "images/egitim.jpg"},
    {Language.cat12: "images/saglik.jpg"},
    {Language.cat13: "images/cevre.jpg"},
    {Language.cat14: "images/enerji.jpg"},
    {Language.cat15: "images/kimya.jpg"},
    {Language.cat16: "images/fizik.jpg"},
    {Language.cat17: "images/mimari.jpg"},
  ];
}

const Color KTweeterColor = Color(0xff00acee);

final _fireStore = FirebaseFirestore.instance;

final UsersRef = _fireStore.collection('Users');

final followersRef = _fireStore.collection('followers');

final followingRef = _fireStore.collection('following');

final storageRef = FirebaseStorage.instance.ref();

var backgroundColor = Colors.white;
