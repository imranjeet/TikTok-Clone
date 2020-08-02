import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  // final String userProfileId;
  // ProfileScreen({this.userProfileId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  // final String currentOnlineUserId = currentUser?.id;
  // bool loading = false;
  // int countPost = 0;
  // List<Post> postsList = [];
  // int postOrientation = 0;
  // int countTotleFollowers = 0;
  // int countTotleFollowings = 0;
  // bool following = false;

  // @override
  // void initState() {
  //   super.initState();
  // getAllProfilePosts();
  // getAllFollowers();
  // getAllFollowings();
  // checkIfAlreadyFollowing();
  // }

  // getAllFollowers() async {
  //   QuerySnapshot querySnapshot = await followersReference
  //       .document(widget.userProfileId)
  //       .collection("userFollowers")
  //       .getDocuments();

  //   setState(() {
  //     countTotleFollowers = querySnapshot.documents.length;
  //   });
  // }

  // getAllFollowings() async {
  //   QuerySnapshot querySnapshot = await followingsReference
  //       .document(widget.userProfileId)
  //       .collection("userFollowings")
  //       .getDocuments();

  //   setState(() {
  //     countTotleFollowings = querySnapshot.documents.length;
  //   });
  // }

  // checkIfAlreadyFollowing() async {
  //   DocumentSnapshot documentSnapshot = await followersReference
  //       .document(widget.userProfileId)
  //       .collection("userFollowers")
  //       .document(currentOnlineUserId)
  //       .get();

  //   setState(() {
  //     following = documentSnapshot.exists;
  //   });
  // }

  // createProfileTopView() {
  //   return FutureBuilder(
  //       future: usersReference.document(widget.userProfileId).get(),
  //       builder: (context, dataSnapshot) {
  //         if (!dataSnapshot.hasData) {
  //           return circularProgress();
  //         }
  //         User user = User.fromDocument(dataSnapshot.data);
  //         return Padding(
  //           padding: EdgeInsets.all(10.0),
  //           child: Column(
  //             children: <Widget>[
  //               Column(
  //                 children: <Widget>[
  //                   CircleAvatar(
  //                     radius: 50.0,
  //                     backgroundColor: Colors.cyan,
  //                     backgroundImage: CachedNetworkImageProvider(user.url),
  //                   ),
  //                   SizedBox(height: 5.0),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     child: Text(user.username),
  //                   ),
  //                   SizedBox(height: 5.0),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       user.profileName,
  //                       style: TextStyle(
  //                           fontSize: 20.0, fontWeight: FontWeight.bold),
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.0),
  //                   Container(
  //                     alignment: Alignment.center,
  //                     child: Text(user.bio),
  //                   ),
  //                   SizedBox(height: 5.0),
  //                   Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: <Widget>[
  //                       createColumn("posts", countPost),
  //                       createColumn("followers", countTotleFollowers),
  //                       createColumn("following", countTotleFollowings),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10.0),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: <Widget>[
  //                       createButton(),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  // Column createColumn(String title, int count) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Text(
  //         count.toString(),
  //         style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: 5.0),
  //         child: Text(
  //           title,
  //           style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // createButton() {
  //   bool ownProfile = currentOnlineUserId == widget.userProfileId;
  //   if (ownProfile) {
  //     return createButtonTitleAndFunction(
  //       title: "Edit Profile",
  //       performFunction: editUserProfile,
  //     );
  //   } else if (following) {
  //     return createButtonTitleAndFunction(
  //       title: "Unfollow",
  //       performFunction: controlUnfollowUser,
  //     );
  //   } else if (!following) {
  //     return createButtonTitleAndFunction(
  //       title: "Follow",
  //       performFunction: controlFollowUser,
  //     );
  //   }
  // }

  // controlUnfollowUser() {
  //   setState(() {
  //     following = false;
  //   });

  //   followersReference
  //       .document(widget.userProfileId)
  //       .collection("userFollowers")
  //       .document(currentOnlineUserId)
  //       .get()
  //       .then((document) {
  //     if (document.exists) {
  //       document.reference.delete();
  //     }
  //   });

  //   followingsReference
  //       .document(currentOnlineUserId)
  //       .collection("userFollowings")
  //       .document(widget.userProfileId)
  //       .get()
  //       .then((document) {
  //     if (document.exists) {
  //       document.reference.delete();
  //     }
  //   });

  //   activityFeedReference
  //       .document(widget.userProfileId)
  //       .collection("feedItems")
  //       .document(currentOnlineUserId)
  //       .get()
  //       .then((document) {
  //     if (document.exists) {
  //       document.reference.delete();
  //     }
  //   });
  // }

  // controlFollowUser() {
  //   setState(() {
  //     following = true;
  //   });

  //   followersReference
  //       .document(widget.userProfileId)
  //       .collection("userFollowers")
  //       .document(currentOnlineUserId)
  //       .setData({});

  //   followingsReference
  //       .document(currentOnlineUserId)
  //       .collection("userFollowings")
  //       .document(widget.userProfileId)
  //       .setData({});

  //   activityFeedReference
  //       .document(widget.userProfileId)
  //       .collection("feedItems")
  //       .document(currentOnlineUserId)
  //       .setData({
  //     "type": "follow",
  //     "ownerId": widget.userProfileId,
  //     "username": currentUser.username,
  //     "timestamp": DateTime.now(),
  //     "userProfileImg": currentUser.url,
  //     "userId": currentOnlineUserId,
  //   });
  // }

  // Container createButtonTitleAndFunction(
  //     {String title, Function performFunction}) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 3.0),
  //     child: FlatButton(
  //         onPressed: performFunction,
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.4,
  //           height: MediaQuery.of(context).size.height * 0.04,
  //           child: Text(
  //             title,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: following ? Colors.white : Colors.black,
  //                 fontSize: 16.0),
  //           ),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: following ? Colors.purple : Colors.white,
  //             border: Border.all(color: Colors.black),
  //             borderRadius: BorderRadius.circular(6.0),
  //           ),
  //         )),
  //   );
  // }

  // editUserProfile() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  // }

  // logOutUser() async {
  //   await gSignIn.signOut();
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  // }

  @override
  Widget build(BuildContext context) {
    // bool ownProfile = currentOnlineUserId == widget.userProfileId;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          actions: <Widget>[
            // ownProfile
            //     ? IconButton(
            //         icon: Icon(Icons.exit_to_app), onPressed:
            //         logOutUser
            //         )
            //     : Text("")
          ],
        ),
        body: ListView(
          children: <Widget>[
            // createProfileTopView(),
            Divider(),
            // createListGridPost(),
            Divider(
              height: 0.0,
            ),
            // displayProfilePost(),
          ],
        ));
  }

  // displayProfilePost() {
  //   if (loading) {
  //     return circularProgress();
  //   } else if (postsList.isEmpty) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(top: 40.0),
  //             child: Icon(
  //               Icons.photo_library,
  //               size: 100.0,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: Text(
  //               "No Posts",
  //               style: TextStyle(
  //                 fontSize: 30.0,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if (postOrientation == 0) {
  //     List<GridTile> gridTilesList = [];
  //     postsList.forEach((eachPost) {
  //       gridTilesList.add(GridTile(
  //         child: PostTile(eachPost),
  //       ));
  //     });
  //     return GridView.count(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1.0,
  //       mainAxisSpacing: 1.5,
  //       crossAxisSpacing: 1.5,
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       children: gridTilesList,
  //     );
  //   } else if (postOrientation == 1) {
  //     return Column(
  //       children: postsList,
  //     );
  //   }
  // }

  // getAllProfilePosts() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   QuerySnapshot querySnapshot = await postsReference
  //       .document(widget.userProfileId)
  //       .collection("usersPosts")
  //       .orderBy("timestamp", descending: true)
  //       .getDocuments();
  //   setState(() {
  //     loading = false;
  //     countPost = querySnapshot.documents.length;
  //     postsList = querySnapshot.documents
  //         .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
  //         .toList();
  //   });
  // }

  // createListGridPost() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       IconButton(
  //           icon: Icon(Icons.grid_on), onPressed: () => setOrientation(0)),
  //       IconButton(icon: Icon(Icons.list), onPressed: () => setOrientation(1)),
  //     ],
  //   );
  // }

  // setOrientation(int orientation) {
  //   setState(() {
  //     this.postOrientation = orientation;
  //   });
  // }
}
