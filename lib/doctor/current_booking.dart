import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mae_mediq_assignment/flutter_flow/flutter_flow_util.dart';
import '../../globals.dart' as globals;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';
import '../doctor/doctor_dashbaord/doctor_dashbaord_widget.dart';

class DoctorBookingListPage extends StatefulWidget {
  static String routeName = 'Doctor_Booking';
  static String routePath = '/DoctorBooking';

  @override
  _DoctorBookingListPageState createState() => _DoctorBookingListPageState();
}

class _DoctorBookingListPageState extends State<DoctorBookingListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Map<String, dynamic>>> bookingsFuture;
  bool hasAlreadySelected = false;
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    bookingsFuture = fetchBookings();
    checkIfAlreadySelected();
  }

  void checkIfAlreadySelected() async {
    var db = FirebaseFirestore.instance;
    final doc = await db
        .collection('Selected')
        .where("Doctor_IC", isEqualTo: globals.globalIC)
        .get();
    bool exists = doc.docs.isNotEmpty;
    if (exists) {
      print("Found");
      setState(() {
        hasAlreadySelected = true;
      });
    }
  }

  void alertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore
        .collection('Booking')
        .where('Department', isEqualTo: globals.globalDepartment)
        .where("Status", isEqualTo: "Pending")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data;
    }).toList();
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        if (selectedIndexes.length >= 3) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Limit Reached"),
                content: Text("You can only select up to 3 bookings."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        } else {
          selectedIndexes.add(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFE6F1F7),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 20.0,
          borderWidth: 1.0,
          buttonSize: 40.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            context.pushNamed(DoctorDashbaordWidget.routeName);
          },
        ),
        title: Text(
          'Add Patient Record',
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return Center(
              child: Text(
                "No pending bookings found.",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            );
          }

          return Column(
            children: [
              if (hasAlreadySelected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "You have already selected bookings. Please check the accepted list.",
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final timestamp = booking['Timestamp'];

                    if (timestamp is! Timestamp) {
                      return Text('Invalid timestamp');
                    }

                    final formatted = formatDateAndTimeFromTimestamp(timestamp);

                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Booking Ticket Header
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A90E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Booking Ticket",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "#${booking['Ticket ID'] ?? 'N/A'}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            
                            // Selection Checkbox
                            CheckboxListTile(
                              value: selectedIndexes.contains(index),
                              onChanged: hasAlreadySelected
                                  ? (_) => alertDialog(
                                      "You have already selected bookings. Please check the accepted list.")
                                  : (_) => toggleSelection(index),
                              title: Text(
                                "Select this booking",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Color(0xFF4A90E2),
                              contentPadding: EdgeInsets.zero,
                            ),
                            
                            // Patient Info Section
                            _buildSectionHeader(Icons.person, "Patient Information"),
                            _buildDivider(),
                            _buildInfoRow("Name:", booking['Name'] ?? 'N/A'),
                            _buildInfoRow("IC Number:", booking['IC'] ?? 'N/A'),
                            _buildInfoRow("Phone:", booking['Phone Num'] ?? 'N/A'),
                            _buildInfoRow("Gender:", booking['Gender'] ?? 'N/A'),
                            _buildInfoRow("Department:", booking['Department'] ?? 'N/A'),
                            
                            SizedBox(height: 12),
                            
                            // Booking Info Section
                            _buildSectionHeader(Icons.calendar_today, "Appointment Details"),
                            _buildDivider(),
                            _buildInfoRow("Appointment Date:", formatted['date'] ?? 'N/A'),
                            _buildInfoRow("Appointment Time:", formatted['time'] ?? 'N/A'),
                            _buildInfoRow("Status:", 
                              booking['Status'] ?? 'N/A',
                              valueStyle: TextStyle(
                                color: booking['Status'] == 'Pending' 
                                  ? Colors.orange 
                                  : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (selectedIndexes.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            var db = FirebaseFirestore.instance;
                            final selectedICs = selectedIndexes
                                .map((i) => bookings[i]['IC'])
                                .toList();
                            final selectedStatus = [];
                            for (int i=0; i < selectedICs.length; i++) {
                              selectedStatus.add(0);
                            }

                            for (int i in selectedIndexes) {
                              final ic = bookings[i]['IC'];
                              final querySnapshot = await db
                                  .collection('Booking')
                                  .where('IC', isEqualTo: ic)
                                  .get();

                              for (var doc in querySnapshot.docs) {
                                await doc.reference
                                    .update({'Status': 'Approved',
                                    'Doctor_IC':globals.globalIC});
                              }
                            }

                            await db.collection('Selected').add({
                              'Doctor_IC': globals.globalIC,
                              'Patients_Selected': selectedICs,
                              'Timestamp': Timestamp.now(),
                              'Selected_Status': selectedStatus
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Success"),
                                  content: Text(
                                      "Accepted ${selectedICs.length} booking(s)."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.pushNamed(
                                            DoctorBookingListPage.routeName);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );

                            setState(() {
                              selectedIndexes.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A90E2),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            "Accept Selected (${selectedIndexes.length})",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF4A90E2), size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 16,
    );
  }

  Widget _buildInfoRow(String title, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ?? TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, String> formatDateAndTimeFromTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final date = DateFormat('dd MMMM yyyy').format(dateTime);
  final time = DateFormat('hh:mm a').format(dateTime);

  return {'date': date, 'time': time};
}