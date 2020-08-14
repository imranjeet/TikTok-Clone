import 'dart:convert';

import 'package:agni_app/models/http_exception.dart';
import 'package:agni_app/providers/reaction.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Reactions with ChangeNotifier {
  List<Reaction> _items = [];

  List<Reaction> get items {
    return [..._items];
  }

  List<Reaction> reactionByVideoId(int videoId) {
    return _items.where((reaction) => reaction.videoId == videoId).toList();
  }

  List<Reaction> reactionfindByuserId(int videoId, int userId) {
    return _items
        .where((reaction) =>
            reaction.videoId == videoId && reaction.userId == userId)
        .toList();
  }

  Future<void> fetchReactions() async {
    const url = '$baseUrl/get-all-reactions';
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Reaction> loadedReactions = [];
      extractedData['data'].forEach((data) {
        loadedReactions.add(Reaction(
          id: data['id'],
          videoId: data['video_id'],
          userId: data['userId'],
          reaction: data['reaction'],
        ));
      });
      _items = loadedReactions;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addLike(int _videoId, int _currentUserId, int _number) async {
    const _url = '$baseUrl/store-reaction';
    try {
      FormData formData = new FormData.fromMap({
        "video_id": _videoId,
        "userId": _currentUserId,
        "reaction": _number,
      });
      // print(formData);
      Response response = await Dio().post(
        _url,
        data: formData,
      );
      // print("Add like response: $response");
      print(response.data['id']);
      final newUser = Reaction(
        videoId: _videoId,
        userId: _currentUserId,
        reaction: _number,
        id: response.data['id'],
      );
      _items.add(newUser);
      // print(newUser);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteReaction(int id) async {
    print(id.toString());
    final url = '$baseUrl/delete-reaction/$id';
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
}
