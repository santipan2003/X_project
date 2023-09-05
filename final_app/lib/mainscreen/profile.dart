import 'package:final_app/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String uTelephone;

  ProfileScreen({required this.uTelephone});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.post(
      Uri.parse('$apiEndpoint/user.php'),
      body: {
        'uTelephone': widget.uTelephone,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์ของคุณ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              // รูปโปรไฟล์ (สามารถเพิ่มรูปจริงๆ หรือรูปจาก URL ได้)
              backgroundImage: NetworkImage('https://example.com/your_profile_image.jpg'),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'ชื่อผู้ใช้: ${userData['uName']}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'เบอร์โทร: ${userData['uTelephone']}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'รหัสผู้ใช้: ${userData['uID']}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
