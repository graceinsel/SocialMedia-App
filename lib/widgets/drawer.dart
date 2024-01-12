import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/auth/register/register.dart';
import 'package:social_media_app/utils/firebase.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          // TODO(UI): change the user name and email to stateful fields.
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
            // TODO(UI): remove shadow of the drawer.
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade200, // Set the desired background color
            ),
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () async {
              await firebaseAuth.signOut();
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => Register(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
