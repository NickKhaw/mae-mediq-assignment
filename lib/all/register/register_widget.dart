import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_model.dart';
export 'register_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  static String routeName = 'Register';
  static String routePath = '/register';

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late RegisterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late MaskTextInputFormatter icNumberMask;
  late MaskTextInputFormatter phoneNumberMask;

  @override
  void initState() {
    super.initState();

    icNumberMask = MaskTextInputFormatter(
      mask: '######-##-####',
      filter: {"#": RegExp(r'[0-9]')},
    );
    phoneNumberMask = MaskTextInputFormatter(
      mask: '###-#######',
      filter: {"#": RegExp(r'[0-9]')},
    );
    _model = createModel(context, () => RegisterModel());

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();

    _model.ICTextController ??= TextEditingController();
    _model.ICTextFocusNode ??= FocusNode();

    _model.phoneNumTextController ??= TextEditingController();
    _model.phoneNumFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  width: 100.0,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F1F7),
                  ),
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6F1F7),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/MediQ_-_Logo.png',
                              width: 250.0,
                              height: 250.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create an account',
                                  style: FlutterFlowTheme.of(context)
                                      .displaySmall
                                      .override(
                                        font: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: Color(0xFF101213),
                                        fontSize: 36.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 24.0),
                                  child: Text(
                                    'Let\'s get started by filling out the form below.',
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: Color(0xFF57636C),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Container(
                                      width: 370.0,
                                      child: Column(
                                        children: [
                                          // Email Field (without icon)
                                          TextFormField(
                                            controller: _model
                                                .emailAddressTextController,
                                            focusNode:
                                                _model.emailAddressFocusNode,
                                            autofillHints: [
                                              AutofillHints.email
                                            ],
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            cursorColor: Color(0xFF5BAAF5),
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              labelStyle: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFB0C4DE),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF5BAAF5),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 16),
                                            ),
                                            style: TextStyle(
                                              color: Color(0xFF2C3E50),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your Gmail address';
                                              }
                                              final gmailRegex = RegExp(
                                                r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                                                caseSensitive: false,
                                              );
                                              if (!gmailRegex.hasMatch(value)) {
                                                return 'Only Gmail addresses are allowed';
                                              }
                                              return null;
                                            },
                                          ),

                                          SizedBox(height: 16.0),

                                          // IC Field (without icon)
                                          TextFormField(
                                            controller: _model.ICTextController,
                                            focusNode: _model.ICTextFocusNode,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [icNumberMask],
                                            cursorColor: Color(0xFF5BAAF5),
                                            decoration: InputDecoration(
                                              labelText:
                                                  'IC Number (e.g. 041226-05-0053)',
                                              labelStyle: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFB0C4DE),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF5BAAF5),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 16),
                                            ),
                                            style: TextStyle(
                                              color: Color(0xFF2C3E50),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your IC number';
                                              }
                                              final icRegex = RegExp(
                                                  r'^\d{6}-\d{2}-\d{4}$');
                                              if (!icRegex.hasMatch(value)) {
                                                return 'IC must be in format 041226-05-0053';
                                              }
                                              return null;
                                            },
                                          ),

                                          SizedBox(height: 16.0),

                                          // Phone Number Field
                                          TextFormField(
                                            controller:
                                                _model.phoneNumTextController,
                                            focusNode: _model.phoneNumFocusNode,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [phoneNumberMask],
                                            cursorColor: Color(0xFF5BAAF5),
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Phone Number (e.g. 017-6682365)',
                                              labelStyle: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFB0C4DE),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF5BAAF5),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFE57373),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 16),
                                            ),
                                            style: TextStyle(
                                              color: Color(0xFF2C3E50),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your phone number';
                                              }
                                              final phoneRegex =
                                                  RegExp(r'^\d{3}-\d{7,8}$');
                                              if (!phoneRegex.hasMatch(value)) {
                                                return 'Phone must be in format 017-6682365';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Password fields remain the same
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: Container(
                                    width: 370.0,
                                    child: TextFormField(
                                      controller: _model.passwordTextController,
                                      focusNode: _model.passwordFocusNode,
                                      autofillHints: [AutofillHints.password],
                                      obscureText: !_model.passwordVisibility,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Color(0xFF888888),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFB0C4DE),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF5BAAF5),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model.passwordVisibility =
                                                !_model.passwordVisibility,
                                          ),
                                          child: Icon(
                                            _model.passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF57636C),
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: Color(0xFF5BAAF5),
                                      validator: _model
                                          .passwordTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),

                                // Confirm Password field
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: Container(
                                    width: 370.0,
                                    child: TextFormField(
                                      controller:
                                          _model.passwordConfirmTextController,
                                      focusNode:
                                          _model.passwordConfirmFocusNode,
                                      autofillHints: [AutofillHints.password],
                                      obscureText:
                                          !_model.passwordConfirmVisibility,
                                      decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                          color: Color(0xFF888888),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFB0C4DE),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF5BAAF5),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFE57373),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 16),
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model
                                                    .passwordConfirmVisibility =
                                                !_model
                                                    .passwordConfirmVisibility,
                                          ),
                                          child: Icon(
                                            _model.passwordConfirmVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF57636C),
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF2C3E50),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      cursorColor: Color(0xFF5BAAF5),
                                      validator: _model
                                          .passwordConfirmTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),

                                // Create Account Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (_model.passwordConfirmTextController
                                                .text ==
                                            _model
                                                .passwordTextController.text) {
                                          if (_model
                                                  .passwordConfirmTextController
                                                  .text
                                                  .isEmpty ||
                                              _model.passwordTextController.text
                                                  .isEmpty ||
                                              _model.ICTextController.text
                                                  .isEmpty ||
                                              _model.phoneNumTextController.text
                                                  .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Please fill in all fields."),
                                              ),
                                            );
                                            return;


                                          } else {

                                            bool icExists = await checkIcExisting(_model.ICTextController.text);

                                            if (icExists) {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text("Duplicate IC"),
                                                    content: Text("This IC is already registered. Please use a different one."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return; 
                                            }
                                            try {
                                              await FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                email: _model
                                                    .emailAddressTextController
                                                    .text,
                                                password: _model
                                                    .passwordTextController
                                                    .text,
                                              );

                                              // Add user to Firestore with phone number
                                              addUserToFirestore(
                                                  _model
                                                      .emailAddressTextController
                                                      .text,
                                                  _model.passwordTextController
                                                      .text,
                                                  _model.ICTextController.text,
                                                  genderIndentifier(_model
                                                      .ICTextController.text),
                                                  _model.phoneNumTextController
                                                      .text);

                                              // Show success dialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Success"),
                                                    content: Text(
                                                        "Your account has been successfully registered."),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          context.pushNamed(
                                                              LoginWidget
                                                                  .routeName);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code ==
                                                  'email-already-in-use') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("Alert"),
                                                      content: Text(
                                                          "Email is already registered."),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Error: ${e.message}")),
                                                );
                                              }
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Passwords do not match."),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    text: 'Create Account',
                                    options: FFButtonOptions(
                                      width: 370.0,
                                      height: 44.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 0.0),
                                      color: Color(0xFF4A90E2),
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),

                                // Sign In link
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 12.0),
                                  child: InkWell(
                                    onTap: () async {
                                      context.pushNamed(LoginWidget.routeName);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Already have an account? ',
                                            style: TextStyle(
                                              color: Color(0xFF57636C),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Sign In here',
                                            style: TextStyle(
                                              color: Color(0xFF4B39EF),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
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
              ),
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: 100.0,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            'https://images.unsplash.com/photo-1514924013411-cbf25faa35bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1380&q=80',
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> addUserToFirestore(String Email, String Password, String IC,
    String Gender, String PhoneNum) async {
  var db = FirebaseFirestore.instance;

  final record = <String, dynamic>{
    "Email": Email,
    "Password": Password,
    "IC": IC,
    "Name": await generateRandomUsername(),
    "Gender": Gender,
    "Phone Num": PhoneNum,
  };

  try {
    final docRef = await db.collection("Patient").add(record);
    print('DocumentSnapshot added with ID: ${docRef.id}');
  } catch (e) {
    print("Failed to add user: $e");
  }
}

Future<String> generateRandomUsername() async {
  final random = Random();
  var db = FirebaseFirestore.instance;

  while (true) {
    int randomNumber = random.nextInt(90000000) + 10000000;
    String number = 'user$randomNumber';
    final snapshot = await db
        .collection("Patient")
        .where("Username", isEqualTo: number)
        .get();

    if (snapshot.docs.isEmpty) {
      return number;
    }
  }
}

String genderIndentifier(String IC) {
  int lastDigit = int.parse(IC[IC.length - 1]);
  if (lastDigit % 2 == 0) {
    return "Female";
  } else {
    return "Male";
  }
}

Future<bool> checkIcExisting(String ic) async {
  var db = FirebaseFirestore.instance;
  final snapshot =
      await db.collection('Patient').where('IC', isEqualTo: ic).get();

  if (snapshot.docs.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
