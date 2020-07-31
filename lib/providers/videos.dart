import 'dart:convert';


import 'package:agni_app/providers/video.dart';
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

  // List<User> get userById {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }

  Video videofindById(int id) {
    return _items.firstWhere((vid) => vid.id == id);
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
    const url = 'http://agni-api.infous.xyz/api/get-all-videos';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Video> loadedVideos = [];
      extractedData['data'].forEach((videoData) {
        loadedVideos.add(Video(
          id: videoData['id'],
          userId: videoData['userId'],
          discription: videoData['discription'],
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

  // Future<void> addUser(User user) async {
  //   const url = 'https://flutter-update.firebaseio.com/products.json';
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
  //     // _items.insert(0, newProduct); // at the start of the list
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateProduct(String id, User newUser) async {
  //   final userIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (userIndex >= 0) {
  //     final url = 'https://flutter-update.firebaseio.com/products/$id.json';
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

  // Future<void> deleteUser(String id) async {
  //   final url = 'https://flutter-update.firebaseio.com/products/$id.json';
  //   final existingUserIndex = _items.indexWhere((usr) => usr.id == id);
  //   var existingUser = _items[existingUserIndex];
  //   _items.removeAt(existingUserIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingUserIndex, existingUser);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingUser = null;
  // }
}
