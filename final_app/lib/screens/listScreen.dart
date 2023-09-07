import 'package:final_app/screens/editScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_app/constants/api.dart';
import 'package:final_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> cars = [];
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final uID = await User.getUID();
    print('uID = : $uID'); // Print uID in the console

    final bookingResponse = await http.post(
      Uri.parse('$apiEndpoint/get_bookings.php'),
      body: {'uID': uID},
    );

    if (bookingResponse.statusCode == 200) {
      final List<dynamic> bookingData = json.decode(bookingResponse.body);
      if (mounted) {
        setState(() {
          bookings = bookingData.cast<Map<String, dynamic>>();
          isDataFetched = true;
        });
      }
    } else {
      print('Failed to fetch bookings');
    }

    final carResponse = await http.get(Uri.parse('$apiEndpoint/car.php'));
    if (carResponse.statusCode == 200) {
      final List<dynamic> carData = json.decode(carResponse.body);
      if (mounted) {
        setState(() {
          cars = carData.cast<Map<String, dynamic>>();
        });
      }
    } else {
      throw Exception('Failed to fetch car data');
    }
  }

  Future<Map<String, dynamic>> fetchCarDetails(String cID) async {
    final carDetailsResponse = await http.get(
      Uri.parse('$apiEndpoint/car.php?cID=$cID'),
    );

    if (carDetailsResponse.statusCode == 200) {
      final List<dynamic> carDetailsData = json.decode(carDetailsResponse.body);
      if (carDetailsData.isNotEmpty) {
        return carDetailsData.first;
      }
    }
    return <String, dynamic>{};
  }

  // อัพเดตข้อมูลใน table booking โดยเรียกใช้ API ดังนี้
  Future<void> _updateBooking(
      String bID, String newDateFrom, String newDateTo) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/update_booking.php'),
      body: {
        'bID': bID,
        'uDateFrom': newDateFrom,
        'uDateTo': newDateTo,
      },
    );

    if (response.statusCode == 200) {
      print('Booking updated successfully');
    } else {
      print('Failed to update booking');
    }
  }

  // อัพเดตข้อมูลใน State หน้านี้เมื่อมีการเปลี่ยนแปลง
  void handleSave(String cID, String newDateFrom, String newDateTo) {
    // ส่งค่า newDateFrom และ newDateTo ไปยังฟังก์ชัน updateBookingDate
    updateBookingDate(cID, newDateFrom, newDateTo);

    // ทำสิ่งอื่น ๆ ที่คุณต้องการอย่างไรก็ตามที่ต้องการ
  }

  // อัพเดตข้อมูลใน State เมื่อมีการเปลี่ยนแปลง
  void updateBookingDate(String cID, String newDateFrom, String newDateTo) {
  final index = bookings.indexWhere((booking) => booking['cID'] == cID);
  if (index != -1) {
    if (mounted) {
      setState(() {
        bookings[index]['uDateFrom'] = newDateFrom;
        bookings[index]['uDateTo'] = newDateTo;
      });
    }
  }
}



  // ลบข้อมูลใน table booking โดยเรียกใช้ API ดังนี้
Future<void> _deleteBooking(String bID) async {
  final response = await http.post(
    Uri.parse('$apiEndpoint/delete_booking.php'),
    body: {'bID': bID},
  );

  if (response.statusCode == 200) {
    setState(() {
      // ลบข้อมูลการจองที่ตรงกับ bID ออกจากรายการ bookings
      bookings.removeWhere((booking) => booking['bID'].toString() == bID);
    });
  } else {
    print('Failed to delete booking');
  }
}

  void _showDeleteConfirmationDialog(String bID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบคิวจองรถนี้ใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // เรียกใช้ฟังก์ชันลบการจองเมื่อคลิกปุ่มยืนยัน
                _deleteBooking(bID);
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      // แสดงตัวรองรับข้อมูล หรือ Loading Spinner ตราบเท่าที่ข้อมูลยังไม่ได้รับ
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Booking List'),
            automaticallyImplyLeading: false,
          ),
          body: ListView.builder(
            key: UniqueKey(),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bID = booking['bID'].toString();
              final cID = booking['cID'].toString();

              final matchingCars =
                  cars.where((car) => car['cID'].toString() == cID).toList();

              return ListTile(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        uDateFrom: booking['uDateFrom'] ?? '',
                        uDateTo: booking['uDateTo'] ?? '',
                        onSave: (editedData) async {
                          final newDateFrom = editedData['uDateFrom'] ?? '';
                          final newDateTo = editedData['uDateTo'] ?? '';
                          // อัพเดตข้อมูลใน table booking
                          await _updateBooking(bID, newDateFrom, newDateTo);
                          handleSave(cID, newDateFrom, newDateTo);

                          // คำสั่งนี้จะอัพเดตรายการ bookings ในหน้านี้
                          setState(() {
                            booking['uDateFrom'] = newDateFrom;
                            booking['uDateTo'] = newDateTo;
                          });
                        },
                      ),
                    ),
                  );

                  if (result != null) {
                    final newDateFrom = result['uDateFrom'];
                    final newDateTo = result['uDateTo'];
                    // อัพเดตข้อมูลใน table booking
                    await _updateBooking(bID, newDateFrom, newDateTo);
                    updateBookingDate(cID, newDateFrom, newDateTo);
                    handleSave(cID, newDateFrom, newDateTo);
                  }
                },
                leading:
                    matchingCars.isNotEmpty && matchingCars[0]['cImage'] != null
                        ? Image.network(matchingCars[0]['cImage'].toString())
                        : Icon(Icons.image_not_supported),
                title: Text(
                  'Car: ${matchingCars.isNotEmpty ? matchingCars[0]['cName'].toString() : 'N/A'}',
                ),
                subtitle: Text(
                  matchingCars.isNotEmpty
                      ? 'Type: ${matchingCars[0]['cBrand']?.toString() ?? 'N/A'}\n'
                          'Size: ${matchingCars[0]['cType']?.toString() ?? 'N/A'}\n'
                          'Passengers: ${matchingCars[0]['cPassengers']?.toString() ?? 'N/A'}\n'
                          'Price: ${matchingCars[0]['cPrice']?.toString() ?? 'N/A'} บาท\n'
                          'Start Date: ${booking['uDateFrom']?.toString() ?? 'N/A'}\n'
                          'End Date: ${booking['uDateTo']?.toString() ?? 'N/A'}'
                      : 'N/A',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // แสดง AlertDialog สำหรับการยืนยันการลบ
                    _showDeleteConfirmationDialog(bID);
                  },
                ),
              );
            },
          ));
    }
  }
}
