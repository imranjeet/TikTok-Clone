import 'package:flutter/foundation.dart';

class Video {
  int id;
  int userId;
  String description;
  String videoUrl;
  String thumbnail;
  String gif;
  int views;
  int sectionId;
  String soundName;
  String createdAt;

  Video({
    @required this.id,
    @required this.userId,
    @required this.description,
    @required this.videoUrl,
    @required this.thumbnail,
    this.gif,
    @required this.views,
    this.sectionId,
    this.soundName,
    @required this.createdAt,
  });
}
