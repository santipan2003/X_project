import 'package:final_app/api.dart';
import 'package:final_app/mainscreen/list.dart';
import 'package:final_app/register/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final dynamic car;

  BookingScreen({required this.car});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? uDateFrom;
  DateTime? uDateTo;

  Future<void> _selectUDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != uDateFrom) {
      setState(() {
        uDateFrom = picked;
      });
    }
  }

  Future<void> _selectUDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != uDateTo) {
      setState(() {
        uDateTo = picked;
      });
    }
  }

  Future<void> _submitBooking(DateTime uDateFrom, DateTime uDateTo) async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/booking.php'),
      body: {
        'cID': widget.car['cID'],
        'uDateFrom': uDateFrom.toLocal().toString(),
        'uDateTo': uDateTo.toLocal().toString(),
        'uID': await User.getUID(),
      },
    );

    if (response.statusCode == 200) {
      // สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกข้อมูลการจองรถเรียบร้อย'),
        ),
      );
    } else {
      // ไม่สำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('การบันทึกข้อมูลการจองรถล้มเหลว'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จองรถ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ข้อมูลรถที่จอง:'),
            Image.network(widget.car['cImage']),
            Text('ชื่อ: ${widget.car['cName']}'),
            Text('ประเภท: ${widget.car['cBrand']}'),
            Text('ขนาด: ${widget.car['cType']}'),
            Text('ราคา: ${widget.car['cPrice']} บาท'),
            SizedBox(height: 20),
            Text('วันเวลาเริ่มต้น:'),
            ElevatedButton(
              onPressed: () {
                _selectUDateFrom(context);
              },
              child: Text(
                uDateFrom != null
                    ? uDateFrom!.toLocal().toString().split(' ')[0]
                    : 'เลือกวันเริ่มต้น',
              ),
            ),
            SizedBox(height: 20),
            Text('วันเวลาสิ้นสุด:'),
            ElevatedButton(
              onPressed: () {
                _selectUDateTo(context);
              },
              child: Text(
                uDateTo != null
                    ? uDateTo!.toLocal().toString().split(' ')[0]
                    : 'เลือกวันสิ้นสุด',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (uDateFrom != null && uDateTo != null) {
                  // ส่งข้อมูลการจองไปยัง PHP API
                  _submitBooking(uDateFrom!, uDateTo!);
                } else {
                  // แจ้งเตือนให้เลือกวันเวลาเริ่มต้นและสิ้นสุด
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('กรุณาเลือกวันเวลาเริ่มต้นและสิ้นสุด'),
                    ),
                  );
                }
              },
              child: Text('ยืนยันการจองรถ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BookingListScreen()), // เปลี่ยนเส้นทางไปยัง ListScreen
                );
              },
              child: Text('ดูรายการการจองของคุณ'),
            ),
          ],
        ),
      ),
    );
  }
}
