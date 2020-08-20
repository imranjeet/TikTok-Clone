import 'package:flutter/foundation.dart';

class Sound with ChangeNotifier {
  final int id;
  final String name;
  final String description;
  final String soundUrl;

  Sound({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.soundUrl,
  });
}
