import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_flutter/blocs/product/bloc/product_bloc.dart';
import 'package:frontend_flutter/constants.dart';
import 'package:frontend_flutter/presentations/product/product_list_page.dart';
import 'package:frontend_flutter/widgets/admin_bottom_nav.dart';
import 'package:frontend_flutter/widgets/app_large_text.dart';
import 'package:frontend_flutter/widgets/app_search_box.dart';
import 'package:frontend_flutter/widgets/app_text.dart';

class AdminHomePage extends StatefulWidget {
  final int status;
  const AdminHomePage({super.key, required this.status});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final tabs = [
    // ProductListPage(status: 1),
    // ProductListPage(status: 0),
    // ProductListPage(status: 0),
    Center(child: ProductListPage(status: 1)),
    Center(child: ProductListPage(status: 0)),
    Center(child: ProductListPage(status: 0)),
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      floatingActionButton: (widget.status == 1 || widget.status == 0)
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
              backgroundColor: AppColors.mainColor,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.mainColor.withOpacity(0.9),
        unselectedItemColor: Colors.white.withOpacity(0.5),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_bottom),
            label: 'Sedang Berjalan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Telah Selesai',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Daftar User',
          ),
        ],
        onTap: (index) {
          print(index);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
