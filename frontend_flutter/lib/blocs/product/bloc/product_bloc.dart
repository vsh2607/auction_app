import 'package:bloc/bloc.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
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
}
