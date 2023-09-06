import 'package:final_app/screens/bookingScreen.dart';
import 'package:final_app/screens/mainScreen.dart';
import 'package:final_app/screens/catalogsScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/login/signInScreen.dart';
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
        'Catalogs': (context) => CatalogsScreen(),
        'homeScreen': (context) => HomeScreen(),
      },
    );
  }
}
