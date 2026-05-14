import 'package:flutter/material.dart';


class BottomNavigation extends StatelessWidget {
  final int actualScreen;
  final Function(int) onItemTapped;
  const BottomNavigation({super.key, required this.actualScreen, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: actualScreen,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_max_outlined)
            ,
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create_outlined),
          label: 'Crear',
        )
        
      ],
    );
  }
}