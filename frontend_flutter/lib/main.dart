import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/blocs/bidding/bloc/bidding_bloc.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/blocs/splash_screen/bloc/splash_screen_bloc.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import 'package:frontend_flutter/presentations/auth/register_page.dart';
import 'package:frontend_flutter/presentations/splash_screen_page.dart';
import 'package:frontend_flutter/presentations/user/user_home_page.dart';
import 'package:frontend_flutter/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(create: (context) => BiddingBloc()),
        BlocProvider(create: (context) => SplashScreenBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: splashScreenRoute,
        routes: {
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          adminHomeRoute: (context) => const AdminHomePage(status: 1),
          userHomeRoute: (context) => const UserHomePage(),
          splashScreenRoute: (context) => const SplashScreenPage(),
        },
      ),
    );
  }
}
