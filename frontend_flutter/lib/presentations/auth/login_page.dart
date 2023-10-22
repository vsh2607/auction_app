import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/presentations/user/user_home_page.dart';
import 'package:frontend_flutter/service/api_config.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_logo.dart';
import 'package:frontend_flutter/widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormBuilderState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginFailed) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Gagal'),
              content: Text(state.message),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        }

        if (state is AuthLoginSuccessAdmin) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminHomePage(status: 1)));
        }

        if (state is AuthLoginSuccessUser) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UserHomePage()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: AppConstants.quarterScreenHeight(context),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [AppLogo()]),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: AppLargeText(
                            text: "Login",
                            color: AppColors.mainColor,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: FormBuilder(
                        key: _formLoginKey,
                        child: Column(children: [
                          FormBuilderTextField(
                            name: "email",
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email"),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email()
                            ]),
                          ),
                          const SizedBox(height: 10),
                          FormBuilderTextField(
                              name: "password",
                              obscureText: _isObscured ? true : false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                      icon: Icon(_isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off))),
                              validator: (value) {
                                if (_formLoginKey.currentState
                                        ?.fields["password"]?.value ==
                                    "") {
                                  return "This field cannot be empty.";
                                } else if (_formLoginKey
                                        .currentState!.fields["password"]!.value
                                        .toString()
                                        .length <
                                    6) {
                                  return "Password minimal 6 karakter.";
                                } else {
                                  return null;
                                }
                              })
                        ]),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const AppText(
                              text: 'Belum Punya Akun?',
                              size: 15,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              },
                              child: const AppText(
                                text: "Register",
                                size: 15,
                                color: AppColors.mainColor,
                              ),
                            )
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 50, bottom: 10, left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            FormBuilderState? formBuilderState =
                                _formLoginKey.currentState;

                            String? email = _formLoginKey
                                .currentState?.fields["email"]?.value;
                            String? password = _formLoginKey
                                .currentState?.fields["password"]?.value;
                            if (formBuilderState!.saveAndValidate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthLoginSubmit(
                                      email: email!, password: password!));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainColor,
                          ),
                          child: Text("Masuk")),
                    )
                  ],
                ),
              ),
              if (state is AuthLoading)
                Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: AppColors.mainColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.3)),
                    ))),
            ],
          ),
        );
      },
    );
  }
}
