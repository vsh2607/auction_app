import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
    on<AddProduct>((event, emit) async {
      emit(ProductLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("user_token");
      if (event.productImage == null) {
        emit(AddProductFailed(message: "Foto Produk belum diinputkan"));
      } else {
        final response = await ApiConfig().addNewProduct(
            event.productName,
            event.productImage,
            event.productSize,
            event.productUnit,
            event.productDescription,
            event.productInitialPrice,
            event.productDeadline,
            token);

        if (response["data"] != null) {
          emit(AddProductSuccess());
        } else {
          emit(AddProductFailed(message: response["message"]));
        }
      }
    });
  }

  Future<Map<String, dynamic>> fethAllProduct(int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    final response = await ApiConfig().fethAllProduct(status, token);
    return response;
  }

  String fetchImageProduct(String imageName) {
    return ApiConfig().fetchImageProduct(imageName);
  }

  Future<List> fetchProductUnits() async {
    final response = await ApiConfig().fetchProductUnits();
    List<dynamic> results = response["data"];
    List<dynamic> unit = [];
    for (var result in results) {
      final resultMap = result as Map<String, dynamic>;
      unit.add(resultMap["unit_name"]);
    }
    return unit;
  }

  Future<Map<String, dynamic>> fetchDetailProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    final response = await ApiConfig().fetchDetailProduct(productId, token!);
    return response;
  }

  Future<Map<String, dynamic>> fetchDetailProductBidders(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    final response =
        await ApiConfig().fetchDetailProductBidders(productId, token!);
    return response;
  }
}
