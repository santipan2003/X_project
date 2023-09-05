import 'package:flutter/material.dart';
import 'package:final_app/api.dart';
import 'package:final_app/register/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> cars = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
  final uID = await User.getUID();
  print('uID = : $uID'); // ปริ้นค่า uID ในคอนโซล

  // โหลดข้อมูลการจองรถจาก get_bookings.php
  final bookingResponse = await http.post(
    Uri.parse('$apiEndpoint/get_bookings.php'),
    body: {'uID': uID},
  );

  if (bookingResponse.statusCode == 200) {
    final List<dynamic> bookingData = json.decode(bookingResponse.body);
    if (mounted) {
      setState(() {
        bookings = bookingData.cast<Map<String, dynamic>>();
      });
    }
  } else {
    // Handle the case when fetching bookings fails
    print('Failed to fetch bookings');
  }

  // โหลดข้อมูลรถจาก car.php
  final carResponse = await http.get(Uri.parse('$apiEndpoint/car.php'));
  if (carResponse.statusCode == 200) {
    final List<dynamic> carData = json.decode(carResponse.body);
    if (mounted) {
      setState(() {
        cars = carData.cast<Map<String, dynamic>>();
      });
    }
  } else {
    throw Exception('การดึงข้อมูลรถล้มเหลว');
  }
}


  Future<Map<String, dynamic>> fetchCarDetails(String cID) async {
    // โหลดข้อมูลรถจาก API โดยใช้ cID
    final carDetailsResponse = await http.get(
      Uri.parse('$apiEndpoint/car.php?cID=$cID'),
    );

    if (carDetailsResponse.statusCode == 200) {
      final List<dynamic> carDetailsData = json.decode(carDetailsResponse.body);
      if (carDetailsData.isNotEmpty) {
        // คืนข้อมูลรถแรกที่พบ
        return carDetailsData.first;
      }
    }
    // ถ้าไม่พบข้อมูลรถหรือเกิดข้อผิดพลาด คืนค่าว่าง
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการการจองรถ'),
      ),
      body: FutureBuilder(
        future:
            fetchData(), // Call fetchData here, which should return a Future
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Handle any errors that occurred during data fetching
            return Text('Error: ${snapshot.error}');
          } else {
            // Data fetching is complete, build the ListView
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final cID = booking['cID'].toString(); // Convert cID to a string

                // Filter the cars list to get only the car with matching cID
                final matchingCars = cars
                    .where((car) => car['cID'].toString() == cID)
                    .toList();

                return ListTile(
                  leading: matchingCars.isNotEmpty &&
                          matchingCars[0]['cImage'] != null
                      ? Image.network(matchingCars[0]['cImage'].toString())
                      : Icon(Icons.image_not_supported),
                  title: Text(
                    'รถ: ${matchingCars.isNotEmpty ? matchingCars[0]['cName'].toString() : 'N/A'}',
                  ),
                  subtitle: Text(
                    matchingCars.isNotEmpty
                        ? 'ประเภท: ${matchingCars[0]['cBrand']?.toString() ?? 'N/A'}\n'
                            'ขนาด: ${matchingCars[0]['cType']?.toString() ?? 'N/A'}\n'
                            'ราคา: ${matchingCars[0]['cPrice']?.toString() ?? 'N/A'} บาท\n'
                            'วันที่เริ่มต้น: ${booking['uDateFrom']?.toString() ?? 'N/A'}\n'
                            'วันที่สิ้นสุด: ${booking['uDateTo']?.toString() ?? 'N/A'}'
                        : 'N/A',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
