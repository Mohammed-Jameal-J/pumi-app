import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "https://pumiroots.com/wp-json";

  static Future<String?> login(String username, String password) async {

    final response = await http.post(
      Uri.parse("$baseUrl/jwt-auth/v1/token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }

    return null;
  }

  static Future<List<dynamic>> getProducts(String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl/wc/v3/products"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }
}
