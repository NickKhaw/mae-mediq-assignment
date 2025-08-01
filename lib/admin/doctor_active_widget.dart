import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorActiveWidget extends StatefulWidget {
  const DoctorActiveWidget({Key? key}) : super(key: key);
  static String routeName = 'Active_Doctor';
  static String routePath = '/ActiveDoctor';

  @override
  _DoctorActiveWidgetState createState() => _DoctorActiveWidgetState();
}

class _DoctorActiveWidgetState extends State<DoctorActiveWidget> {
  // Sample doctor data
  final List<Map<String, dynamic>> _doctors = [];

  String? _selectedDepartment;
  List<Map<String, dynamic>> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = _doctors;
    fetctDataInListFormat();
  }

void fetctDataInListFormat() async {
  var db = FirebaseFirestore.instance;
  final snapshot = await db.collection("Doctor").where("Status", isEqualTo: true).get();

  final loadedDoctors = snapshot.docs.map((doc) => doc.data()).toList();

  setState(() {
    _doctors.addAll(loadedDoctors);
    _filteredDoctors = _doctors;
  });
}


  List<String> _getDepartments() {
    return [
      'All',
      ..._doctors.map((doctor) => doctor['Department']!).toSet().toList()
    ];
  }

  void _filterDoctors(String? department) {
    setState(() {
      _selectedDepartment = department;
      if (department == 'All' || department == null) {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors = _doctors
            .where((doctor) => doctor['Department'] == department)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFE6F1F7), // same as View Patient page
  appBar: AppBar(
    title: const Text(
      'Doctors List',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: const Color(0xFF4A90E2), // same blue as View Patient page
    elevation: 0,
  ),
      body: Column(
        children: [
          // Filter and Total Count Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF4A90E2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filter Dropdown
                DropdownButton<String>(
                  value: _selectedDepartment ?? 'All',
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  items: _getDepartments().map((department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(
                        department,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: _filterDoctors,
                ),
                // Total Count
                Text(
                  'Total: ${_filteredDoctors.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Doctor List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return Card(
                  color: Colors.white, // ⬅️ Set container background color
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Doctor Avatar
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            doctor['Name']![3], // First letter of name
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Doctor Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor['Name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
  doctor['Department']!,
  style: const TextStyle(
    fontSize: 16,
    color: Colors.indigo, // dark blue
    fontWeight: FontWeight.w600,
  ),
),
const SizedBox(height: 4),
Text(
  'IC: ${doctor['IC']}',
  style: const TextStyle(
    fontSize: 14,
    color: Colors.black, // black IC text
  ),
),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
