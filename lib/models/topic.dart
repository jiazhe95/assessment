import 'package:flutter/cupertino.dart';

class Topic {
  int id;
  String topicTitle;
  IconData topicIcon;
  bool isFollowing;

  Topic(
    this.id,
    this.topicTitle,
    this.topicIcon,
    this.isFollowing,
  );
}
