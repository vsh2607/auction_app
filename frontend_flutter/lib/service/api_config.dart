import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  String baseUrl;
  String productImageUrl;

  ApiConfig({
    this.baseUrl = "https://5a83-140-213-176-105.ngrok-free.app",
    this.productImageUrl = "xx",
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

  // Stream<Map<String, dynamic>> fetchAllActiveProduct() {
  //   return null;
  // }
}
