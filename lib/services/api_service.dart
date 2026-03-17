import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/home_page.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com/products';

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
}
