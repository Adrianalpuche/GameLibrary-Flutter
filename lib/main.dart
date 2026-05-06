import 'package:flutter/material.dart';
import 'package:game_library/presentation/screens/home/home_screen.dart';
import 'package:game_library/presentation/screens/search/search_screen.dart';
import 'package:game_library/presentation/widgets/botom_navigation.dart';

void main() => runApp( MyApp()); 


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int actualScreen = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    Container()
  ];


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Game',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: _screens[actualScreen],
        bottomNavigationBar: BottomNavigation(actualScreen: actualScreen, onItemTapped: onItemTapped)
      ),
    );
  }


    void onItemTapped(int index) {
    setState(() {
      actualScreen = index;
    });
  }
}