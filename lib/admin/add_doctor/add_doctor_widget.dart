import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../globals.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddDoctorWidget extends StatefulWidget {
  const AddDoctorWidget({super.key});

  static String routeName = 'AddDoctor';
  static String routePath = '/addDoctor';

  @override
  State<AddDoctorWidget> createState() => _AddDoctorWidgetState();
}

class _AddDoctorWidgetState extends State<AddDoctorWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Form controllers
  final TextEditingController _icController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _gender;
  String? _level;
  String? _department;
  String? _room;

  // Department options
  final List<String> _departments = [
    'General Medicine',
    'Pediatrics',
    'Cardiology',
    'Neurology',
    'Gynecology',
    'ENT'
  ];

  // Level options
  final List<String> _levels = [
    'Junior Doctor',
    'Senior Doctor',
    'Consultant',
    'Specialist',
    'Internship'
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _icController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store additional doctor data in Firestore
      await _firestore.collection('Doctor').doc(userCredential.user!.uid).set({
        'IC': _icController.text.trim(),
        'Email': _emailController.text.trim(),
        'Name': _nameController.text.trim(),
        'Phone Num': _phoneController.text.trim(),
        'Password': _passwordController.text.trim(),
        'Gender': _gender,
        'Level': _level,
        'Department': _department,
        'Room': _room,
        'Profile Pic': '',
        'Status': false,
        'Rating': 0,
         // For role-based access control
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doctor added successfully!')),
      );

      // Clear form after submission
      _formKey.currentState!.reset();
      setState(() {
        _gender = null;
        _level = null;
        _department = null;
        _room = null;
        _isLoading = false;
      });

    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding doctor: ${e.toString()}')),
      );
    }
  }

  final icFormatter = MaskTextInputFormatter(
    mask: '######-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '###-########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add New Doctor'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IC Number
              TextFormField(
                controller: _icController,
                inputFormatters: [icFormatter],
                decoration: InputDecoration(
                  labelText: 'IC Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IC number';
                  }else if (!RegExp(r'^\d{6}-\d{2}-\d{4}$').hasMatch(value)) {
                    return 'Invalid IC format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                inputFormatters: [phoneFormatter],
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _gender = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Level Dropdown
              DropdownButtonFormField<String>(
                value: _level,
                decoration: InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                items: _levels
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _level = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Department Dropdown
              DropdownButtonFormField<String>(
                value: _department,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                items: _departments
                    .map((dept) => DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _department = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Room Selection
              DropdownButtonFormField<String>(
                value: _room,
                decoration: InputDecoration(
                  labelText: 'Room',
                  border: OutlineInputBorder(),
                ),
                items: ['R1','R2','R3','R4','R5']
                    .map((room) => DropdownMenuItem(
                          value: room,
                          child: Text(room),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _room = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add Doctor'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
