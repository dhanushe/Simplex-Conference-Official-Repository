// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../admin/login/welcome_screen.dart';
import 'welcome_screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/objects/conference_data.dart';

import '../../api/logic/dates.dart';
import '../navigation/navigation.dart';
import '../../api/logic/authentication.dart';
import 'welcome_screen.dart';

class ConferenceView extends StatefulWidget {
  const ConferenceView({super.key});

  @override
  State<ConferenceView> createState() => _ConferenceViewState();
}

class _ConferenceViewState extends State<ConferenceView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSigningOut = false;
  bool isJoiningConference = false;
  List<Widget> conferenceItems = [];
  List<ConferenceData> conferences = [];
  bool dataLoaded = false;
  bool linkGoogle = false;
  bool isLinking = false;
  bool isDeleting = false;

  _ConferenceViewState() {
    API().getConferences().then((value) {
      conferences = value;

      conferenceItems = getConferenceWidgets();
      dataLoaded = true;
      setState(() {});
    });
  }

  @override
  void initState() {
    API.setDark();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dataLoaded) {
      conferenceItems = getConferenceWidgets();
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFBFBFB),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 1,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFBFBFB),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 65, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset(
                        'assets/images/confviewasset.png',
                        height: 28,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: PopupMenuButton(
                            color: const Color(0xFFEDEDED),
                            onSelected: (value) {
                              _onMenuItemSelected(value as int);
                            },
                            itemBuilder: (ctx) => [
                              _buildPopupMenuItem(
                                  'Terms of Service', Icons.security, 0),
                              _buildPopupMenuItem(
                                  'Privacy Policy', Icons.lock_outline, 1),
                              _buildPopupMenuItem(
                                'Account Info',
                                Icons.account_circle_outlined,
                                2,
                              ),
                              _buildPopupMenuItem(
                                'Delete Account',
                                Icons.delete,
                                3,
                              )
                            ],
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Color(0xff000000),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (!isSigningOut) {
                              await Authentication.signOut(context: context);
                              if (!kIsWeb) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen()),
                                  (route) =>
                                      false, // This condition removes all previous routes
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminWelcomePage()),
                                  (route) =>
                                      false, // This condition removes all previous routes
                                );
                              }
                              setState(() {
                                isSigningOut = true;
                              });
                            }
                          },
                          child: Container(
                            width: 102,
                            height: 25,
                            decoration: BoxDecoration(
                              color: const Color(0xff000000),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(25, 40, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Welcome,',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontWeight: FontWeight.w400,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AutoSizeText(
                      AppInfo.currentUser.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontWeight: FontWeight.w600,
                        fontSize: (!kIsWeb && Platform.isIOS) ? 32 : 28,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Active Conferences',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              dataLoaded
                  ? Column(children: conferenceItems)
                  : const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: CircularProgressIndicator(color: Colors.black)),
              const SizedBox(height: 25),

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        showCustomDialog(context);
                      },
                      child: Container(
                          width: 300,
                          height: 48,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF070650),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(40)),
                          child: const Align(
                              alignment: Alignment.center,
                              child: Text('Join a Conference',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF070650))))),
                    ),
                  ]),

              const SizedBox(height: 15),

              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.max,
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => GoogleMapsPage(
              //                       conferences: conferences,
              //                     )),
              //             // This condition removes all previous routes
              //           );
              //         },
              //         child: Container(
              //             width: 300,
              //             height: 48,
              //             decoration: BoxDecoration(
              //                 border: Border.all(
              //                   color: Color(0xFF070650),
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(40)),
              //             child: Align(
              //                 alignment: Alignment.center,
              //                 child: Text('Browse Local Conferences',
              //                     style: TextStyle(
              //                         fontFamily: 'Poppins',
              //                         color: Color(0xFF070650))))),
              //       ),
              //     ]),

              dataLoaded && !linkGoogle
                  ? Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Link Google Account',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),

              dataLoaded && !linkGoogle
                  ? Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              'You can link your Google account to your Simplex Conference account so that next time you sign in, you can use your Google account.',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              dataLoaded && !linkGoogle
                  ? !isLinking
                      ? Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                isLinking = true;
                              });

                              AuthCredential? user =
                                  await Authentication.linkGoogle(
                                      context: context);
                              if (user == null) {
                                setState(() {
                                  isLinking = false;
                                });
                                return;
                              } else {
                                try {
                                  UserCredential? u;
                                  u = await FirebaseAuth.instance.currentUser
                                      ?.linkWithCredential(user);
                                  Fluttertoast.showToast(
                                    msg: "Successfully linked Google account!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  setState(() {
                                    isLinking = false;
                                    linkGoogle = true;
                                  });
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    switch (e.code) {
                                      case 'provider-already-linked':
                                        Fluttertoast.showToast(
                                          msg:
                                              "Google credential is already linked.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        break;
                                      case 'invalid-credential':
                                        Fluttertoast.showToast(
                                          msg: "Credential is invalid.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        break;
                                      case 'credential-already-in-use':
                                        Fluttertoast.showToast(
                                          msg:
                                              "Credential is already being used.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        break;
                                      case 'email-already-in-use':
                                        Fluttertoast.showToast(
                                          msg: "Email is already in usage.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        break;
                                      default:
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg:
                                          "An unknown error occurred, please try again later.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                  setState(() {
                                    isLinking = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.88,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBFBFB),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xFF585858),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 23,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: Text(
                                      'Link Google Account',
                                      style: GoogleFonts.getFont(
                                        'Poppins',
                                        color: const Color(0xFF585858),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      : const Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: CircularProgressIndicator(color: Colors.black))
                  : const SizedBox(),

              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
              //   child: Container(
              //     width: MediaQuery.sizeOf(context).width * 0.873,
              //     height: 250,
              //     decoration: const BoxDecoration(
              //       color: Colors.black,
              //     ),
              //     child: const Align(
              //       alignment: AlignmentDirectional(0, 0),
              //       child: Text(
              //         'placholder for ad thing',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 13,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmOpenLinkDialog(BuildContext context, String s) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBFB),
            title: const Text(
              'Hey!',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You are being directed to an external third-party application by opening this link. Simplex bears no responsibility for any violations on third-party platforms.\n\nLink: $s',
                      style: GoogleFonts.getFont(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w400,
                        'Poppins',
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 2,
                      backgroundColor: const Color.fromARGB(255, 186, 186, 186),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.getFont(
                            color: Colors.black, 'Poppins')),
                    onPressed: () {
                      setState(() {
                        okPressed = true;
                        Navigator.pop(context);
                      });
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 2,
                      backgroundColor: const Color.fromARGB(255, 164, 151, 255),
                    ),
                    child: Text('Open',
                        style: GoogleFonts.getFont(
                            color: Colors.black, 'Poppins')),
                    onPressed: () async {
                      var uri = Uri.parse(s);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        }).then((val) async {
      if (!okPressed) {
        return;
      }

      setState(() {});
    });
  }

  Future<void> _accountDialog(BuildContext context) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              'Account Information',
              style: GoogleFonts.getFont(
                fontSize: 20,
                color: const Color.fromARGB(255, 0, 0, 0),
                'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'If you believe that any information with your account is incorrect, should be changed, or want your data/account removed, reach out to ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: 'ncfbla.app@gmail.com',
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
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
                            const TextSpan(
                              text:
                                  ' with your request and we will get back to you.',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 2,
                      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
                    ),
                    child: const Text('Close',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    onPressed: () {
                      setState(() {
                        okPressed = true;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        }).then((val) async {
      if (!okPressed) {
        return;
      }

      setState(() {});
    });
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 20,
            color: Colors.black,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'ClashGrotesk',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) async {
    if (value == 0) {
      _confirmOpenLinkDialog(context,
          "https://sites.google.com/wesimplex.com/home/terms-of-service");
    } else if (value == 1) {
      _confirmOpenLinkDialog(context,
          "https://sites.google.com/wesimplex.com/home/privacy-policy");
    } else if (value == 2) {
      _accountDialog(context);
    } else if (value == 3) {
      await _deleteDialog(context);

      if (isDeleting) {
        await API().deleteUserById(AppInfo.currentUser.id);
        await Authentication.signOut(context: context);

        AppInfo.isAdmin = false;
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WelcomeScreen(),
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
          (route) => false,
        );
        isDeleting = false;
      }
    }
  }

  Future<bool> _deleteDialog(BuildContext context) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFFFFFF),
            // title: const Text(
            //   'New Account',
            //   style: TextStyle(
            //     fontSize: 20,
            //     color: Color.fromARGB(255, 0, 0, 0),
            //     fontFamily: 'ClashGrotesk',
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                        "Are you sure you want to delete your account? This action cannot be reversed.",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ClashGrotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            actions: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFF92190C),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          // side: BorderSide(
                          //   color: Color(0xFFEFEFEF), // Border color
                          //   width: 2, // Border width
                          // ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        child: Text(
                          "Yes, delete my account.",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'ClashGrotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      onPressed: () {
                        isDeleting = true;
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color(0xFFEFEFEF), // Border color
                            width: 2, // Border width
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                        child: Text(
                          "No, go back.",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'ClashGrotesk',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      onPressed: () {
                        okPressed = true;
                        isDeleting = false;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).then((val) async {
      if (!okPressed) {
        return false;
      }
      isDeleting = false;

      return true;
    });
  }

  List<Widget> getConferenceWidgets() {
    List<Widget> items = [];
    for (ConferenceData c in conferences) {
      items.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.88,
            height: 232,
            decoration: BoxDecoration(
              color: const Color(0xFF010030),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  height: 232,
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.2,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.88,
                          height: 232,
                          decoration: BoxDecoration(
                            color: const Color(0xFF010030),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.asset(
                                'assets/images/homebg.png',
                              ).image,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(30, 20, 30, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: CachedNetworkImage(
                                    imageUrl: c.logo,
                                    height: 33,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: AutoSizeText(
                                  c.name,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontFamily: 'ClashGrotesk',
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                c.desc,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontFamily: 'ClashGrotesk',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.88,
                          height: 66,
                          decoration: const BoxDecoration(
                            color: Color(0xFF070650),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                30, 0, 30, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.location,
                                      style: const TextStyle(
                                        fontFamily: 'ClashGrotesk',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(
                                        Dates.formatDateRange(
                                            c.startDate, c.endDate),
                                        style: const TextStyle(
                                          fontFamily: 'ClashGrotesk',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                !isJoiningConference
                                    ? InkWell(
                                        onTap: () async {
                                          if (!isJoiningConference) {
                                            setState(() {
                                              isJoiningConference = true;
                                            });
                                            if (!AppInfo.currentUser.conferences
                                                .contains(c.id)) {
                                              await API().addConferenceUser(
                                                  c.id, AppInfo.currentUser);
                                              await API().updateUserConference(
                                                  AppInfo.currentUser, c.id);
                                              await API().loadData(c.id);
                                              API().joinConference(
                                                  AppInfo.currentUser, c.id);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Navigation(
                                                            reNav: false,
                                                            pIndex: 0)),
                                                (route) =>
                                                    false, // This condition removes all previous routes
                                              );
                                            } else {
                                              await API().loadData(c.id);
                                              API().joinConference(
                                                  AppInfo.currentUser, c.id);

                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Navigation(
                                                            reNav: false,
                                                            pIndex: 0)),
                                                (route) =>
                                                    false, // This condition removes all previous routes
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 74,
                                          height: 21,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Text(
                                              'Join',
                                              style: TextStyle(
                                                fontFamily: 'ClashGrotesk',
                                                color: Color(0xFF226ADD),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ))
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3.0,
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
        ),
      );
    }
    return items;
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textFieldController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Conference Code'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Type code here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
            !isJoiningConference
                ? ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      // Handle the submit action here
                      String enteredText = textFieldController.text;
                      enteredText = enteredText.toLowerCase();
                      for (ConferenceData c in conferences) {
                        if (c.code.toLowerCase() == enteredText) {
                          if (AppInfo.currentUser.conferences.contains(c.id)) {
                            Fluttertoast.showToast(
                              msg: "Already joined this conference.",
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            return;
                          } else {
                            if (!isJoiningConference) {
                              setState(() {
                                isJoiningConference = true;
                              });
                              if (!AppInfo.currentUser.conferences
                                  .contains(c.id)) {
                                await API().addConferenceUser(
                                    c.id, AppInfo.currentUser);
                                await API().updateUserConference(
                                    AppInfo.currentUser, c.id);
                                await API().loadData(c.id);
                                API().joinConference(AppInfo.currentUser, c.id);
                                AppInfo.currentUser.conferences.add(c.id);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Navigation(reNav: false, pIndex: 0)),
                                  (route) =>
                                      false, // This condition removes all previous routes
                                );
                              } else {
                                await API().loadData(c.id);
                                API().joinConference(AppInfo.currentUser, c.id);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Navigation(reNav: false, pIndex: 0)),
                                  (route) =>
                                      false, // This condition removes all previous routes
                                );
                              }
                            }

                            return;
                          }
                        }
                      }

                      Fluttertoast.showToast(
                        msg: "Code is not valid.",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      // Closes the dialog
                    },
                  )
                : const CircularProgressIndicator(color: Colors.black),
          ],
        );
      },
    );
  }
}
