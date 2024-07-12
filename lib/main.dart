import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kotchi/auth/auth.dart';

import 'package:kotchi/firebase_options.dart';

import 'package:kotchi/screens/home/home.dart';
import 'package:kotchi/screens/profile/profile.dart';
import 'package:kotchi/screens/profile/user.dart';


import 'package:kotchi/themes/dart_theme.dart';
import 'package:kotchi/themes/light_theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      routes: {

        '/home_page': (context) => HomeScreen(),
        '/profile_page': (context) => ProfileScreen(),
        '/user_page': (context) => const UserScreen(),
      },
      home: const AuthPage(),
    );
  }
}

