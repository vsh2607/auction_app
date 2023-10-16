import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import 'package:frontend_flutter/presentations/auth/register_page.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: adminHomeRoute,
        routes: {
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          adminHomeRoute: (context) => const AdminHomePage(status: 1),
        },
      ),
    );
  }
}
