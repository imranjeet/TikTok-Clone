import 'package:flutter/foundation.dart';

class Reaction with ChangeNotifier {
  final int id;
  final int videoId;
  final int userId;
  final int reaction;

  Reaction({
    @required this.id,
    @required this.videoId,
    @required this.userId,
    @required this.reaction,
  });
}
