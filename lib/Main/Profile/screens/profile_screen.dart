import 'dart:ui';

import 'package:agni_app/Main/Profile/widgets/grid_video.dart';
import 'package:agni_app/Main/Profile/widgets/profile_follower_no.dart';
import 'package:agni_app/Main/Profile/widgets/profile_image.dart';
import 'package:agni_app/Main/empty_box.dart';
import 'package:agni_app/providers/follows.dart';
import 'package:agni_app/providers/user.dart';
import 'package:agni_app/providers/users.dart';
import 'package:agni_app/providers/video.dart';
import 'package:agni_app/providers/videos.dart';
import 'package:agni_app/utils/local_notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'list_follower_screen.dart';
import 'profile_edit_screen.dart';

class ProfilePage extends StatefulWidget {
  final int currentUserId;
  final int userId;
  final bool isBackButton;

  ProfilePage({this.currentUserId, this.userId, this.isBackButton});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int postOrientation = 0;
  bool following = false;

  Future<void> _refreshVideos(BuildContext context) async {
    await Provider.of<Videos>(context, listen: false).fetchVideos();
    await Provider.of<Users>(context, listen: false).fetchUsers();
  }

  Future<void> _addFollow(int userId, int followedUserId) async {
    await Provider.of<Follows>(context, listen: false)
        .addFollow(
      userId,
      followedUserId,
    )
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Following start',
        inPostCallback: true,
      );
      setState(() {});
    });
  }

  Future<void> _unFollow(int id) async {
    await Provider.of<Follows>(context, listen: false)
        .deleteFollow(id)
        .then((value) {
      LocalNotification.success(
        context,
        message: 'Removed from following',
        inPostCallback: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var loadedUser = Provider.of<Users>(
      context,
      listen: false,
    ).userfindById(widget.userId);

    var loadedVideos = Provider.of<Videos>(
      context,
      listen: false,
    ).videoById(widget.userId);

    bool ownProfile = widget.currentUserId == widget.userId;

    var userFollowersCount = Provider.of<Follows>(
          context,
          listen: false,
        )
            .followersByUserId(
              widget.userId,
            )
            .length ??
        0;
    var userFollowingsCount = Provider.of<Follows>(
          context,
          listen: false,
        )
            .followingsByUserId(
              widget.userId,
            )
            .length ??
        0;
    var currentUserFollow = Provider.of<Follows>(
          context,
          listen: false,
        ).followFindByUserId(widget.userId, widget.currentUserId).length ??
        0;
    var followUser = currentUserFollow > 0
        ? Provider.of<Follows>(
            context,
            listen: false,
          ).followFindByUserId(widget.userId, widget.currentUserId)
        : null;

    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () => _refreshVideos(context),
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * .23,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: loadedUser.profileUrl == null
                        ? AssetImage(
                            'assets/images/dice.jpg',
                          )
                        : CachedNetworkImageProvider(loadedUser.profileUrl),
                    fit: BoxFit.cover)),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.isBackButton
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            )
                          : Text(""),
                      loadedUser.username == null
                          ? Text("")
                          : Text(
                              "@${loadedUser.username}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                      ownProfile
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 15),
                              child: InkWell(
                                  child: Icon(
                                    Icons.settings,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileEdit(
                                                currentUser: loadedUser)));
                                  }),
                            )
                          : Text(""),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                profileHeader(
                  loadedUser,
                  loadedVideos,
                  userFollowersCount,
                  userFollowingsCount,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    loadedUser.name == null
                        ? SizedBox.shrink()
                        : Text("${loadedUser.name}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.mcLaren(
                              // color: Colors.black,
                              textStyle: TextStyle(
                                fontSize: 20,
                              ),
                            )),
                    SizedBox(
                      height: 5,
                    ),
                    bioContainer(size, loadedUser),
                  ],
                ),
                ownProfile
                    ? SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          currentUserFollow > 0
                              ? createButtonTitleAndFunction(
                                  title: "Unfollow",
                                  kColor: Colors.purple,
                                  performFunction: () {
                                    _unFollow(followUser.elementAt(0).id);
                                  },
                                )
                              : createButtonTitleAndFunction(
                                  title: "Follow",
                                  kColor: Colors.orange,
                                  performFunction: () {
                                    _addFollow(
                                        widget.currentUserId, widget.userId);
                                  },
                                ),
                          // createButton(),
                          createButtonTitleAndFunction(
                              kColor: Colors.orange,
                              title: "Massege",
                              performFunction: () {}),
                        ],
                      ),
                Divider(
                  color: Colors.blueGrey[500],
                  thickness: 1.0,
                ),
                createGridVideo(),
                Divider(
                  color: Colors.blueGrey[500],
                  thickness: 1.0,
                ),
                displayProfileVideos(loadedVideos),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction, Color kColor}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
          onPressed: performFunction,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.04,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16.0),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kColor,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6.0),
            ),
          )),
    );
  }

  Row profileHeader(
    User loadedUser,
    List<Video> loadedVideos,
    int userFollowersCount,
    int userFollowingsCount,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ProfileImage(loadedUser: loadedUser),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListFollowerScreen(
                            currentUserId: widget.currentUserId,
                            userId: widget.userId,
                            tabIndex: 0,
                          )));
                },
                child: ProfileNumberItem(
                    count: userFollowersCount, typeName: "followers")),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListFollowerScreen(
                          currentUserId: widget.currentUserId,
                            userId: widget.userId,
                            tabIndex: 1,
                        )));
              },
              child: ProfileNumberItem(
                  count: userFollowingsCount, typeName: "following"),
            ),
            SizedBox(
              width: 10,
            ),
            ProfileNumberItem(count: loadedVideos.length, typeName: "videos"),
          ],
        ),
      ],
    );
  }

  Widget bioContainer(Size size, User loadedUser) {
    return loadedUser.bio == null
        ? SizedBox.shrink()
        : Container(
            width: size.width * .70,
            height: size.height * .06,
            child: Text(
              loadedUser.bio,
              style: GoogleFonts.mcLaren(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          );
  }

  displayProfileVideos(List<Video> loadedVideos) {
    // if (loadedVideos.items.) {
    //   return CircularProgressIndicator();
    // } else
    if (loadedVideos.isEmpty) {
      return EmptyBoxScreen();
    } else if (postOrientation == 0) {
      return Expanded(child: GridVideo(userId: widget.userId));
    } else if (postOrientation == 1) {
      return EmptyBoxScreen();
    }
  }

  createGridVideo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 30,
          child: RaisedButton(
              color: Colors.white,
              child: Text(
                "Videos",
                style: GoogleFonts.mcLaren(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              onPressed: () => setOrientation(0)),
        ),
        Container(
          height: 30,
          child: RaisedButton(
              color: Colors.white,
              child: Text(
                "Favorite",
                style: GoogleFonts.mcLaren(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              onPressed: () => setOrientation(1)),
        ),
      ],
    );
  }

  setOrientation(int orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
