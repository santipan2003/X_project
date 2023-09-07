import 'package:flutter/material.dart';
// เพิ่ม import นี้

class AboutScreen extends StatelessWidget {
  // เพิ่มฟังก์ชันสำหรับแสดง AlertDialog
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
              },
            ),
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                // ทำตรางนี้เมื่อผู้ใช้คลิก "ตกลง"
                // ในกรณีนี้คุณสามารถเรียกฟังก์ชันออกจากระบบที่คุณมีอยู่
                // แล้วส่งผู้ใช้กลับไปหน้า Login หรือที่คุณต้องการ
                Navigator.of(context).pop(); // ปิด AlertDialog
                // ตัวอย่างการนำผู้ใช้กลับไปหน้า Login
                Navigator.of(context).pushReplacementNamed('login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // เพิ่มปุ่ม Logout ใน AppBar
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // เรียกใช้ฟังก์ชันแสดง AlertDialog
              _showLogoutDialog(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                'https://cdn.pic.in.th/file/picinth/318215908_3003667339942321_5246307608707386551_n.th.jpeg',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'รหัสนักศึกษา : 64113384',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'ชื่อ-สกุล : ศานติพันธ์ สันอี',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'เบอร์โทรศัพท์ : 0918456138',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
