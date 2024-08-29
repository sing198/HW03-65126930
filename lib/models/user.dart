import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String fullName;
  final String email;
  final String password;

  User({required this.id, required this.fullName, required this.email, required this.password});

  // Factory method to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullName,
      'email': email,
      'password': password,
    };
  }

  // Method to parse a JSON string and convert it to a List<User>
  static List<User> usersFromJson(String str) {
    final jsonData = json.decode(str);
    return List<User>.from(jsonData.map((x) => User.fromJson(x)));
  }

  // Fetch all users from the backend or local storage
  static Future<List<User>> fetchAllUsers() async {
    final url = Uri.http('localhost:3001', '/users'); // Update with actual API endpoint
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return usersFromJson(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Save all users to the backend or local storage (create new users)
  static Future<void> saveAllUsers(List<User> users) async {
    final url = Uri.http('localhost:3001', '/users'); // Ensure this is correct

    for (User user in users) {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      // Log the request details
      print('Request URL: $url');
      print('Request Body: ${jsonEncode(user.toJson())}');

      // Log the response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to save user ${user.id}');
      }
    }
  }

  // Update user
  static Future<void> updateUser(User user) async {
    final url = Uri.http('localhost:3001', '/users/${user.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user ${user.id}');
    }
  }

  // Delete user
  static Future<void> deleteUser(String id) async {
    final url = Uri.http('localhost:3001', '/users/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user $id');
    }
  }
}