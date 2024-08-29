import 'package:flutter/material.dart';
import 'package:flutter_app/page/my_home_page.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(
          user: User(
            id: '', // Unique user ID
            fullName: '', // Corrected from `username`
            email: '',
            password: '',
          ),
        ),
      },
    );
  }
}
