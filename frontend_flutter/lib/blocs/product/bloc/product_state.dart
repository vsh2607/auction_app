part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class AddProductSuccess extends ProductState {}

class AddProductFailed extends ProductState {
  final String message;
  AddProductFailed({required this.message});
}
