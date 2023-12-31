import 'package:final_app/screens/mainScreen.dart';
import 'package:final_app/screens/catalogsScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/screens/signInScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        
      ),
      home: login(),
      routes: {
        'login': (context) => const login(),
        'Catalogs': (context) => CatalogsScreen(),
        'homeScreen': (context) => HomeScreen(),
      },
    );
  }
}
