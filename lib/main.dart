import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/db/hive_model.dart';
import 'package:quotes_app/models/favourite_cubit.dart';
import 'package:quotes_app/pages/categories_screen.dart';
import 'package:quotes_app/pages/favourite_screen.dart';
import 'package:quotes_app/pages/home.dart';
import 'package:quotes_app/pages/mode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:quotes_app/pages/mode_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveModel.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isDark;
  ThemeMode currentTheme = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    modeInitilization();
  }

  void modeInitilization() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    setState(() {
      currentTheme = isDark! ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = !isDark!;
    await prefs.setBool('isDark', isDark!);
    setState(() {
      currentTheme = isDark! ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'categoriesScreen': (BuildContext context) => CategoriesScreen(),
          'modeScreen': (BuildContext context) => ModeScreen(
                isDark: isDark!,
                toggleTheme: toggleTheme,
              ),
          'favouriteScreen': (BuildContext context) => FavouriteScreen(),
        },
        title: 'Quote Me',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.light),
            useMaterial3: true,
            platform: TargetPlatform.iOS),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.dark),
            useMaterial3: true,
            platform: TargetPlatform.iOS),
        themeMode: currentTheme,
        home: Home(),
      ),
    );
  }
}
