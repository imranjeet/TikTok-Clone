import 'package:flutter/foundation.dart';

class Follow with ChangeNotifier {
  final int id;
  final int userId;
  final int followUserId;

  Follow({
    @required this.id,
    @required this.userId,
    @required this.followUserId,
  });
}
