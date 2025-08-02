import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manage_doctor_model.dart';
export 'manage_doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../add_doctor/add_doctor_widget.dart';
import '../view_review/view_review_widget.dart';
import '../edit_doctor/edit_doctor_widget.dart';
import '../../globals.dart';

class ManageDoctorWidget extends StatefulWidget {
  const ManageDoctorWidget({super.key});

  static String routeName = 'ManageDoctor';
  static String routePath = '/manageDoctor';

  @override
  State<ManageDoctorWidget> createState() => _ManageDoctorWidgetState();
}

class _ManageDoctorWidgetState extends State<ManageDoctorWidget> {
  late ManageDoctorModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;
  String? errorMessage;
  String? _selectedDepartment;
  final List<String> _departments = [
    'All Departments',
    'General Medicine',
    'Pediatrics',
    'Cardiology',
    'Neurology',
    'Gynecology',
    'ENT'
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageDoctorModel());
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Initialize the base query
    Query query = _firestore.collection('Doctor');

    // Apply department filter if one is selected and it's not "All Departments"
    if (_selectedDepartment != null && _selectedDepartment != 'All Departments') {
      query = query.where('Department', isEqualTo: _selectedDepartment);
    }

    // Execute the query
    final QuerySnapshot querySnapshot = await query.get();

    // Process the documents
    final List<Map<String, dynamic>> fetchedDoctors = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['Name']?.toString() ?? 'No Name',
        'specialty': data['Department']?.toString() ?? 'No Specialty',
        'email': data['Email']?.toString() ?? 'No Email',
        'phone': data['Phone Num']?.toString() ?? 'No Phone',
        'department': data['Department']?.toString(),
        'room': data['Room']?.toString() ?? 'No Room', // Added for easier filtering
      };
    }).toList();

    // Sort doctors alphabetically by name
    fetchedDoctors.sort((a, b) => a['name'].compareTo(b['name']));

    setState(() {
      doctors = fetchedDoctors;
      isLoading = false;
    });

  } on FirebaseException catch (e) {
    setState(() {
      errorMessage = 'Database error: ${e.message}';
      isLoading = false;
    });
  } on Exception catch (e) {
    setState(() {
      errorMessage = 'Unexpected error: ${e.toString()}';
      isLoading = false;
    });
  }
}


  Future<void> _deleteDoctor(String doctorId) async {
    try {
      await _firestore.collection('Doctor').doc(doctorId).delete();
      // Refresh the list after deletion
      await _fetchDoctors();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to delete doctor: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
  return Material(
    color: Colors.transparent,
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFB0C4DE),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name']!,
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w600,
                          ),
                          color: Colors.black,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        doctor['specialty']!,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          Text(
                            doctor['email']!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: Colors.black,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ].divide(SizedBox(width: 4.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: Colors.black,
                            size: 16.0,
                          ),
                          Text(
                            doctor['phone']!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: Colors.black,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ].divide(SizedBox(width: 4.0)),
                      ),Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.meeting_room_outlined,
            color: Colors.black,
            size: 16.0,
          ),
          SizedBox(width: 4.0),
          Text(
            doctor['room'] ?? 'No Room',
            style: FlutterFlowTheme.of(context).bodySmall.override(
              font: GoogleFonts.inter(),
              color: Colors.black,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    
                    ].divide(SizedBox(height: 8.0)),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Review Button
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 36.0,
                      fillColor: Color(0x00E3F2FD),
                      icon: Icon(
                        Icons.reviews_outlined, // Or Icons.star_outline
                        color: Colors.black,
                        size: 18.0,
                      ),
                      onPressed: () {
                        globalDoctorID = doctor['id'];
                        context.pushNamed(ReviewsPage.routeName);
                        
                      },
                    ),
                    // Edit Button
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 36.0,
                      fillColor: Color(0x00E3F2FD),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                        size: 18.0,
                      ),
                      onPressed: () {
                        globalDoctorID = doctor['id'];
                        context.pushNamed(EditDoctorWidget.routeName);
                        print('Edit ${doctor['name']} pressed ...');
                      },
                    ),
                    // Delete Button
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 36.0,
                      fillColor: Color(0x00FFEBEE),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.black,
                        size: 18.0,
                      ),
                      onPressed: () {
                        _deleteDoctor(doctor['id']);
                      },
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFE6F1F7),
        appBar: AppBar(
          backgroundColor: Color(0xFF4A90E2),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 8.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Doctor Management',
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w600,
                  ),
                  fontSize: 30.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0, 24.0, 0),
                child: Row(
                  children: [
                    // Add Doctor Button
                    FFButtonWidget(
                      onPressed: () {
                        context.pushNamed(AddDoctorWidget.routeName);
                      },
                      text: 'Add Doctor',
                      icon: Icon(Icons.add, size: 15.0, color: Colors.white),
                      options: FFButtonOptions(
                        width: 200.0,
                        height: 56.0,
                        padding: EdgeInsets.all(0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                        color: Color(0xFF4A90E2),
                        textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Colors.white,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        elevation: 0.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    
                    SizedBox(width: 16), // Space between button and dropdown
                    
                    // Department Filter Dropdown - Styled to match
                    Expanded(
                      child: Container(
                        height: 56.0,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Color(0xFF4A90E2),
                            width: 1.0,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedDepartment ?? 'All Departments',
                          isExpanded: true,
                          dropdownColor:  Color(0xFF4A90E2),
                          underline: Container(), // Remove default underline
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                          items: _departments.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDepartment = newValue == 'All Departments' ? null : newValue;
                              _fetchDoctors();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(child: Text(errorMessage!))
                else if (doctors.isEmpty)
                  Center(child: Text('No doctors found', style: TextStyle(color: Colors.black)))
                else
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0, 24.0, 0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: index == doctors.length - 1 ? 0 : 12.0),
                          child: _buildDoctorCard(doctors[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
