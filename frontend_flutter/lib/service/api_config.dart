import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConfig {
  String baseUrl;
  String productImageUrl;

  ApiConfig({
    this.baseUrl = "https://d4dc-103-28-112-109.ngrok-free.app",
    this.productImageUrl =
        "https://d4dc-103-28-112-109.ngrok-free.app/storage/product_images",
  });

  Future<Map<String, dynamic>> login(String email, String password) async {
    final apiUrl = "$baseUrl/api/auth/login";
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(Uri.parse(apiUrl), body: data);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String name, String email,
      String no_telp, String password, String passwordConfirmation) async {
    final apiUrl = "$baseUrl/api/auth/register";
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'no_telp': no_telp,
      'password': password,
      'password_confirmation': passwordConfirmation
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );
    print(response.body);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fethAllProduct(int status, String? token) async {
    //0 finished, 1 onprogress
    final apiUrl = "$baseUrl/api/product/get-products/$status";
    final response = await http
        .get(Uri.parse(apiUrl), headers: {'Authorization': 'Bearer $token'});
    return json.decode(response.body);
  }

  String fetchImageProduct(String imageName) {
    return "$productImageUrl/$imageName";
  }
}
