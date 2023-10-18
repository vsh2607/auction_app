import 'package:bloc/bloc.dart';
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
        if (prefs.get("user_type") == "admin") {
          print("Admin");
          emit(HasLoginAdmin());
        } else {
          print("User");
          emit(HasLoginUser());
        }
      } else {
        emit(HasNotLogin());
      }
    });
  }
}
