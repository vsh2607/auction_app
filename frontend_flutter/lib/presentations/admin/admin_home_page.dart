import 'package:flutter/material.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_add_product_page.dart';
import 'package:frontend_flutter/presentations/admin/admin_user_list_page.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import 'package:frontend_flutter/presentations/product/product_list_page.dart';
import 'package:frontend_flutter/pusher.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_text.dart';

class AdminHomePage extends StatefulWidget {
  final int status;
  const AdminHomePage({super.key, required this.status});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
              bottom: const TabBar(indicatorColor: Colors.white, tabs: [
                Tab(
                  child: Center(
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
                ),
                Tab(
                  child: Center(
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
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 14.0,
                      ),
                      SizedBox(width: 8),
                      AppText(
                        text: "Daftar User",
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            body: TabBarView(children: [
              ProductListPage(
                status: 1,
              ),
              ProductListPage(
                status: 0,
              ),
              AdminUserListPage()
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminAddProductPage()));
              },
              child: Icon(Icons.add),
              backgroundColor: AppColors.mainColor,
            )));
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
