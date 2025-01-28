// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

import '../../api/logic/API.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? text1;
  bool isResetting = false;
  FocusNode? f;
  String email = "";
  @override
  void initState() {
    super.initState();
    API.setLight();
    text1 = TextEditingController();

    f = FocusNode();
  }

  @override
  void dispose() {
    text1!.dispose();

    f!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: SingleChildScrollView(
        // Use a SingleChildScrollView
        // Set resizeToAvoidBottomInset to true
        // This will resize the content to avoid the keyboard
        // while still keeping the page non-scrollable
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black,
                  width: MediaQuery.sizeOf(context).width,
                  height: 191,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 90, 25, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              child: Image.asset(
                                'assets/images/appicondisplay.png',
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Simplex Conference',
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(-1.0, 0.0);
                                  const end = Offset.zero;
                                  final tween = Tween(begin: begin, end: end);
                                  final offsetAnimation =
                                      animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                              width: 90,
                              height: 26,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 15,
                                      color: Color(0xFF4E4E4E),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        'Back',
                                        style: TextStyle(
                                            fontFamily: 'ClashGrotesk',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color(0xFF4E4E4E)),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                  ]))),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 18, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Enter your email to receive a reset link.',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 18, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Your Email',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.88,
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        value = value.replaceAll(" ", "");
                        email = value;
                        setState(() {});
                      },
                      onChanged: (value) {
                        value = value.replaceAll(" ", "");
                        email = value;
                        setState(() {});
                      },
                      controller: text1,
                      obscureText: false,
                      focusNode: f,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        hintStyle: GoogleFonts.getFont(
                          fontWeight: FontWeight.w400,
                          'Poppins',
                          color: const Color(0xFF7E7E7E),
                          fontSize: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF226ADD),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(22, 6, 15, 6),
                      ),
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: f!.hasFocus || f!.hasPrimaryFocus
                            ? const Color(0xFF226ADD)
                            : const Color(0xFF585858),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          // do the reset password thingy
                          bool success = true;
                          try {
                            await _auth.sendPasswordResetEmail(email: email);
                          } catch (e) {
                            success = false;

                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'invalid-email':
                                  Fluttertoast.showToast(
                                    msg:
                                        "Error: Invalid email inputted. Did you make a typo?",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  break;
                                case 'user-not-found':
                                  Fluttertoast.showToast(
                                    msg:
                                        "Error: Email is not associated with a Simplex Conference user account.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  break;
                                default:
                                  Fluttertoast.showToast(
                                    msg:
                                        "Error with trying to send email. Please try again later.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                              }
                            }
                          }

                          if (success) {
                            Fluttertoast.showToast(
                              msg:
                                  "Email sent! Check your inbox for a link to follow.",
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          width: 165,
                          height: 30,
                          decoration: BoxDecoration(
                            color: email != ""
                                ? const Color(0xFF226ADD)
                                : const Color(0xFFB8B8B8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
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
