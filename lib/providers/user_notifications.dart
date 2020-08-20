import 'dart:convert';

import 'package:agni_app/providers/user_notification.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserNotifications with ChangeNotifier {
  List<UserNotification> _items = [];

  List<UserNotification> get items {
    return [..._items];
  }

  List<UserNotification> get reversedItems {
    return [..._items].reversed.toList();
  }



  // List<UserNotification> followersByUserId(int userId) { reversed
  //   return _items.where((fol) => fol.followUserId == userId).toList();
  // }

  // List<UserNotification> followingsByUserId(int userId) {
  //   return _items.where((follower) => follower.userId == userId).toList();
  // }

  // List<UserNotification> followFindByUserId(int userId, int followUserId) {
  //   return _items
  //       .where((follow) =>
  //           follow.followUserId == userId && follow.userId == followUserId)
  //       .toList();
  // }

  Future<void> fetchUserNotifications(int userId) async {
    final url = '$baseUrl/get-notifications/$userId';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<UserNotification> loadedNotifications = [];
      extractedData['data'].forEach((data) {
        loadedNotifications.add(UserNotification(
          id: data['id'],
          myUserId: data['my_userId'],
          effectedUserId: data['effected_userId'],
          type: data['type'],
          value: data['value'],
          optionalImageUrl: data['optional_image'],
          createdAt: data['created_at'],
        ));
      });
      _items = loadedNotifications;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addPushNotification(
    int userId,
    int effectedUserId,
    String type,
    String value,
    String optionalImageUrl,
  ) async {
    const _url = '$baseUrl/store-push-notification';
    try {
      FormData formData = new FormData.fromMap({
        "my_userId": userId,
        "effected_userId": effectedUserId,
        "type": type,
        "value": value,
        "optional_image": optionalImageUrl,
      });
      print(formData);
      Response response = await Dio().post(
        _url,
        data: formData,
      );
      print("Add like response: $response");
      print(response.data['id']);
      final newFollow = UserNotification(
        myUserId: userId,
        effectedUserId: effectedUserId,
        type: type,
        value: value,
        id: response.data['id'],
        optionalImageUrl: response.data['optional_image'],
        createdAt: response.data['created_at'],
      );
      _items.add(newFollow);
      print(newFollow);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Future<void> deleteFollow(int id) async {
  //   print(id.toString());
  //   final url = '$baseUrl/delete-follow/$id';
  //   final existingUserIndex = _items.indexWhere((rec) => rec.id == id);
  //   var existingUser = _items[existingUserIndex];
  //   _items.removeAt(existingUserIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   print(response.body);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingUserIndex, existingUser);
  //     notifyListeners();
  //     throw HttpException('Something went wrong..');
  //   }
  //   existingUser = null;
  // }
}
