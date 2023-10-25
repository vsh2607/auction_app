import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import 'package:frontend_flutter/presentations/product/product_list_page.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: AppLargeText(
              text: "SiLaHap",
              size: 17,
              color: Colors.white,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showMyDialog();
                },
                icon: Icon(Icons.logout),
                color: Colors.white,
              )
            ],
            backgroundColor: AppColors.mainColor,
            bottom: TabBar(indicatorColor: Colors.white, tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_bottom,
                      color: Colors.white,
                      size: 14.0,
                    ),
                    SizedBox(width: 8),
                    AppText(
                      text: "Berjalan",
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14.0,
                    ),
                    SizedBox(width: 8),
                    AppText(
                      text: "Selesai",
                      size: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          body: TabBarView(children: [
            ProductListPage(status: 1),
            ProductListPage(status: 0),
          ]),
        ));
  }

  Future<dynamic> showMyDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Apakah Anda Ingin Keluar?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            style: TextButton.styleFrom(primary: Colors.grey),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Keluar'),
            style: TextButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              AuthBloc().logoutUser();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
          ),
        ],
      ),
    );
  }
}
