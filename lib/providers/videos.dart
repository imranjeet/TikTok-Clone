import 'dart:convert';

import 'package:agni_app/models/http_exception.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Videos with ChangeNotifier {
  List<Video> _items = [];
  // var _showFavoritesOnly = false;

  List<Video> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Video> videoById(int userId) {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return _items.where((video) => video.userId == userId).toList();
  }

  // List<User> get userById {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }

  List<Video> videofindById(int userId) {
    return _items.where((vid) => vid.userId == userId);
  }

  List<Video> allUserVideos(int userId, int i, int total) {
    var userVideos = _items.where((video) => video.userId == userId).toList();
    return userVideos.getRange(i, total).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchVideos() async {
    const url = '$baseUrl/get-all-videos';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Video> loadedVideos = [];
      extractedData['data'].forEach((videoData) {
        loadedVideos.add(Video(
          id: videoData['id'],
          userId: videoData['userId'],
          description: videoData['description'],
          videoUrl: videoData['video_url'],
          thumbnail: videoData['thumbnail'],
          like: videoData['videoLike'],
          gif: videoData['gif'],
          views: videoData['views'],
          section: videoData['section'],
          soundId: videoData['soundId'],
          created: videoData['created'],
        ));
      });
      _items = loadedVideos;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  // Future<void> addVideo(User user) async {
  //   const url = 'http://agni-api.infous.xyz/api/';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'id': user.id,
  //         'name': user.name,
  //         'email': user.email,
  //         'password': user.password,
  //       }),
  //     );
  //     final newUser = User(
  //       id: user.id,
  //       name: user.name,
  //       email: user.email,
  //       password: user.password,
  //     );
  //     _items.add(newUser);
  //     // _items.insert(0, newUser); // at the start of the list
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateVideo(String id, User newUser) async {
  //   final userIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (userIndex >= 0) {
  //     final url = 'http://agni-api.infous.xyz/api/';
  //     await http.patch(url,
  //         body: json.encode({
  //           'id': newUser.id,
  //           'name': newUser.name,
  //           'email': newUser.email,
  //           'password': newUser.password,
  //         }));
  //     _items[userIndex] = newUser;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  Future<void> deleteVideo(int id) async {
    final url = '$baseUrl/delete-video/$id';
    final existingUserIndex = _items.indexWhere((vid) => vid.id == id);
    var existingUser = _items[existingUserIndex];
    _items.removeAt(existingUserIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response);
    if (response.statusCode >= 400) {
      _items.insert(existingUserIndex, existingUser);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingUser = null;
  }
}
