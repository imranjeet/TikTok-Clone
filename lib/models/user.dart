
class User {
  int id;
  String name;
  String email;
  String password;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'email': email,
      'password': password,
    };
  }
}

//   User({
//     this.id,
//     this.name,
//     this.email,
//     this.password,
//   // // this.bio,
//   // // this.block,
//   // // this.gender,
//   // // this.photoUrl,
//   // // this.username,
//   // // this.verified
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       password: json['password'],
//   // // username: json['username'],
//   // // gender: json['gender'],
//   // // verified: json['verified'],
//   // // bio: json['bio'],
//   // // photoUrl: json['photoUrl'],
//   // // block: json['block'],
//     );
//   }

//   // fromJson() {
//   //   return {
//   //     'id': id.toString(),
//   //     'name': name.toString(),
//   //     'email': email,
//   //     'password': password,

//   // 'username' : username,
//   // 'gender' : gender,
//   // 'verified' : verified,
//   // 'bio' : bio,
//   // 'photoUrl' : photoUrl,
//   // 'block' : block,
//   //   };
//   // }

//   // User(this.email, this.uid, this.displayName, this.photoUrl);

//   // toMap() {
//   //   var map = Map<String, dynamic>();
//   //   map['Id'] = id;
//   //   map['currentUserId'] = userId;
//   //   map['username'] = username;
//   //   map['name'] = _displayName;
//   //   map['userGender'] = gender;
//   //   map['userVerified'] = verified;
//   //   map['userBio'] = bio;
//   //   map['userPic'] = _photoUrl;
//   //   map['userBlock'] = block;
//   //   return map;
//   // }

//   // fromMap() {}

//   // void setUser(Map<String, dynamic> map) {
//   //   _email = map['email'];
//   //   _uid = map['uid'];
//   //   _displayName = map['displayName'];
//   //   _photoUrl = map['photoUrl'];
//   // }

//   // String get uid => _uid;

//   // String get email => _email;

//   // String get displayName => _displayName;

//   // String get photoUrl => _photoUrl;

//   // Map<String, String> get getUser {
//   //   return {
//   //     'email': _email,
//   //     'displayName': _displayName,
//   //     'uid': _uid,
//   //     'photoUrl': _photoUrl,
//   //   };
//   // }
// // }

// // UserService _userService = UserService();

// // Future<User> fetchUser() async {
// //   SharedPreferences _prefs = await SharedPreferences.getInstance();

// //   var userId = _prefs.getInt('userId');

// //   print("userId: $userId",);

// //   final response = _userService.getUserById(userId);

// //   var _userById = json.decode(response.body);
// //   // _userService.getUserById(userId);
// //   print(_userById);

// //   if (response.statusCode == 200) {
// //     // If the server did return a 200 OK response,
// //     // then parse the JSON.
// //     return User.fromJson(json.decode(response.body));
// //   } else {
// //     // If the server did not return a 200 OK response,
// //     // then throw an exception.
// //     throw Exception('Failed to load album');
// //   }
// }
