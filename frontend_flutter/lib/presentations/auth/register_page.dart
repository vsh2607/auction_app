import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_logo.dart';
import 'package:frontend_flutter/widgets/app_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formLoginKey = GlobalKey<FormBuilderState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.pushNamed(context, "/login");
        } else if (state is AuthRegisterEmailFailed) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Gagal'),
              content: Text(state.message!),
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
                            text: "Register",
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
                            name: "nama",
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                labelText: "Nama Lengkap"),
                            validator: FormBuilderValidators.required(),
                          ),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                            name: "no_telp",
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Nomor Hp"),
                            validator: FormBuilderValidators.required(),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                            name: "email",
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email"),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
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
                                String? password = _formLoginKey
                                    .currentState?.fields["password"]?.value;
                                if (_formLoginKey.currentState
                                        ?.fields["password"]?.value ==
                                    "") {
                                  return "This field cannot be empty.";
                                } else if (password.toString().length < 6) {
                                  return "Password minimal 6 karakter.";
                                } else {
                                  return null;
                                }
                              }),
                          SizedBox(height: 20),
                          FormBuilderTextField(
                              name: "password_confirmation",
                              obscureText: _isObscured ? true : false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Konfirmasi Password",
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
                                String? password = _formLoginKey
                                    .currentState?.fields["password"]?.value;

                                String? password_confirmation = _formLoginKey
                                    .currentState
                                    ?.fields["password_confirmation"]
                                    ?.value;
                                if (password == "") {
                                  return "This field cannot be empty.";
                                } else if (password.toString().length < 6) {
                                  return "Password minimal 6 karakter.";
                                } else if (password != password_confirmation) {
                                  return "Konfirmasi password tidak sesuai";
                                } else {
                                  return null;
                                }
                              }),
                        ]),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const AppText(
                              text: 'Sudah Punya Akun?',
                              size: 15,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: const AppText(
                                text: "Login",
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
                            String? name =
                                formBuilderState?.fields["nama"]?.value;
                            String? noTelp =
                                formBuilderState?.fields["no_telp"]?.value;
                            String? email =
                                formBuilderState?.fields["email"]?.value;
                            String? password =
                                formBuilderState?.fields["password"]?.value;
                            String? passwordConfirmation = formBuilderState
                                ?.fields["password_confirmation"]?.value;
                            if (formBuilderState!.saveAndValidate()) {
                              formBuilderState.reset();
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthRegisterSubmit(
                                      name: name!,
                                      no_telp: noTelp!,
                                      email: email!,
                                      password: password!,
                                      passwordConfirmation:
                                          passwordConfirmation!));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainColor,
                          ),
                          child: Text("Daftar")),
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
