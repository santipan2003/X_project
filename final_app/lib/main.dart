import 'package:final_app/mainscreen/homescreen.dart';
import 'package:final_app/mainscreen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/login/login.dart';
import 'package:final_app/register/register.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: login(),
      routes: {
        'register': (context) => const register(),
        'login': (context) => const login(),
        'MainScreen': (context) => MainScreen(),
        'homeScreen': (context) => HomeScreen(),
      },
    );
  }
}
