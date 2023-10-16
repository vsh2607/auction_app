part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccessUser extends AuthState {}

class AuthLoginSuccessAdmin extends AuthState {}

class AuthLoginFailed extends AuthState {
  final String message;
  AuthLoginFailed({required this.message});
}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterEmailFailed extends AuthState {
  final String message;
  AuthRegisterEmailFailed({required this.message});
}
