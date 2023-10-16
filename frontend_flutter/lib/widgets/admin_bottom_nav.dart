import 'package:flutter/material.dart';
import '../constants.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({Key? key}) : super(key: key);

  @override
  _AdminBottomNavState createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      unselectedItemColor: AppColors.mainColor,
      selectedItemColor: AppColors.mainColor,
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
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
