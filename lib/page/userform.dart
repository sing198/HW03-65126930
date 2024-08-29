import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // สำหรับการแปลงข้อมูลเป็น JSON
import 'dart:math';


class ApiService {
  final String apiUrl = "http://localhost:3001/users";

  // ฟังก์ชันสำหรับ POST ข้อมูล (สร้างข้อมูลใหม่)
  Future<void> createPost(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        print("Data successfully pushed to the server.");
      } else {
        print("Failed to push data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // ฟังก์ชันสำหรับ UPDATE ข้อมูล (แก้ไขข้อมูลที่มีอยู่)
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
  try {
    final response = await http.put(
      Uri.parse('http://localhost:3001/users/$id'), // ใช้ /users แทน /user
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print("Data successfully updated.");
    } else {
      print("Failed to update data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}

  // ฟังก์ชันสำหรับ DELETE ข้อมูล
  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );
      if (response.statusCode == 200) {
        print("Data successfully deleted.");
      } else {
        print("Failed to delete data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
class UserFormPage extends StatefulWidget {
  final User? user;

  UserFormPage({this.user});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _fullNameController.text = widget.user!.fullName;
      _emailController.text = widget.user!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Fullname',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_fullNameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  
                  User newUser = User(
                    id: widget.user?.id ?? String.fromCharCodes(List.generate(6, (index) => Random().nextInt(36).toRadixString(36).codeUnitAt(0))),
                    fullName: _fullNameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (widget.user == null) {
                    // Create new user
                    apiService.createPost(newUser.toJson());
                  } else {
                    // Update existing user
                    apiService.updateUser(widget.user!.id, newUser.toJson());
                  }

                  Navigator.pop(context, newUser);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields")),
                  );
                }
              },
              child: Text(widget.user == null ? 'Save' : 'Update'),
            ),
            if (widget.user != null) ...[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Confirm delete action
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Delete"),
                        content: Text("Are you sure you want to delete this user?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              apiService.deleteUser(widget.user!.id);
                              Navigator.of(context).pop();  // Close dialog
                              Navigator.of(context).pop();  // Return to previous page
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}