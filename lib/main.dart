import 'package:flutter/material.dart';
import 'package:firstapp/pages/home.dart';
import 'package:firstapp/pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
    initialRoute: '/',
    routes: {
      '/': (context) => const MainScreen(),
      '/todo': (context) => const Home(),
    },
  ));
}
