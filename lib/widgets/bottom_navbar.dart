import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index);
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/orders',
              (route) => false,
            );
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/categories',
              (route) => false,
            );
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/profile',
              (route) => false,
            );
            break;
        }
      },
      selectedItemColor: Colors.red,
      unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Orderan'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kategori'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
