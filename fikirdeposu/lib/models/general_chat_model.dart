import 'package:blog_app/models/user.dart';

class ChatModel {
  User own;
  User other;

  ChatModel({this.other, this.own});
}
