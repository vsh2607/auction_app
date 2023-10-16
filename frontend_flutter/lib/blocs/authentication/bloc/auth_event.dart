part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthLoginSubmit extends AuthEvent {
  final String email;
  final String password;

  AuthLoginSubmit({required this.email, required this.password});
}

class AuthRegisterSubmit extends AuthEvent {
  final String name;
  final String no_telp;
  final String email;
  final String password;
  final String passwordConfirmation;

  AuthRegisterSubmit(
      {required this.name,
      required this.no_telp,
      required this.email,
      required this.password,
      required this.passwordConfirmation});
}
