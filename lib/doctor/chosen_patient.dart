import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:mae_mediq_assignment/flutter_flow/flutter_flow_util.dart';
import '../../globals.dart' as globals;
import '/index.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Functions.dart';

class DoctorSelectedListPage extends StatefulWidget {
  static String routeName = 'Selected_Patient';
  static String routePath = '/Selected_Patient';

  @override
  _DoctorSelectedListPageState createState() => _DoctorSelectedListPageState();
}

class _DoctorSelectedListPageState extends State<DoctorSelectedListPage> {
  List<Map<String, dynamic>> items = [];
  bool isInProgress = false;

  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final db = FirebaseFirestore.instance;

    final selectedSnapshot = await db
        .collection('Selected')
        .where("Doctor_IC", isEqualTo: globals.globalIC)
        .get();

    if (selectedSnapshot.docs.isEmpty) return [];

    final selectedDoc = selectedSnapshot.docs.first;
    final List<dynamic> patientICs =
        selectedDoc.data()['Patients_Selected'] ?? [];

    final List<dynamic> patientStatus =
        selectedDoc.data()['Selected_Status'] ?? [];

    CheckInProgress(patientStatus);

    final List<Map<String, dynamic>> patients = [];

    for (int i = 0; i < patientICs.length; i++) {
      final ic = patientICs[i];
      final status = (i < patientStatus.length) ? patientStatus[i] : 0;

      final snapshot =
          await db.collection('Patient').where("IC", isEqualTo: ic).get();

      for (var doc in snapshot.docs) {
        final patientData = doc.data();
        patientData['Status'] = status;
        patients.add(patientData);
      }
    }

    return patients;
  }

  void CheckInProgress(List List) async {
    for (int index = 0; index < List.length; index++) {
      if (List[index] == 1) {
        setState(() {
          isInProgress = true;
        });
      }
    }
    ;
  }

  void loadData() async {
    final result = await fetchPatients();
    setState(() {
      items = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String getStatusText(dynamic status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "In Progress";
      case 2:
        return "Done";
      default:
        return "Unknown";
    }
  }

  Color getStatusColor(dynamic status) {
    switch (status) {
      case 0:
        return Colors.grey; // Pending
      case 1:
        return Colors.orange; // In Progress
      case 2:
        return Colors.green; // Done
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Patients'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pushNamed(
                DoctorDashbaordWidget.routeName); // This works with go_router
          },
        ),
        actions: [
          if (items.isNotEmpty && items.every((item) => item['Status'] == 2))
            IconButton(
              icon: Icon(Icons.delete_forever),
              tooltip: "Delete Selection",
              onPressed: () async {
                final db = FirebaseFirestore.instance;

                final snapshot = await db
                    .collection('Selected')
                    .where("Doctor_IC", isEqualTo: globals.globalIC)
                    .get();

                if (snapshot.docs.isEmpty) return;

                final doc = snapshot.docs.first;

                // Delete the whole document
                await doc.reference.delete();

                setState(() {
                  items.clear(); // Clear local list too
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selection document deleted.")),
                );
              },
            ),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final int currentStatus = item['Status'];
            final bool isPatientDone = currentStatus == 2;
            final bool anyInProgress = items.any((p) => p['Status'] == 1);
            final bool isCallDisabled = isPatientDone || anyInProgress;

            return Center(
              child: Container(
                width: screenWidth * 0.75,
                height: screenHeight * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent.withOpacity(0.9),
                      Colors.blueAccent.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: item['ProfilePicUrl'] != null
                          ? NetworkImage(item['ProfilePicUrl'])
                          : null,
                      child: item['ProfilePicUrl'] == null
                          ? Icon(Icons.person, size: 48, color: Colors.white)
                          : null,
                      backgroundColor: Colors.white30,
                    ),
                    SizedBox(height: 20),

                    // Info
                    Text(
                      item['Name'] ?? 'No Name',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Email: ${item['Email'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Gender: ${item['Gender'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "IC: ${item['IC'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 24),
                    // Status Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getStatusColor(item['Status']),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          getStatusText(item['Status']),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.open_in_new),
                      label: Text("View Record"),
                      onPressed: () {
                        context.pushNamed(
                          MedicalRecordListPage.routeName,
                          pathParameters: {'ic': item['IC']},
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Viewing ${item['Name']}'s record"),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[100],
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.call),
                      label: Text("Call"),
                      onPressed: !isCallDisabled
                          ? () async {
                              final db = FirebaseFirestore.instance;

                              final snapshot = await db
                                  .collection('Selected')
                                  .where("Doctor_IC",
                                      isEqualTo: globals.globalIC)
                                  .get();

                              if (snapshot.docs.isEmpty) {
                                print("No matching document found.");
                                return;
                              }

                              final doc = snapshot.docs.first;
                              final data = doc.data();

                              List<dynamic> patients =
                                  List.from(data['Patients_Selected'] ?? []);
                              List<dynamic> statuses =
                                  List.from(data['Selected_Status'] ?? []);

                              //check if any in progress?

                              final index = patients.indexOf(item['IC']);
                              if (index == -1) {
                                print("Patient not found in list.");
                                return;
                              }

                              while (statuses.length <= index) {
                                statuses.add(0);
                              }

                              setState(() {
                                item['Status'] = 1;
                              });

                              statuses[index] = 1;

                              // 4. Push back to Firestore
                              await doc.reference.update({
                                'Selected_Status': statuses,
                              });

                              print("Updated status for ${item['IC']} to 1.");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "${item['Name']} status updated to In Progress")),
                              );

                              storedocumentquery("Notifications",
                                  {"doctorIC": globals.globalIC,
                                   "message": "You are now being called. Please proceed to the consultation room.",
                                   "patientIC":item['IC'],
                                   "read": "false",
                                   "Timestamp" : FieldValue.serverTimestamp(), 
                                   });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
