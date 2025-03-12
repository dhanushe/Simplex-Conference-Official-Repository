// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../api/logic/API.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ErrorPageState() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    API.setLight();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double extraPadding = 15.0;
    if (!kIsWeb) {
      if ((!kIsWeb && Platform.isIOS)) extraPadding = 25.0;
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFBFBFB),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 1,
        decoration: const BoxDecoration(
          color: Color(0xFFFBFBFB),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      25, 35 + extraPadding, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/darklogoname.png',
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 40, 0, 0),
                    child: Text(
                      'Uh oh...',
                      style: TextStyle(
                        fontFamily: 'RedHatDisplay',
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 8, 0, 0),
                    child: Text(
                      'We ran into\nan error',
                      style: TextStyle(
                        fontFamily: 'RedHatDisplay',
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Please try again.\n',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' It\'s possible that your account has been removed and deleted.\n',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: '\nFor all issues, please contact ',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'ncfbla.app@gmail.com.',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final Uri params = Uri(
                                  scheme: 'mailto',
                                  path: 'ncfbla.app@gmail.com',
                                  query:
                                      'subject=[Subject]&body=[Body]', //add subject and body here
                                );

                                if (await canLaunchUrl(params)) {
                                  await launchUrl(params);
                                } else {
                                  throw 'Could not launch $params';
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 200),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 200),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(-1.0, 0.0);
                            const end = Offset.zero;
                            final tween = Tween(begin: begin, end: end);
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(48),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25, 0, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back to Login',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}
