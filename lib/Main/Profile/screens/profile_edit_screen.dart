import 'dart:io';
import 'dart:ui';
import 'package:agni_app/Main/Profile/auth/login_screen.dart';
import 'package:agni_app/providers/user.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/utils/constant.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEdit extends StatefulWidget {
  final User currentUser;

  const ProfileEdit({Key key, this.currentUser}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final name = TextEditingController();
  final username = TextEditingController();
  final bio = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();

  File _image;
  final picker = ImagePicker();

  bool _validate = false;
  bool _isLoading = false;

  _logOut(BuildContext context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('userId');
    var currentUserId = _prefs.getInt('userId');
    if (currentUserId == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      showDialog(context: context, child: Text("Failed to logout!"));
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (value.length == 0) {
      return 'Email cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length == 0) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  Future<void> updateProfile(BuildContext context, int userId, String _name,
      String _email, String _username, String _bio, File _image) async {
    try {
      FormData formData = new FormData.fromMap({
        "name": _name,
        "email": _email,
        "username": _username,
        "bio": _bio,
        "profile_pic":
            _image == null ? "" : await MultipartFile.fromFile(_image.path),
      });

      Response response = await Dio().post(
        "$baseUrl/update-user/$userId",
        data: formData,
        onSendProgress: (int sent, int total) {
          print("Sent: $sent Total: $total");
        },
      );
      print("File upload response: $response");
      if (response != null) {
        setState(() {
          _isLoading = false;
        });
        await Provider.of<Users>(context, listen: false).fetchUsers();
        await Provider.of<Videos>(context, listen: false).fetchVideos();
        LocalNotification.success(
          context,
          message: 'profile updated successfully!',
          inPostCallback: true,
        );
        Navigator.pop(context);
        // _showSnackMessage("profile updated successfully!");
      }
    } catch (e) {
      print(" error expectation Caugch: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            // color: Colors.white,
            height: size.height * .4,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.currentUser.profileUrl == null
                        ? AssetImage(
                            'assets/images/dice.jpg',
                          )
                        : NetworkImage(widget.currentUser.profileUrl),
                    fit: BoxFit.cover)),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  // child: Text(
                  //   "Blur Background Image in Flutter",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  // ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "EDIT PROFILE",
                          style: GoogleFonts.mcLaren(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          onTap: () => _logOut(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2.0,
                                ),
                              ]),
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: 'profile',
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: _image == null
                                      ? widget.currentUser.profileUrl == null
                                          ? AssetImage(
                                              'assets/images/profile-image.png',
                                            )
                                          : NetworkImage(
                                              widget.currentUser.profileUrl)
                                      : FileImage(_image),
                                ),
                              ),
                              Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    // color: Colors.blueGrey[100],
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: FloatingActionButton(
                                    // heroTag: null,
                                    elevation: 2.0,
                                    backgroundColor: Colors.pink,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    onPressed: _getImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 4),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            controller: username
                              ..text = widget.currentUser.username ?? "",
                            decoration: InputDecoration(
                              labelText: 'username',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              prefixStyle: TextStyle(color: Colors.white),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                tooltip: 'Close',
                                onPressed: () {
                                  username.clear();
                                },
                              ),
                              errorText: _validate
                                  ? 'Username can\'t be empty!'
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          width: size.width * .85,
                          height: size.height * .13,
                          child: TextFormField(
                            controller: name
                              ..text = widget.currentUser.name ?? "",
                            decoration: InputDecoration(
                              labelText: "Your name",
                              // hintText: "John",
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                tooltip: 'Close',
                                onPressed: () {
                                  name.clear();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10.0), // #7449D1
                              ),
                            ),
                            validator: (val) {
                              if (val.length < 3) {
                                return "Please Enter a valid first name!";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: size.width * .85,
                          height: size.height * .13,
                          child: TextFormField(
                            controller: email
                              ..text = widget.currentUser.email ?? "",
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              // hintText: "John",
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                tooltip: 'Close',
                                onPressed: () {
                                  email.clear();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10.0), // #7449D1
                              ),
                            ),
                            validator: emailValidator,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 1),
                          child: TextField(
                            maxLines: 2,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            controller: bio
                              ..text = widget.currentUser.bio ?? "",
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              fillColor: Colors.black,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixStyle: TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                tooltip: 'Close',
                                onPressed: () {
                                  bio.clear();
                                },
                              ),
                              errorText:
                                  _validate ? 'name can\'t be empty!' : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .05,
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 5),
                                color: Colors.pink,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  updateProfile(
                                      context,
                                      widget.currentUser.id,
                                      name.text,
                                      email.text,
                                      username.text,
                                      bio.text,
                                      _image);
                                  setState(() {
                                    _isLoading = true;
                                  });
                                },
                                child: Text(
                                  "Update",
                                  style: kTitleTextstyle,
                                  // style: TextStyle(),
                                ),
                              ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 3),
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () => _logOut(context),
                          child: Text(
                            "Sign Out",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getImage() async {
    final image = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    print(image.toString());

    setState(() {
      if (!mounted) {
        return;
      }
      _image = File(image.path);
    });

    // File croppedImage = await ImageCropper.cropImage(
    //   sourcePath: _image.path,
    //   aspectRatio: CropAspectRatio(
    //     ratioX: 1,
    //     ratioY: 1,
    //   ),
    //   // aspectRatioPresets: [
    //   //   CropAspectRatioPreset.square,
    //   // ],
    //   androidUiSettings: AndroidUiSettings(
    //     toolbarTitle: 'Image Cropper',
    //     toolbarColor: Colors.black,
    //     toolbarWidgetColor: Colors.white,
    //     initAspectRatio: CropAspectRatioPreset.square,
    //     lockAspectRatio: true,
    //   ),
    //   // iosUiSettings: IOSUiSettings(
    //   //   minimumAspectRatio: 1.0,
    //   // ),
    // );

    // print(croppedImage.toString());

    // setState(() {
    //   _image = croppedImage ?? _image;
    // });
  }
}
