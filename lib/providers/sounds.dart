import 'dart:convert';

import 'package:agni_app/models/http_exception.dart';
import 'package:agni_app/providers/sound.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sounds with ChangeNotifier {
  List<Sound> _items = [];

  List<Sound> get items {
    return [..._items];
  }

  // List<Sound> reactionByVideoId(int videoId) {
  //   return _items.where((reaction) => reaction.videoId == videoId).toList();
  // }

  // List<Sound> reactionfindByuserId(int videoId, int userId) {
  //   return _items
  //       .where((reaction) =>
  //           reaction.videoId == videoId && reaction.userId == userId)
  //       .toList();
  // }

  Future<void> fetchSounds() async {
    const url = '$baseUrl/get-all-sounds';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      final List<Sound> loadedSounds = [];
      extractedData['data'].forEach((data) {
        loadedSounds.add(Sound(
          id: data['id'],
          name: data['sound_name'],
          description: data['description'],
          soundUrl: data['sound_url'],
        ));
      });
      _items = loadedSounds;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addSound(String _videoId, String _currentUserId, String _number) async {
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
      final newUser = Sound(
        name: _videoId,
        description: _currentUserId,
        soundUrl: _number,
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

  Future<void> deleteSound(int id) async {
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
