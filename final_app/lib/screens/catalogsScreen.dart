import 'package:final_app/constants/api.dart';
import 'package:final_app/screens/bookingScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogsScreen extends StatefulWidget {
  @override
  _CatalogsScreenState createState() => _CatalogsScreenState();
}

class _CatalogsScreenState extends State<CatalogsScreen> {
  List<dynamic> cars = [];

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    final response = await http.get(Uri.parse('$apiEndpoint/car.php'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        cars = json.decode(response.body);
      });
    } else {
      throw Exception('การดึงข้อมูลรถล้มเหลว');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบจองรถ'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cars.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    cars[index]['cImage'], // URL รูปภาพ
                    height: 200, // กำหนดความสูงของรูป
                    width: double.infinity, // กำหนดความกว้างเต็มหน้าจอ
                    fit: BoxFit.cover, // กำหนดการแสดงรูปภาพ
                  ),
                  ListTile(
                    title: Text(
                      cars[index]['cName'],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ประเภท: ${cars[index]['cBrand']}'),
                        Text('ขนาด: ${cars[index]['cType']}'),
                        Text('ราคา: ${cars[index]['cPrice']} บาท'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingScreen(car: cars[index]),
                          ),
                        );
                      },
                      child: Text('จองรถ'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
