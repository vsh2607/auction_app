import 'package:flutter/material.dart';
import 'package:frontend_flutter/presentations/admin/admin_home_page.dart';
import 'package:frontend_flutter/presentations/auth/login_page.dart';
import '../constants.dart';

class AdminBottomNav extends StatefulWidget {
  final int currentIndex; // Current selected tab index
  final Function(int)
      onTabTapped; // Callback function to notify the parent widget

  const AdminBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  _AdminBottomNavState createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
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
        setState(() {
          widget.onTabTapped(index);
        });
      },
    );
  }
}
