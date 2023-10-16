import 'package:flutter/material.dart';
import '../constants.dart';

class UserBottomNav extends StatefulWidget {
  const UserBottomNav({Key? key}) : super(key: key);

  @override
  _UserBottomNavState createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
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
          icon: Icon(Icons.explore),
          label: 'Cari Barang',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_note),
          label: 'Tawaran Saya',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Barang Saya',
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
