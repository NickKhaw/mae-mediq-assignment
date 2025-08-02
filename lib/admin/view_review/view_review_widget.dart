import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mae_mediq_assignment/globals.dart';
import '../../Functions.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  static String routeName = 'ReviewsPage';
  static String routePath = '/reviewsPage';

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, String> _patientNamesCache = {};
  String? _doctorIC; // To store the doctor's IC number
  String? _doctorName; // To store the doctor's name

  @override
  void initState() {
    super.initState();
    // Fetch the doctor's IC when the page loads
    _fetchDoctorIC();
  }

  Future<void> _fetchDoctorIC() async {
    try {
      DocumentSnapshot doctorDoc = await _firestore
          .collection('Doctor')
          .doc(globalDoctorID) // Using the auto-generated ID
          .get();

      if (doctorDoc.exists) {
        setState(() {
          _doctorIC = doctorDoc['IC'] as String?; // Get the IC number from document
          _doctorName = doctorDoc['Name'] as String?; // Get the doctor's name
        });
      }
    } catch (e) {
      print('Error fetching doctor IC: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Doctor Reviews'),
    centerTitle: true,
    backgroundColor: const Color(0xFF4A90E2), // Blue AppBar like View Patient
  ),
  backgroundColor: const Color(0xFFE6F1F7), // Light blue background like View Patient
      body: _doctorIC == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Review')
                  .where('Doctor_IC', isEqualTo: _doctorIC) // Filter by IC number
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
  child: Text(
    'No reviews for this doctor yet',
    style: TextStyle(color: Colors.black),
  ),
);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final review = snapshot.data!.docs[index];
                    final data = review.data() as Map<String, dynamic>;

                    return FutureBuilder<String>(
                      future: _getPatientName(data['Patient_IC']),
                      builder: (context, nameSnapshot) {
                        final patientName = nameSnapshot.data ?? 'Loading...';
                        
                        return Card(
  color: Colors.white,
  margin: const EdgeInsets.only(bottom: 16),
  elevation: 2,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Doctor Name only
        Text(
          'Doctor: $_doctorName',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Patient Name only
        Text(
          'Patient: $patientName',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Rating
        Row(
          children: [
            const Text(
              'Rating: ',
              style: TextStyle(color: Colors.black),
            ),
            _buildRatingStars(data['Star']?.toDouble() ?? 0),
            Text(
              ' (${data['Star'] ?? 0})',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Comment
        Text(
          'Comment: ${data['Comment'] ?? 'No comment'}',
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),

        // Timestamp
        Text(
          'Date: ${_formatTimestamp(data['Timestamp'])}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),
);
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Future<String> _getPatientName(String patientIC) async {
    if (_patientNamesCache.containsKey(patientIC)) {
      return _patientNamesCache[patientIC]!;
    }
    
    try {
      final name = await getDataWithCon('Patient', 'IC', patientIC,'Name');
      _patientNamesCache[patientIC] = name ?? 'Unknown Patient';
      return _patientNamesCache[patientIC]!;
    } catch (e) {
      return 'Error loading name';
    }
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : (index < rating ? Icons.star_half : Icons.star_border),
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp is Timestamp) {
        return DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
      }
      return 'Unknown date';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
