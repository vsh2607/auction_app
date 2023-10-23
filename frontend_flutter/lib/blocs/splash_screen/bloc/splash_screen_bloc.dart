import 'package:bloc/bloc.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitial()) {
    on<SplashScreenEvent>((event, emit) {});
    on<SplashScreenCheckPreference>((event, emit) async {
      await Future.delayed(Duration(seconds: 4));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get("user_token") != null) {
        final loginStatusCode = await ApiConfig()
            .loginWithToken();
        if (loginStatusCode == 401) {
          AuthBloc().logoutUser();
          emit(HasNotLogin());
        } else {
          if (prefs.getString("user_type") == "admin") {
            emit(HasLoginAdmin());
          } else {
            emit(HasLoginUser());
          }
        }
      } else {
        emit(HasNotLogin());
      }
    });
  }
}
