import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/home_page.dart';

class User {//blueprint to store user data
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime joinDate;

  User({//consturctor with named parameters
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.joinDate,
  });
}

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';
  static const String usersUrl = 'https://dummyjson.com/users';
  static const String loginUrl = 'https://dummyjson.com/auth/login';
  // Fetch products from the API
  static Future<List<ProductItem>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> products = jsonData['products'];

        // Map API response to ProductItem objects
        // Taking first 12 products as per your requirement
        return products.take(12).map((product) {
          return ProductItem(
            name: product['title'] ?? 'Unknown',
            price: (product['price'] ?? 0).toDouble(),
          );
        }).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch user from API
  static Future<User> fetchUser() async {
    try {
      final response = await http.get(Uri.parse('$usersUrl/1'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User(
          id: jsonData['id'] ?? 0,
          email: jsonData['email'] ?? 'N/A',
          firstName: jsonData['firstName'] ?? 'John',
          lastName: jsonData['lastName'] ?? 'Doe',
          joinDate: DateTime(2020, 5, 15),
        );
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Login with username and password
  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }
}
