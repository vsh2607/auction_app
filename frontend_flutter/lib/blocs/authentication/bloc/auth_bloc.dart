import 'package:bloc/bloc.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<AuthLoginSubmit>(((event, emit) async {
      emit(AuthLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await ApiConfig().login(event.email, event.password);
      final responseData = response["data"];
      print(responseData);
      final responseDataToken = responseData["token"];
      final responseMessage = response["message"];
      if (responseData != null) {
        final responseDataUser = responseData["user"];
        final responseDataUserType = responseDataUser["type"];
        prefs.setInt('user_id', responseDataUser["id"]);
        prefs.setString('user_token', responseDataToken);
        if (responseDataUserType == "admin") {
          emit(AuthLoginSuccessAdmin());
        } else {
          emit(AuthLoginSuccessUser());
        }
      } else {
        emit(AuthLoginFailed(message: responseMessage));
      }
    }));

    on<AuthRegisterSubmit>((event, emit) async {
      emit(AuthLoading());
      final response = await ApiConfig().register(event.name, event.email,
          event.no_telp, event.password, event.passwordConfirmation);
      if (response["errors"] != null) {
        emit(AuthRegisterEmailFailed(message: "Email telah terdaftar"));
      } else {
        emit(AuthRegisterSuccess());
      }
    });
  }
}
