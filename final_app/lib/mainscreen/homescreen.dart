import 'package:final_app/mainscreen/list.dart';
import 'package:flutter/material.dart';
import 'package:final_app/mainscreen/mainscreen.dart';


class HomeScreen extends StatefulWidget {
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // ค่าเริ่มต้นของเมนูที่ถูกเลือก

  static List<Widget> _widgetOptions = <Widget>[
    MainScreen(), // เมนูหน้าแสดงรายการรถ
    BookingListScreen(), // เมนูอื่นๆ ที่คุณต้องการเพิ่ม
    Placeholder(),
    Placeholder(),
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
        title: Text('Car Booking'), // ชื่อแอพลิเคชัน
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'ค้นหารถ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'เพิ่มรถ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // สีของไอคอนที่ถูกเลือก
        unselectedItemColor: Colors.black, // สีของไอคอนที่ไม่ถูกเลือก
        onTap: _onItemTapped,
      ),
    );
  }
}
