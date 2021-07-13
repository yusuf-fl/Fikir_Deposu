import 'dart:convert';

import 'package:blog_app/language/language_enum.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  static LanguageEnum languageEnum = LanguageEnum.tr_TR;
  static Locale locale = Locale("tr", "TR");

  static String ideaArea;
  static String ornek;
  static String noIdea;
  static String profile;
  static String profile1;
  static String profile2;
  static String profile3;
  static String profile4;
  static String profile5;
  static String name;
  static String surname;
  static String email;
  static String bio;
  static String idea;
  static String idea1;
  static String idea2;
  static String idea3;
  static String idea4;
  static String idea5;
  static String idea6;
  static String cat;
  static String cat1;
  static String cat2;
  static String cat3;
  static String cat4;
  static String cat5;
  static String cat6;
  static String cat7;
  static String cat8;
  static String cat9;
  static String cat10;
  static String cat11;
  static String cat12;
  static String cat13;
  static String cat14;
  static String cat15;
  static String cat16;
  static String cat17;
  static String search;
  static String password;
  static String tel;
  static String or;
  static String google;
  static String reg;
  static String login;
  static String sec;
  static String sec1;
  static String messages;

  static void changeLocale(LanguageEnum languageEnum) async {
    (await SharedPreferences.getInstance())
        .setString("Language", languageEnum.getName);
  }

  static void changeLanguage(LanguageEnum languageEnum) async {
    SharedPreferences preferences = (await SharedPreferences.getInstance());
    await preferences.setString("Language", languageEnum.getName);
    await loadLocale();
  }

  static Future<bool> loadLocale() async {
    SharedPreferences preferences = (await SharedPreferences.getInstance());
    String locale;
    if (preferences.containsKey("Language")) {
      locale = preferences.getString("Language");
    } else {
      locale = await Devicelocale.currentLocale;
    }

    Language.languageEnum = LanguageEnumClass.getByName(locale);
    Language.locale = LanguageEnumClass.getLocaleByName(languageEnum);

    ByteData jsonData =
        await rootBundle.load("locale/${languageEnum.getName}.json");
    final jsonBuffer = jsonData.buffer;
    var jsonList =
        jsonBuffer.asUint8List(jsonData.offsetInBytes, jsonData.lengthInBytes);
    String jsonSTR = utf8.decode(jsonList);
    Map m = jsonDecode(jsonSTR);
    loadData(m);
    return Future.value(true);
  }

  static void loadData(Map map) {
    ornek = map["ornek"];
    ideaArea = map["IdeaArea"];
    noIdea = map["NoIdea"];
    profile = map["Profile"];
    profile1 = map["Profile1"];
    profile2 = map["Profile2"];
    profile3 = map["Profile3"];
    profile4 = map["Profile4"];
    profile5 = map["Profile5"];
    name = map["Name"];
    surname = map["Surname"];
    email = map["Email"];
    bio = map["Bio"];
    idea = map["idea"];
    idea1 = map["idea1"];
    idea2 = map["idea2"];
    idea3 = map["idea3"];
    idea4 = map["idea4"];
    idea5 = map["idea5"];
    idea6 = map["idea6"];
    cat = map["cat"];
    cat1 = map["cat1"];
    cat2 = map["cat2"];
    cat3 = map["cat3"];
    cat4 = map["cat4"];
    cat5 = map["cat5"];
    cat6 = map["cat6"];
    cat7 = map["cat7"];
    cat8 = map["cat8"];
    cat9 = map["cat9"];
    cat10 = map["cat10"];
    cat11 = map["cat11"];
    cat12 = map["cat12"];
    cat13 = map["cat13"];
    cat14 = map["cat14"];
    cat15 = map["cat15"];
    cat16 = map["cat16"];
    cat17 = map["cat17"];
    search = map["search"];
    password = map["password"];
    tel = map["tel"];
    reg = map["reg"];
    google = map["google"];
    reg = map["reg"];
    or = map["or"];
    login = map["login"];
    sec = map["sec"];
    sec1 = map["sec1"];
    messages = map["messages"];
  }
}
