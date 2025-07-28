import 'package:mae_mediq_assignment/globals.dart';
import 'package:mae_mediq_assignment/index.dart';
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
import 'check_queue_model.dart';
export 'check_queue_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Functions.dart';
import '../review/review_widget.dart';

class CheckQueueWidget extends StatefulWidget {
  const CheckQueueWidget({super.key});

  static String routeName = 'Check_Queue';
  static String routePath = '/checkQueue';

  

  @override
  State<CheckQueueWidget> createState() => _CheckQueueWidgetState();
}

class _CheckQueueWidgetState extends State<CheckQueueWidget> {
  late CheckQueueModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String hospitalName = '';
  String hospitalAddress = '';
  List<String> phoneNumbers = [];
  String phone1 = '';
  String phone2 = '';
  String phone3 = '';
  String actualticketNumber = '';
  int myticketNumber = 0;
  int patientdone = 0;
  int get peopleInFront => myticketNumber - patientdone;
  int index = -1;

  bool DoneAppointment = false;
  String DoctorName = '';
  String DoctorPhone = '';
  String DoctorDepartment = '';
  String DoctorRoom = '';
  String DoctorRating = '';
  String DoctorLevel = '';
  String DoctorProfilePic = 'data:image/png;base64,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'; // Your image data
                             
  

  @override
  void initState() {
    super.initState();
     _model = CheckQueueModel();
     CheckStatus();
    fetchHospitalData(); // call the async method
  }


  Future<void> CheckStatus() async{
    String? status = await getDataWithCon('Booking', 'IC', globalIC, 'Status');

    print(status);
    if(status == 'Done'){
      print("FinALLLLY");
      DoneAppointment = true;
      context.pushNamed(Review.routeName);
    }else if (status == 'Done'){
      context.pushNamed(PrecheckQueueWidget.routeName);
    }  
  }

  Future<void> fetchHospitalData() async {
  final snapshot = await FirebaseFirestore.instance.collection("Hospital").get();

  if (snapshot.docs.isNotEmpty) {
    final doc = snapshot.docs.first;

    // Get the ticket value first
    String? ticketId = await getDataWithCon("Booking", "IC", globalIC, "Ticket ID");

    // Count how many patients are done
    int doneCount = await countDataRowWithCon("Booking", "Status", "Done");

    setState(() {
      hospitalName = doc.get('Name');
      hospitalAddress = doc.get('Address');
      
      List<dynamic> phoneArray = doc.get('Phone Num');
      phone1 = phoneArray[0];
      phone2 = phoneArray[1];
      phone3 = phoneArray[2];
      phoneNumbers = [phone1, phone2, phone3]; 
      

      actualticketNumber = ticketId ?? '';
      if (ticketId != null && ticketId.isNotEmpty) {
        myticketNumber = extractTicketNumber(ticketId) - 1;
      } else {
        myticketNumber = 0; 
      }
      patientdone = doneCount;
    });

  }
  
    // Step 1: Query the document where Doctor IC matches
    QuerySnapshot SelectedData = await FirebaseFirestore.instance
        .collection("Selected") // 🔁 Replace with your actual collection name
        .where("Patients_Selected", arrayContains: globalIC)
        .get();

    if (SelectedData.docs.isNotEmpty) {
      // Step 2: Assuming we only want the first match
      var data = SelectedData.docs.first.data() as Map<String, dynamic>;

      // Step 3: Extract ICList
      String DocIc = data['Doctor_IC'] ?? '';
      globalDocIC = data['Doctor_IC'];
      List<dynamic> icList = data["Patients_Selected"];

      index = icList.indexOf(globalIC);
      String? DocName = await getDataWithCon("Doctor", "IC", DocIc, "Name");
      String? DocPhone = await getDataWithCon("Doctor", "IC", DocIc, "Phone Num");
      String? DocDepartment = await getDataWithCon("Doctor", "IC", DocIc, "Department");
      String? DocRoom = await getDataWithCon("Doctor", "IC", DocIc, "Room");
      String? DocRating = await getDataWithCon("Doctor", "IC", DocIc, "Rating");
      String? DocLevel = await getDataWithCon("Doctor", "IC", DocIc, "Level");
      String? DocProfilePic = await getDataWithCon("Doctor", "IC", DocIc, "Profile Pic");
      setState(() {
        DoctorName = DocName ?? '';
        DoctorPhone = DocPhone ?? '';
        DoctorDepartment = DocDepartment ?? '';
        DoctorRoom = DocRoom ?? '';
        DoctorRating = DocRating ?? '';
        DoctorLevel = DocLevel ?? '';
        DoctorProfilePic = DocProfilePic ?? '';
      });


      
      print('Index of globalIC: $index');

      
    } 
  } 
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Flexible(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[800], fontSize: 14),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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



  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    key: scaffoldKey,
    backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
    appBar: AppBar(
      backgroundColor: FlutterFlowTheme.of(context).primary,
      automaticallyImplyLeading: true,
      title: Text(
        'Check Queue',
        style: FlutterFlowTheme.of(context).titleLarge.override(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
      ),
      centerTitle: false,
      elevation: 2,
    ),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        child: Form(
          key: _model.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hospital Info
              Card(
                elevation: 4,
                child: ListTile(
                  title: Text(
                    hospitalName,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    hospitalAddress,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Ticket Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Your Ticket Number",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      actualticketNumber,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "$peopleInFront people ahead of you",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Queue Status
              Column(
                children: [
                  if (index == -1)
                    const Text(
                      "You have not been selected by the doctor yet.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (index == 1)
                    const Text(
                      "You have been selected by the doctor! (10 minutes remaining)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (index == 0)
                    const Text(
                      "You have been selected by the doctor! (5 minutes remaining)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (index == 2)
                    const Text(
                      "You have been selected by the doctor! (15 minutes remaining)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Doctor Info Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture with Room Number
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            DoctorProfilePic,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Room $DoctorRoom",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Doctor Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. $DoctorName",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Rating Row
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "$DoctorRating/5.0",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Text(
                                  "Top Rated",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Doctor Details
                          _buildInfoRow(Icons.local_hospital, "Department", DoctorDepartment),
                          _buildInfoRow(Icons.phone, "Contact", DoctorPhone),
                          _buildInfoRow(Icons.work_history, "Level", DoctorLevel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Spacer(),

              // Contact Info
              Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12), // Reduced padding to make it shorter
  decoration: BoxDecoration(
    color: Colors.blue[50],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.blueAccent),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Any questions? Feel free to contact us:",
        style: TextStyle(
          fontSize: 18, // Slightly smaller font
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
      const SizedBox(height: 8),
      // Horizontal phone numbers
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: phoneNumbers.map((number) => 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
        ).toList(),
      ),
    ],
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
