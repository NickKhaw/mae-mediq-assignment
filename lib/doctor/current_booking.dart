import 'package:flutter/material.dart';

class DoctorBookingListPage extends StatelessWidget {

  static String routeName = 'Doctor_Booking';
  static String routePath = '/DoctorBooking';


  final List<Map<String, String>> bookings = [
    {
      'name': 'John Tan',
      'ic': '990101-10-5678',
      'phone': '012-3456789',
      'gender': 'Male',
      'department': 'ENT (Ear, Nose, Throat)',
      'date': '22 July 2025',
      'time': '10:00 AM',
      'status': 'Confirmed',
    },
    {
      'name': 'Ali Bin Omar',
      'ic': '980202-02-8888',
      'phone': '017-9876543',
      'gender': 'Male',
      'department': 'Cardiology',
      'date': '22 July 2025',
      'time': '11:30 AM',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Doctor's Booking List"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Patient Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  SizedBox(height: 4),

                  _infoRow("Name:", booking['name']!),
                  _infoRow("IC:", booking['ic']!),
                  _infoRow("Phone:", booking['phone']!),
                  _infoRow("Gender:", booking['gender']!),
                  _infoRow("Department:", booking['department']!),
                  SizedBox(height: 12),

                  // Booking Info
                  Row(
                    children: [
                      Icon(Icons.event_note, color: Colors.lightBlue),
                      SizedBox(width: 8),
                      Text(
                        "Booking Info",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  SizedBox(height: 4),

                  _infoRow("Date:", booking['date']!),
                  _infoRow("Time:", booking['time']!),
                  _infoRow("Status:", booking['status']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper to build info rows
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
