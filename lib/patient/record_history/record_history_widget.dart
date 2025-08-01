import 'package:mae_mediq_assignment/index.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Functions.dart';
import '../../globals.dart';

class RecordHistoryWidget extends StatefulWidget {
  const RecordHistoryWidget({super.key});
  
  static String routeName = 'Record_History';
  static String routePath = '/recordHistory';

  @override
  State<RecordHistoryWidget> createState() => _RecordHistoryWidgetState();
}

class _RecordHistoryWidgetState extends State<RecordHistoryWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F1F7),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 48,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 28,
          ),
          onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);  // Standard back navigation
              } else {
                // Fallback if no routes to pop
                Navigator.pushReplacementNamed(
                  context, 
                  PatientDashboardWidget.routeName
                );
              }
            },
        ),
        title: Text(
          'Medical Records',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Record')
              .where('Patient_IC', isEqualTo: globalIC)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load records',
                  style: FlutterFlowTheme.of(context).titleLarge,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.medical_services,
          size: 48,
          color: Colors.black, // Changed to black
        ),
        SizedBox(height: 12),
        Text(
          'No records found',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                fontFamily: 'Outfit',
                color: Colors.black, // Changed to black
              ),
        ),
      ],
    ),
  );
}


            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                
                // Inside your ListView.builder's itemBuilder:
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left side - Patient details (now 50% width)
                          Expanded(
                            flex: 1, // Changed from 2 to 1 (50% of space)
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Patient header (unchanged)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 28,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (data['Doctor_IC'] != null)
                                            FutureBuilder<String>(
                                              future: getDataWithCon("Doctor", "IC", data['Doctor_IC'], "Name").then((value) => value ?? 'Unknown Doctor'),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: FlutterFlowTheme.of(context).primary,
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return Text('Error loading doctor name');
                                                }
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data ?? 'Unknown Doctor',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600,
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                                    ),
                                                    Text(
                                                      data['Doctor_IC'],
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),                   
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Medical details (unchanged)
                                _buildCompactDetail(
                                  icon: Icons.calendar_today,
                                  label: 'Date',
                                  value: _formatDate(data['Timestamp']),
                                ),
                                
                                _buildCompactDetail(
                                  icon: Icons.local_hospital,
                                  label: 'Department',
                                  value: data['Department'] ?? 'Not specified',
                                ),
                                
                                _buildCompactDetail(
                                  icon: Icons.medical_services,
                                  label: 'Diagnosis',
                                  value: data['Diagnosis'] ?? 'Not specified',
                                ),
                              ],
                            ),
                          ),
                          
                          // Vertical divider
                          if (data['Notes'] != null && data['Notes'].toString().isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: VerticalDivider(
                                thickness: 1,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                            ),
                          
                          // Right side - Notes section (now 50% width)
                          if (data['Notes'] != null && data['Notes'].toString().isNotEmpty)
                            Expanded(
                              flex: 1, // Changed from 3 to 1 (50% of space)
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DOCTOR NOTES',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          data['Notes'],
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            height: 1.4,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompactDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Date not available';
    if (timestamp is Timestamp) {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp.toDate());
    }
    return 'Invalid date';
  }
}
