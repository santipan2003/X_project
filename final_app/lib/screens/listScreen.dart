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

  // Function to handle saving the edited data
  void handleSave(String cID, String newDateFrom, String newDateTo) {
    // Here, you can update your data or take any necessary action with the new dates
    print('Updated Date From: $newDateFrom');
    print('Updated Date To: $newDateTo');
  }

  void updateBookingDate(String cID, String newDateFrom, String newDateTo) {
    // Find the booking object in the list by cID
    final index = bookings.indexWhere((booking) => booking['cID'] == cID);

    if (index != -1) {
      // Update the booking object with the new dates
      setState(() {
        bookings[index]['uDateFrom'] = newDateFrom;
        bookings[index]['uDateTo'] = newDateTo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final cID = booking['cID'].toString();

                final matchingCars =
                    cars.where((car) => car['cID'].toString() == cID).toList();

                return ListTile(
                  onTap: () async {
                    // Navigate to EditBookingScreen when ListTile is tapped
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(
                          uDateFrom: booking['uDateFrom']?.toString() ?? '',
                          uDateTo: booking['uDateTo']?.toString() ?? '',
                        ),
                      ),
                    );

                    if (result != null) {
                      final newDateFrom = result['uDateFrom'];
                      final newDateTo = result['uDateTo'];

                      // Update the booking with the edited values
                      updateBookingDate(cID, newDateFrom, newDateTo);

                      // Call a function to handle saving the edited data if needed
                      handleSave(cID, newDateFrom, newDateTo);
                    }
                  },
                  leading: matchingCars.isNotEmpty &&
                          matchingCars[0]['cImage'] != null
                      ? Image.network(matchingCars[0]['cImage'].toString())
                      : Icon(Icons.image_not_supported),
                  title: Text(
                    'Car: ${matchingCars.isNotEmpty ? matchingCars[0]['cName'].toString() : 'N/A'}',
                  ),
                  subtitle: Text(
                    matchingCars.isNotEmpty
                        ? 'Type: ${matchingCars[0]['cBrand']?.toString() ?? 'N/A'}\n'
                            'Size: ${matchingCars[0]['cType']?.toString() ?? 'N/A'}\n'
                            'Price: ${matchingCars[0]['cPrice']?.toString() ?? 'N/A'} บาท\n'
                            'Start Date: ${booking['uDateFrom']?.toString() ?? 'N/A'}\n'
                            'End Date: ${booking['uDateTo']?.toString() ?? 'N/A'}'
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
