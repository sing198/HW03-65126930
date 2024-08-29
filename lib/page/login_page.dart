import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/page/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ฟังก์ชันสำหรับเก็บสถานะการล็อกอิน
  Future<void> saveLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', status);
  }

  Future<void> login(BuildContext context) async {
    var params = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    var url = Uri.http('localhost:3001', '/users', params);
    var resp = await http.get(url);

    print(resp.body);

    // Call the static usersFromJson method from the User class
    List<User> loginResult = User.usersFromJson(resp.body);
    print(loginResult.length);

    if (loginResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username or password invalid")),
      );
    } else {
      // เมื่อผู้ใช้ล็อกอินสำเร็จ เก็บสถานะล็อกอินใน SharedPreferences
      await saveLoginStatus(true);

      // ไปยังหน้า HomePage หลังล็อกอินสำเร็จ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: loginResult[0])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
