import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final String uDateFrom;
  final String uDateTo;

  EditScreen({required this.uDateFrom, required this.uDateTo});

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
    if (picked != null && picked != DateTime.now())
      setState(() {
        uDateFromController.text = picked.toString();
      });
  }

  // Function to open the date picker dialog for uDateTo
  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        uDateToController.text = picked.toString();
      });
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
              onTap: () => _selectDateFrom(context), // Open date picker
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateFromController,
                  decoration: InputDecoration(labelText: 'New uDateFrom'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDateTo(context), // Open date picker
              child: AbsorbPointer(
                child: TextField(
                  controller: uDateToController,
                  decoration: InputDecoration(labelText: 'New uDateTo'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the edited values and pop the page
                final newDateFrom = uDateFromController.text;
                final newDateTo = uDateToController.text;

                // Pass the edited values back to the previous screen
                // Inside EditBookingScreen when you want to send back the data
                Navigator.pop(
                    context, {'uDateFrom': newDateFrom, 'uDateTo': newDateTo});
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
