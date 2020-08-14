import 'package:flutter/foundation.dart';

class Video {
  int id;
  int userId;
  String description;
  String videoUrl;
  String thumbnail;
  int like;
  String gif;
  int views;
  String section;
  String soundId;
  String created;

  Video({
    @required this.id,
    @required this.userId,
    @required this.description,
    @required this.videoUrl,
    @required this.thumbnail,
    @required this.like,
    this.gif,
    @required this.views,
    this.section,
    this.soundId,
    @required this.created,
  });
}
