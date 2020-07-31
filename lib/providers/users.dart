import 'dart:convert';

import 'package:agni_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  List<User> _items = [];
  // var _showFavoritesOnly = false;

  List<User> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  // List<User> get userById {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }

  User userfindById(int id) {
    return _items.firstWhere((usr) => usr.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchUsers() async {
    const url = 'http://agni-api.infous.xyz/api/get-users';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<User> loadedUsers = [];
      extractedData['data'].forEach((prodData) {
        loadedUsers.add(User(
          id: prodData['id'],
          name: prodData['name'],
          email: prodData['email'],
          password: prodData['password'],
          username: prodData['username'],
          verified: prodData['verified'],
          bio: prodData['bio'],
          profileUrl: prodData['profile_pic'],
          block: prodData['block'],
        ));
      });
      _items = loadedUsers;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  // Future<void> addUser(User user) async {
  //   const url = 'http://agni-api.infous.xyz/api/store-user';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'uid': user.id,
  //         'name': user.name,
  //         'email': user.email,
  //         'profile_pic': user.profileUrl,
  //       }),
  //     );
  //     print(response);
  //     final newUser = User(
  //       id: user.id,
  //       name: user.name,
  //       email: user.email,
  //       profileUrl: user.profileUrl,
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
