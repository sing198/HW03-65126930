import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Configure {
  static String server = "localhost:3001";  // ปรับเป็นที่อยู่เซิร์ฟเวอร์ของคุณ
  static User? login;  // เก็บข้อมูลผู้ใช้ที่ล็อกอินเข้ามา
}

class AuthService {
  // ฟังก์ชันสำหรับล็อกอิน
  static Future<void> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('http://${Configure.server}/users?username=$username&password=$password'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = json.decode(response.body);
      if (users.isNotEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', 'user_logged_in');  // เก็บสถานะการล็อกอิน
        print('Login Success: ${users[0]}');
        Configure.login = User.fromJson(users[0]);  // เก็บข้อมูลผู้ใช้ที่ล็อกอิน
      } else {
        print('Login Failed: User not found');
      }
    } else {
      print('Login Failed: Server error');
    }
  }

  // ฟังก์ชันสำหรับตรวจสอบสถานะการล็อกอิน
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // ฟังก์ชันสำหรับออกจากระบบ
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Configure.login = null;  // ล้างข้อมูลผู้ใช้ที่ล็อกอิน
  }

  // ฟังก์ชันสำหรับดึงข้อมูลผู้ใช้ทั้งหมด
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://${Configure.server}/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // ฟังก์ชันสำหรับเพิ่มผู้ใช้ใหม่
  static Future<void> addUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://${Configure.server}/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('User added successfully');
    } else {
      throw Exception('Failed to add user');
    }
  }
}
