part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class AddProduct extends ProductEvent {
  String productName;
  File? productImage;
  int productSize;
  String productUnit;
  String? productDescription;
  int productInitialPrice;
  String productDeadline;

  AddProduct({
    required this.productName,
    this.productImage,
    required this.productSize,
    required this.productUnit,
    this.productDescription,
    required this.productDeadline,
    required this.productInitialPrice,
  });
}
