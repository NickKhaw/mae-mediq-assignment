import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicalRecordListPage extends StatefulWidget {
  static const String routeName = 'Medical_Record_List';
  static const String routePath = '/MedicalRecordList/:ic';

  final String patientIC;

  const MedicalRecordListPage({
    Key? key,
    required this.patientIC,
  }) : super(key: key);

  @override
  _MedicalRecordListPageState createState() => _MedicalRecordListPageState();
}

class _MedicalRecordListPageState extends State<MedicalRecordListPage> {
  List<Map<String, dynamic>> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Record')
          .where('Patient_IC', isEqualTo: widget.patientIC)
          .get();

      final result = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        records = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching records: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Medical Records"),
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? Center(child: Text('No medical records found.'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5FF), // Light purple background
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.deepPurple.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with Department and Date
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  record['Department'] ?? 'General Medicine',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  record['Timestamp'] != null 
                                      ? DateFormat('MMM dd, yyyy').format(
                                          (record['Timestamp'] as Timestamp).toDate())
                                      : 'No date',
                                  style: TextStyle(
                                    color: Colors.deepPurple.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Diagnosis Section
                                _buildSection(
                                  icon: Icons.medical_services,
                                  title: "Diagnosis",
                                  content: record['Diagnosis'] ?? 'No diagnosis recorded',
                                ),
                                
                                SizedBox(height: 16),
                                
                                // Treatment Section
                                _buildSection(
                                  icon: Icons.medication,
                                  title: "Treatment",
                                  content: record['Treatment'] ?? 'No treatment specified',
                                ),
                                
                                SizedBox(height: 16),
                                
                                // Notes Section
                                _buildSection(
                                  icon: Icons.note,
                                  title: "Notes",
                                  content: record['Notes'] ?? 'No additional notes',
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.deepPurple,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 12),
          Divider(
            height: 1,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ],
      ],
    );
  }
}