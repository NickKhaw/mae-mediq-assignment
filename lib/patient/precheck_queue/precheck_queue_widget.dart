import 'package:mae_mediq_assignment/globals.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'precheck_queue_model.dart';
export 'precheck_queue_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Functions.dart';

class PrecheckQueueWidget extends StatefulWidget {
  const PrecheckQueueWidget({super.key});

  static String routeName = 'Precheck_Queue';
  static String routePath = '/precheckQueue';

  

  @override
  State<PrecheckQueueWidget> createState() => _PrecheckQueueWidgetState();
}

class _PrecheckQueueWidgetState extends State<PrecheckQueueWidget> {
  late PrecheckQueueModel _model;
  bool booking_exist = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
     _model = PrecheckQueueModel();
     getStatus();

  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future <void> getStatus()async{
    bool ds = await checkDataExistence('Booking', 'IC', globalIC);
    setState(() {
      booking_exist = ds;
    });
  }



  @override
Widget build(BuildContext context) {
  return Scaffold(
    key: scaffoldKey,
    backgroundColor: Color(0xFFE6F1F7),
    appBar: AppBar(
      backgroundColor: Color(0xFF4A90E2),
      title: const Text(
        'Appointment Status',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 2,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              booking_exist == true
                  ? Icons.schedule
                  : Icons.calendar_today_outlined,
              size: 100,
              color: booking_exist == true ? Colors.grey : Colors.black, // Updated icon color
            ),
            SizedBox(height: 20),
            Text(
              booking_exist == true
                  ? 'You can only book one appointment a day.'
                  : "You haven't booked an appointment yet.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: booking_exist == true ? Colors.black54 : Colors.black, // Updated text color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              booking_exist == true
                  ? 'Please wait until tomorrow to book again.'
                  : "Please go to the booking section to make one.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

}
