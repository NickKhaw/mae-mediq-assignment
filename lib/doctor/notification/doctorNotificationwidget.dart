import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Functions.dart';
import '../../globals.dart';
import 'package:mae_mediq_assignment/index.dart';

class DoctorNotificationWidget extends StatefulWidget {
  const DoctorNotificationWidget({super.key});

  static String routeName = 'doctorNotification';
  static String routePath = '/doctornotification';

  @override
  State<DoctorNotificationWidget> createState() =>
      _DoctorNotificationWidgetState();
}

class _DoctorNotificationWidgetState extends State<DoctorNotificationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> notifications = [];

  void loadData() async {
    List<Map<String, dynamic>> data = await getNotifBySenderIC(
      "Notifications", "adminIC", "doctorIC", globalIC);

    setState(() {
      notifications = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Convert Firestore Timestamp to readable string
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFE6F1F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A90E2),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => context.pushNamed(DoctorDashbaordWidget.routeName),
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: notifications.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final String title = notification['message']?.toString() ?? 'No message';
                  final Timestamp? timestamp = notification['Timestamp'];
                  final String date = timestamp != null ? formatTimestamp(timestamp) : 'No timestamp';
                  final bool isRead = notification['read'] == true;
                  final String? docId = notification['docId']; // must be included in getNotifBySenderIC()

                  return GestureDetector(
                    onTap: () {
                      if (!isRead && docId != null) {
                        markAsRead(docId);
                        setState(() {
                          notifications[index]['read'] = true;
                        });
                      }
                    },
                    child: _buildNotificationItem(
                      title,
                      date,
                      isRead: isRead,
                      color: isRead ? const Color(0xFF4B39EF) : const Color(0xFFEF476F),
                      docId: docId,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String date, {
    bool isRead = true,
    Color color = const Color(0xFF4B39EF),
    String? docId,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF1F4F8),
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.0,
              color: Color(0xFFE0E3E7),
              offset: Offset(0.0, 1.0),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 4.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF14181B),
                      fontSize: 16.0,
                      fontWeight:
                          isRead ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  date,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF57636C),
                    fontSize: 14.0,
                  ),
                ),
              ),
              if (!isRead && docId != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      markAsRead(docId);
                      setState(() {
                        notifications.firstWhere((n) => n['docId'] == docId)['read'] = true;
                      });
                    },
                    child: const Text('Mark as Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
