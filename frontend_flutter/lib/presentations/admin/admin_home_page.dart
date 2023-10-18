import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_flutter/blocs/authentication/bloc/auth_bloc.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/admin/admin_add_product_page.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import 'package:frontend_flutter/presentations/product/product_list_page.dart';
import 'package:frontend_flutter/widgets/admin_bottom_nav.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_search_box.dart';
import 'package:frontend_flutter/widgets/app_text.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class AdminHomePage extends StatefulWidget {
  final int status;
  const AdminHomePage({super.key, required this.status});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
                    AuthBloc().logoutUser();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(Icons.logout),
                  color: Colors.white,
                )
              ],
              backgroundColor: AppColors.mainColor,
              bottom: const TabBar(indicatorColor: Colors.white, tabs: [
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
            body: const TabBarView(children: [
              ProductListPage(status: 1),
              ProductListPage(status: 0),
              Center(child: Text("Daftar User"))
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminAddProductPage()));
              },
              child: Icon(Icons.add),
              backgroundColor: AppColors.mainColor,
            )));
  }
}
