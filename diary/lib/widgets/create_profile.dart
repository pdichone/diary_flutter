import 'package:diary/model/user.dart';
import 'package:diary/widgets/update_user_profile_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget createProfile(BuildContext context, List<MUser?> list, User? authUser) {
  TextEditingController _displayNameTextController =
      TextEditingController(text: list[0]!.displayName);
  TextEditingController _avatarTextController =
      TextEditingController(text: list[0]!.avatarUrl);

  Widget? widget;

  for (var user in list) {
    widget = Container(
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user!.avatarUrl!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfileDialog(
                          user: user,
                          avatarUrlTextController: _avatarTextController,
                          displayNameTextController: _displayNameTextController,
                        );
                      },
                    );
                  },
                ),
              ),
              Text(
                user.displayName!.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((value) => Navigator.pushNamed(context, '/login'));
                },
                tooltip: 'Signout',
                icon: Icon(
                  Icons.login_outlined,
                  size: 19,
                  color: Colors.redAccent,
                )),
          ),
        ],
      ),
    );
  }
  return widget!;
}
