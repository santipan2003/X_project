import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final String uDateFrom;
  final String uDateTo;
  final Function(Map<String, String>) onSave; // เพิ่มฟังก์ชัน onSave

  EditScreen({
    required this.uDateFrom,
    required this.uDateTo,
    required this.onSave, // เพิ่มอาร์กิวเมนต์สำหรับ onSave
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController uDateFromController = TextEditingController();
  TextEditingController uDateToController = TextEditingController();

  // Function to open the date picker dialog for uDateFrom
  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print(
          'Selected Date From: $formattedDate'); // Debug: Check the selected date
      setState(() {
        uDateFromController.text = formattedDate;
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print(
          'Selected Date To: $formattedDate'); // Debug: Check the selected date
      setState(() {
        uDateToController.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    uDateFromController.text = widget.uDateFrom;
    uDateToController.text = widget.uDateTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectDateFrom(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateFromController,
                  decoration: InputDecoration(labelText: 'New uDateFrom'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDateTo(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateToController,
                  decoration: InputDecoration(labelText: 'New uDateTo'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newDateFrom =
                    DateTime.parse(uDateFromController.text).toLocal();
                final newDateTo =
                    DateTime.parse(uDateToController.text).toLocal();

                final formattedDateFrom =
                    DateFormat('yyyy-MM-dd').format(newDateFrom);
                final formattedDateTo =
                    DateFormat('yyyy-MM-dd').format(newDateTo);

                print(
                    'New Date From: $formattedDateFrom'); // Debug: Check the new date
                print(
                    'New Date To: $formattedDateTo'); // Debug: Check the new date

                // Pass the edited values back to the previous screen
                widget.onSave({
                  'uDateFrom': formattedDateFrom,
                  'uDateTo': formattedDateTo
                });

                Navigator.pop(context); // ปิดหน้า EditScreen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
