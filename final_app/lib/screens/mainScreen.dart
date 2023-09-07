import 'package:flutter/material.dart';
import 'package:final_app/screens/listScreen.dart';
import 'package:final_app/screens/catalogsScreen.dart';
import 'package:final_app/screens/aboutScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // ค่าเริ่มต้นของเมนูที่ถูกเลือก

  static List<Widget> _widgetOptions = <Widget>[
    CatalogsScreen(), // เมนูหน้าแสดงรายการรถ
    BookingListScreen(), // เมนูอื่นๆ ที่คุณต้องการเพิ่ม
    Placeholder(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car Booking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'เพิ่มรถ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, 
        unselectedItemColor: Colors.black, 
        onTap: _onItemTapped,
      ),
    );
  }
}
