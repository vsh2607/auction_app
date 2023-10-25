import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/blocs/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/presentations/user/user_home_page.dart';
import 'package:frontend_flutter/widgets/app_logo.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    BlocProvider.of<SplashScreenBloc>(context).add(SplashScreenCheckPreference());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) async {
          if (state is HasNotLogin) {
            Navigator.pushReplacementNamed(context, "/login");
          } else if (state is HasLoginAdmin) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminHomePage(status: 1,)));
          } else if (state is HasLoginUser) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const UserHomePage()));
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(),
                const SizedBox(height: 24.0),
                LinearProgressIndicator(
                  color: AppColors.mainColor,
                  backgroundColor: Colors.white.withOpacity(0.3),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
