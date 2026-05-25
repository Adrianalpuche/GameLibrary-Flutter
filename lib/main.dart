import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_library/config/Theme/Colors.dart';
import 'package:game_library/presentation/screens/form/create_screen.dart';
import 'package:game_library/presentation/screens/home/home_screen.dart';
import 'package:game_library/presentation/widgets/botom_navigation.dart';
import 'package:game_library/provider/games_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 

  int actualScreen = 0;

  final List<Widget> _screens = [HomeScreen(), CreateScreen()];

  @override
  Widget build(BuildContext context) {

      SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => GamesProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Library Game',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.light.bg,
        ),
        darkTheme: ThemeData(
            useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.dark.bg,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Game Library')),
          body: _screens[actualScreen],
          bottomNavigationBar: BottomNavigation(
            actualScreen: actualScreen,
            onItemTapped: onItemTapped,
          ),
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      actualScreen = index;
    });
  }
}
