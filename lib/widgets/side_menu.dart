import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';

class SideMenu extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;

  SideMenu({
    required this.username,
    required this.email,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username != '' ? username : 'N/A'),
            accountEmail: Text(email != '' ? email : 'N/A'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: profileImageUrl != '' 
                ? NetworkImage(profileImageUrl) as ImageProvider
                : AssetImage('assets/default_profile.png') as ImageProvider,
              child: profileImageUrl == '' ? Icon(Icons.person) : null,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}