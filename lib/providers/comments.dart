import 'dart:convert';

import 'package:agni_app/models/http_exception.dart';
import 'package:agni_app/providers/comment.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Comments with ChangeNotifier {
  List<Comment> _items = [];

  List<Comment> get items {
    return [..._items];
  }

  List<Comment> commetByVideoId(int videoId) {
    return _items.where((com) => com.videoId == videoId).toList();
  }

  List<Comment> commentfindByuserId(int videoId, int userId) {
    return _items
        .where((com) => com.videoId == videoId && com.userId == userId)
        .toList();
  }

  Future<void> fetchComments() async {
    const url = '$baseUrl/get-all-comments';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Comment> loadedComments = [];
      extractedData['data'].forEach((data) {
        loadedComments.add(Comment(
          id: data['id'],
          videoId: data['video_id'],
          userId: data['userId'],
          comment: data['comment'],
          createdAt: data['created_at'],
        ));
      });
      _items = loadedComments;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addComment(
      int videoId, int currentUserId, String comment) async {
    const _url = '$baseUrl/store-comment';
    try {
      FormData formData = new FormData.fromMap({
        "video_id": videoId,
        "userId": currentUserId,
        "comment": comment,
        // "created_at": DateTime.now(),
      });
      print(formData);
      Response response = await Dio().post(
        _url,
        data: formData,
      );
      print("Comment response: $response");
      print(response.data['id']);
      final newUser = Comment(
        videoId: videoId,
        userId: currentUserId,
        comment: comment,
        id: response.data['id'],
        createdAt: response.data['created_at'],
      );
      _items.add(newUser);
      print(newUser);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteComment(int id) async {
    print(id.toString());
    final url = '$baseUrl/delete-comment/$id';
    final existingUserIndex = _items.indexWhere((rec) => rec.id == id);
    var existingUser = _items[existingUserIndex];
    _items.removeAt(existingUserIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.body);
    if (response.statusCode >= 400) {
      _items.insert(existingUserIndex, existingUser);
      notifyListeners();
      throw HttpException('Something went wrong..');
    }
    existingUser = null;
  }

  // Future<void> updateProduct(String id, User newUser) async {
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

}
