import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  String baseUrl;
  String productImageUrl;

  ApiConfig({
    this.baseUrl = "https://humbly-logical-lemming.ngrok-free.app",
    this.productImageUrl =
        "https://humbly-logical-lemming.ngrok-free.app/storage/product_images",
  });

  Future<String?> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("user_token");
  }

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

  Future<int> loginWithToken() async {
    final apiUrl = "$baseUrl/api/auth/login-token";
    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept': 'application/json'
    });
    return response.statusCode;
  }

  Stream<Map<String, dynamic>> fetchAllProductStream(int status) async* {
    final apiUrl = "$baseUrl/api/product/get-products/$status";
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept': 'application/json'
    });
    yield json.decode(response.body) as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>> fetchAllUserStream() async* {
    final apiUrl = "$baseUrl/api/user/get-all-users";
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept': 'application/json'
    });
    yield json.decode(response.body) as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>> fetchBiddersByProductIdStream(int? productId) async*{
    final apiUrl = "$baseUrl/api/bidding/get-bidders-by-productid/$productId";
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept': 'application/json'
    });
    yield json.decode(response.body) as Map<String, dynamic>;

  }

  Stream<Map<String, dynamic>> fetchProductDetailStream(int? productId) async* {
    final apiUrl = "$baseUrl/api/product/get-product/$productId";
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await getToken()}',
      'Accept': 'application/json'
    });
    yield json.decode(response.body) as Map<String, dynamic>;
  }

  String fetchImageProduct(String imageName) {
    return "$productImageUrl/$imageName";
  }

  Future<Map<String, dynamic>> fetchDetailProduct(
      int productId, String token) async {
    final apiUrl = "$baseUrl/api/product/get-product/$productId";
    final response = await http
        .get(Uri.parse(apiUrl), headers: {'Authorization': 'Bearer $token'});
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchBidders(int productId, String token) async {
    final apiUrl = "$baseUrl/api/bidding/get-bidders-by-productid/$productId";
    final response = await http
        .get(Uri.parse(apiUrl), headers: {'Authorization': 'Bearer $token'});
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchDetailProductBidders(
      int productId, String token) async {
    final apiUrl = "$baseUrl/api/bidding/get-bidders-by-productid/$productId";
    final response = await http
        .get(Uri.parse(apiUrl), headers: {'Authorization': 'Bearer $token'});
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchProductUnits() async {
    final apiUrl = "$baseUrl/api/get-product-unit";
    final response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> addNewBidding(
      String productId, String userId, String bidAmount, String token) async {
    final apiUrl = "$baseUrl/api/bidding/add-bidding";
    final Map<String, dynamic> data = {
      'product_id': productId,
      'user_id': userId,
      'bidding_amount': bidAmount
    };
    final response = await http.post(Uri.parse(apiUrl),
        body: data, headers: {'Authorization': 'Bearer $token'});
    print(response.body);
    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> addNewProduct(
      String productName,
      File? productImage,
      int productSize,
      String productUnit,
      String? productDescription,
      int productInitialPrice,
      String productDeadline,
      String? token) async {
    final apiUrl = "$baseUrl/api/product/add-product";
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';

    if (productImage != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
            'product_img_path', productImage!.readAsBytesSync(),
            filename: productImage.path),
      );
    }

    request.fields["product_name"] = productName;
    request.fields["product_size"] = productSize.toString();
    request.fields["product_unit"] = productUnit;
    request.fields["product_description"] = productDescription!;
    request.fields["product_initial_price"] = productInitialPrice.toString();
    request.fields["product_ddl"] = productDeadline;
    final response = await http.Response.fromStream(await request.send());
    print("response status code ${response.statusCode}");
    return json.decode(response.body);
  }
}
