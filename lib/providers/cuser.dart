import 'package:flutter/foundation.dart';

class Cuser with ChangeNotifier {
  final int id;
  final String name;
  final String email;
  final String password;
  final String username;
  final int verified;
  final String gender;
  final String bio;
  final String profileUrl;
  final String block;

  Cuser({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.password,
    this.username,
    this.profileUrl,
    this.verified,
    this.gender,
    this.bio,
    this.block,
  });

  // void toggleFavoriteStatus() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }
}
