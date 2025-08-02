import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mae_mediq_assignment/Functions.dart';
import 'package:mae_mediq_assignment/flutter_flow/flutter_flow_util.dart';
import 'package:mae_mediq_assignment/globals.dart';
import 'package:mae_mediq_assignment/index.dart';
import '../../Functions.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:google_fonts/google_fonts.dart';


class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  static String routeName = 'Review';
  static String routePath = '/review';

  

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 3.0;
  String _comment = '';
  bool _isSubmitting = false;
  String DocIC = '';
  String DocImage = '';
  String DocName = '';
  String DocSpecialization = '';
  double DocRating = 0;
  int DocRatedAmount = 0;

  @override
  void initState() {
    super.initState();
    getDoctorData();
  }

  Future<void> getDoctorData() async{
    final BookingData = await FirebaseFirestore.instance.collection("Booking")
    .where("IC", isEqualTo: globalIC)
    .where("Status", isEqualTo: 'Done')
    .get();
    if (BookingData.docs.isNotEmpty) {
      final data = BookingData.docs.first;
      setState(() {
        DocIC = data.get('Doctor_IC');
      });
      
    }
    final snapshot = await FirebaseFirestore.instance.collection("Doctor").where("IC", isEqualTo: DocIC).get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final ratedAmount = await countDataRowWithCon('Review', 'Doctor_IC', DocIC);
      setState(() {
        DocImage = doc.get('Profile Pic');
        DocName = doc.get('Name');
        DocSpecialization = doc.get('Department');
        DocRating = doc.get('Rating');
        DocRatedAmount = ratedAmount;
      });
      
    }
  }
  

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        
        await FirebaseFirestore.instance.collection('Review').add({
           'Doctor_IC': DocIC,
           'Star': _rating,
           'Comment': _comment,
           'Timestamp': FieldValue.serverTimestamp(),
           'Patient_IC': globalIC,
         });

         await _updateDocRating();
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thank You!'),
              content: const Text('Thanks for sharing your review.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Future.microtask(() {
                      context.pushNamed(PrecheckQueueWidget.routeName);
                    });
                  },
                ),
              ],
            );
          },
        );


        await getDoctorData();
        
        // Clear form after submission
        _formKey.currentState!.reset();
        setState(() {
          _rating = 3.0;
          _comment = '';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _updateDocRating() async {
  if (DocIC.isEmpty) return;
  
  final snapshot = await FirebaseFirestore.instance
      .collection('Doctor')
      .where('IC', isEqualTo: DocIC)
      .get();
      
  if (snapshot.docs.isNotEmpty) {
    final doc = snapshot.docs.first;
    final currentTotalRating = doc.get('Rating') * DocRatedAmount;
    final newTotalReviews = DocRatedAmount + 1;
    final newAverageRating = (currentTotalRating + _rating) / newTotalReviews;

    final roundedRating = double.parse(newAverageRating.toStringAsFixed(1));
    
    await FirebaseFirestore.instance
        .collection('Doctor')
        .doc(doc.id)
        .update({
          'Rating': roundedRating,
        });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F1F7),
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2),
        automaticallyImplyLeading: false,
        title: Text(
          'Leave a Review',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
                fontSize: 30.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
              ),
        ),
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
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Doctor Details Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(DocImage),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DocName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DocSpecialization,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.medical_services, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                "Seremban Hospital",
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '$DocRating ($DocRatedAmount reviews)',
                                style: const TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Review Form
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Rating Section
                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _rating,
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: _rating.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  _rating = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFF4A90E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Comment Section
                      const Text(
                        'Your Experience',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 5,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Share your experience with this doctor...',
                          hintStyle: const TextStyle(color: Colors.black54),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please share your experience';
                          }
                          return null;
                        },
                        onSaved: (value) => _comment = value ?? '',
                      ),
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _submitReview();
                            }
                          },
                          child: _isSubmitting
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Submit Review',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
