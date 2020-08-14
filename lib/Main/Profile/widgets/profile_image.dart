import 'package:agni_app/providers/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key key,
    @required this.loadedUser,
  }) : super(key: key);

  final User loadedUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
          border: Border.all(
            color: Colors.orange,
            width: 5.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55.0),
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                ),
              ]),
          child: Hero(
            tag: 'profile',
            child: CircleAvatar(
                radius: 40,
                backgroundImage: loadedUser.profileUrl == null
                    ? AssetImage("assets/images/profile-image.png")
                    : CachedNetworkImageProvider(
                        loadedUser.profileUrl,
                      )),
          ),
        ),
      ),
    );
  }
}
