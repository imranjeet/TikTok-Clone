import 'dart:convert';

import 'package:agni_app/models/http_exception.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'follow.dart';

class Follows with ChangeNotifier {
  List<Follow> _items = [];

  List<Follow> get items {
    return [..._items];
  }

  List<Follow> followersByUserId(int userId) {
    return _items.where((fol) => fol.followUserId == userId).toList();
  }

  List<Follow> followingsByUserId(int userId) {
    return _items.where((follower) => follower.userId == userId).toList();
  }

  List<Follow> followFindByUserId(int userId, int followUserId) {
    return _items
        .where((follow) =>
            follow.followUserId == userId && follow.userId == followUserId)
        .toList();
  }

  Future<void> fetchFollows() async {
    const url = '$baseUrl/get-all-follows';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Follow> loadedFollows = [];
      extractedData['data'].forEach((data) {
        loadedFollows.add(Follow(
          id: data['id'],
          userId: data['userId'],
          followUserId: data['followed_user_id'],
        ));
      });
      _items = loadedFollows;
      // print("loadedFollow: $loadedFollows");
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addFollow(int userId, int followUserId) async {
    const _url = '$baseUrl/store-follow';
    try {
      FormData formData = new FormData.fromMap({
        "userId": userId,
        "followed_user_id": followUserId,
      });
      print(formData);
      Response response = await Dio().post(
        _url,
        data: formData,
      );
      // print("Add like response: $response");
      // print(response.data['id']);
      final newFollow = Follow(
        userId: userId,
        followUserId: followUserId,
        id: response.data['id'],
      );
      _items.add(newFollow);
      print(newFollow);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteFollow(int id) async {
    // print(id.toString());
    final url = '$baseUrl/delete-follow/$id';
    final existingUserIndex = _items.indexWhere((rec) => rec.id == id);
    var existingUser = _items[existingUserIndex];
    _items.removeAt(existingUserIndex);
    notifyListeners();
    final response = await http.delete(url);
    // print(response.body);
    if (response.statusCode >= 400) {
      _items.insert(existingUserIndex, existingUser);
      notifyListeners();
      throw HttpException('Something went wrong..');
    }
    existingUser = null;
  }
}
