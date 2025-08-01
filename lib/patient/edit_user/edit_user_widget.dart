import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'edit_user_model.dart';
export 'edit_user_model.dart';
import '../../all/function.dart';
import 'package:mae_mediq_assignment/globals.dart' as globals;
import '../../all/profile/profile_widget.dart';

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({super.key});

  static String routeName = 'Edit_User';
  static String routePath = '/editUser';

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  late EditUserModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String globalPassword = globals.globalPassword;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditUserModel());

    _model.textController1 ??= TextEditingController(text: globals.globalName);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: globals.globalPhone);
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(text: globals.globalEmail);
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.dropDownValueController ??=
        FormFieldController<String>(globals.globalGender);
    _model.dropDownValue = globals.globalGender;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _updateEmail(String newEmail) async {
    try {
      // Validate email format
      if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(newEmail)) {
        return false;
      }

      // Check if email already exists
      try {
        await _auth.createUserWithEmailAndPassword(
          email: newEmail,
          password: globalPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          return false;
        }
        rethrow;
      }

      // Sign in with new user
      await _auth.signInWithEmailAndPassword(
        email: newEmail,
        password: globalPassword,
      );

      // Delete old user if email changed
      if (globals.globalEmail != newEmail) {
        UserCredential oldUserCredential =
            await _auth.signInWithEmailAndPassword(
          email: globals.globalEmail,
          password: globalPassword,
        );

        await oldUserCredential.user?.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: globals.globalEmail,
            password: globalPassword,
          ),
        );
        await oldUserCredential.user?.delete();

        // Re-sign in to new user
        await _auth.signInWithEmailAndPassword(
          email: newEmail,
          password: globalPassword,
        );
      }

      // Update Firestore
      await updateData(
        globals.globalRole,
        "IC",
        globals.globalIC,
        "Email",
        newEmail,
      );

      // Update global state
      globals.globalEmail = newEmail;

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateOtherFields(
      String name, String gender, String phone) async {
    await Future.wait([
      updateData(globals.globalRole, "IC", globals.globalIC, "Name", name),
      updateData(globals.globalRole, "IC", globals.globalIC, "Gender", gender),
      updateData(
          globals.globalRole, "IC", globals.globalIC, "Phone Num", phone),
    ]);
  }

  void _showSuccessAndNavigate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      context.pushNamed(ProfileWidget.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFE6F1F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A90E2),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Edit Profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 32.0, 24.0, 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Full Name Field
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Name',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB0C4DE),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.black),
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),

                        // IC Number Field
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'IC Number',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: const Color(0xFFB0C4DE),
                                  width: 2.0,
                                ),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      globals.globalIC,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF757575),
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),

                        // Gender Field
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController,
                              options: const ['Male', 'Female'],
                              onChanged: (val) =>
                                  setState(() => _model.dropDownValue = val),
                              height: 48.0,
                              textStyle:
                                  FlutterFlowTheme.of(context).bodyMedium.copyWith(color: Colors.black),
                              hintText: 'Select...',
                              fillColor:Colors.white,
                              borderColor: const Color(0xFFB0C4DE),
                              borderWidth: 2.0,
                              borderRadius: 8.0,
                              elevation: 2,
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  12, 4, 12, 4),
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),

                        // Phone Number Field
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextFormField(
                              controller: _model.textController2,
                              focusNode: _model.textFieldFocusNode2,
                              decoration: InputDecoration(
                                hintText: 'e.g. 012-3456789',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB0C4DE),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    String text = newValue.text;
                                    if (text.length > 3 &&
                                        !text.contains('-')) {
                                      text =
                                          '${text.substring(0, 3)}-${text.substring(3)}';
                                      return TextEditingValue(
                                        text: text,
                                        selection: TextSelection.collapsed(
                                            offset: text.length),
                                      );
                                    }
                                    return newValue;
                                  },
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (!RegExp(r'^\d{3}-\d{7,8}$')
                                    .hasMatch(value)) {
                                  return 'Enter valid format (e.g. 012-3456789)';
                                }
                                return null;
                              },
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),

                        // Email Field
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email Address',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            TextFormField(
                              controller: _model.textController3,
                              focusNode: _model.textFieldFocusNode3,
                              decoration: InputDecoration(
                                hintText: 'Enter your Gmail address',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB0C4DE),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!value.endsWith('@gmail.com') ||
                                    !RegExp(r'^[\w-\.]+@gmail\.com$')
                                        .hasMatch(value)) {
                                  return 'Please enter a valid Gmail address';
                                }
                                return null;
                              },
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),
                      ].divide(const SizedBox(height: 24.0)),
                    ),
                  ),

                  // Save Changes Button
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 30.0, 0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        if (_model.formKey.currentState?.validate() ?? false) {
                          final name = _model.textController1.text.trim();
                          final gender =
                              _model.dropDownValue ?? globals.globalGender;
                          final phone = _model.textController2.text.trim();
                          final newEmail = _model.textController3.text.trim();

                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );

                          try {
                            bool emailUpdateSuccess = true;
                            if (newEmail != globals.globalEmail) {
                              emailUpdateSuccess = await _updateEmail(newEmail);
                              if (!emailUpdateSuccess) {
                                Navigator.of(context).pop(); // Close loading
                                showErrorDialog(
                                    context, "This email is already registered.");
                                return;
                              }
                            }

                            await _updateOtherFields(name, gender, phone);

                            // Update global state
                            globals.globalName = name;
                            globals.globalGender = gender;
                            globals.globalPhone = phone;

                            Navigator.of(context).pop(); 
                            _showSuccessAndNavigate(context);
                          } catch (e) {
                            Navigator.of(context).pop(); 
                            showErrorDialog(context,
                                "An error occurred: ${e.toString()}");
                          }
                        }
                      },
                      text: 'Save Changes',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: const EdgeInsets.all(8.0),
                        color: const Color(0xFF4A90E2),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter Tight',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}