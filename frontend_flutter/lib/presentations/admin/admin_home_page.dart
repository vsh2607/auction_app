import 'package:flutter/material.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/widgets/admin_bottom_nav.dart';
import 'package:frontend_flutter/widgets/app_search_box.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: AppBuildSearchBox()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/admin-add-product");
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.mainColor,
      ),
      bottomNavigationBar: AdminBottomNav(),
    );
  }
}
