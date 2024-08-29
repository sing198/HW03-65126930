import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/widgets/side_menu.dart';
import 'package:flutter_app/page/userform.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({required this.user, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  bool _isLoggedIn = false; // ตัวแปรสถานะเพื่อควบคุมการแสดงผล

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // เรียกตรวจสอบสถานะการล็อกอิน
    _loadCurrentUser(); // โหลดข้อมูลผู้ใช้ที่เข้าสู่ระบบ
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool('isLogin') ?? false;
    setState(() {
      _isLoggedIn = loginStatus;
    });
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      users.add(widget.user); // เพิ่มผู้ใช้ที่เข้าสู่ระบบในรายการ
      _isLoggedIn = true; // อัปเดตสถานะให้เป็นล็อกอินแล้ว
    });
  }

  void _addOrUpdateUser(User newUser) {
    setState(() {
      int index = users.indexWhere((user) => user.id == newUser.id);
      if (index != -1) {
        users[index] = newUser;
      } else {
        users.add(newUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: _isLoggedIn // แสดง SideMenu เมื่อมีการล็อกอิน
          ? SideMenu(
              username: widget.user.fullName,
              email: widget.user.email,
              profileImageUrl: "",
            )
          : null, // ซ่อน SideMenu ถ้ายังไม่ได้ล็อกอิน
      body: _isLoggedIn // เช็คสถานะล็อกอินก่อนแสดงข้อมูล
          ? ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(users[index].fullName),
                    subtitle: Text(users[index].email),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        User? updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserFormPage(user: users[index]),
                          ),
                        );
                        if (updatedUser != null) {
                          _addOrUpdateUser(updatedUser);
                        }
                      },
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('Please login to view users.'), // ข้อความที่จะแสดงถ้ายังไม่ได้ล็อกอิน
            ),
      floatingActionButton: _isLoggedIn // แสดง FloatingActionButton เมื่อมีการล็อกอิน
          ? FloatingActionButton(
              onPressed: () async {
                User? newUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserFormPage(),
                  ),
                );
                if (newUser != null) {
                  _addOrUpdateUser(newUser);
                }
              },
              child: const Icon(Icons.add),
            )
          : null, // ไม่แสดง FloatingActionButton ถ้ายังไม่ได้ล็อกอิน
    );
  }
}