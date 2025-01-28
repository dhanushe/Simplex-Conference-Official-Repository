import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'conference_view.dart';
import '../../api/logic/API.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../api/app_info.dart';
import '../../api/logic/authentication.dart';
import '../../api/objects/user_data.dart';
import '../../api/logic/parsing.dart';
import '../navigation/navigation.dart';
import 'login_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCreatingAccount = false;
  TextEditingController? text1;
  TextEditingController? text2;
  TextEditingController? text3;
  TextEditingController? text4;
  TextEditingController? text5;
  FocusNode? f;
  FocusNode? f2;
  FocusNode? f3;
  FocusNode? f4;
  FocusNode? f5;

  String firstName = "";
  String lastName = "";
  String nsdEmail = "";
  String accountPassword = "";
  String confirmPassword = "";
  String school = "";
  int grade = 9;
  bool agreed = false;
  bool agreed2 = false;
  late bool _passwordVisible1;
  late bool _passwordVisible2;

  @override
  void initState() {
    super.initState();
    API.setLight();
    _passwordVisible1 = false;
    _passwordVisible2 = false;
    text1 = TextEditingController();
    text2 = TextEditingController();
    text3 = TextEditingController();
    text4 = TextEditingController();
    text5 = TextEditingController();
    f = FocusNode();
    f2 = FocusNode();
    f3 = FocusNode();
    f4 = FocusNode();
    f5 = FocusNode();
  }

  @override
  void dispose() {
    text1!.dispose();
    text2!.dispose();
    text3!.dispose();
    text4!.dispose();
    text5!.dispose();
    f!.dispose();
    f2!.dispose();
    f3!.dispose();
    f4!.dispose();
    f5!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    Flexible(
                      child: AutoSizeText(
                        maxLines: 1,
                        'Create an Account',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 3, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'By creating an account with Google, you accept our ',
                              style: TextStyle(
                                fontFamily: 'ClashGrotesk',
                              ),
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                fontFamily: 'ClashGrotesk',
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _termsDialog(context);
                                },
                            ),
                            const TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                fontFamily: 'ClashGrotesk',
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: const TextStyle(
                                fontFamily: 'ClashGrotesk',
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _privacyDialog(context);
                                },
                            ),
                          ],
                          style: const TextStyle(
                            fontFamily: 'ClashGrotesk',
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !isCreatingAccount
                  ? Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (!isCreatingAccount) {
                            setState(() {
                              isCreatingAccount = true;
                            });

                            User? u = await Authentication.signInWithGoogle(
                                context: context);

                            if (u == null) {
                              setState(() {
                                isCreatingAccount = false;
                              });
                              return;
                            }

                            DocumentSnapshot userExists =
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(u.uid)
                                    .get();
                            bool b = userExists.exists;
                            if (b) {
                              await API().loadUser(_auth.currentUser!.uid);
                              if (AppInfo.currentUser.lastOpened != "") {
                                await API()
                                    .loadData(AppInfo.currentUser.lastOpened);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Navigation(
                                            pIndex: 0,
                                            reNav: false,
                                          )),
                                  (route) =>
                                      false, // This condition removes all previous routes
                                );
                                return;
                              }

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConferenceView()),
                                (route) =>
                                    false, // This condition removes all previous routes
                              );
                            } else {
                              String name =
                                  "${_auth.currentUser!.displayName!.split(" ")[0]} ${_auth.currentUser!.displayName!.split(" ").last}";
                              await API().addUser(name, _auth.currentUser!.uid,
                                  _auth.currentUser!.email!);
                              AppInfo.currentUser = UserData(
                                  name: name,
                                  id: _auth.currentUser!.uid,
                                  email: _auth.currentUser!.email!,
                                  lastOpened: "",
                                  conferences: []);

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ConferenceView()),
                                (route) =>
                                    false, // This condition removes all previous routes
                              );
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
                                child: Text(
                                  'Create with Google',
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
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: CircularProgressIndicator(color: Colors.black)),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: Text(
                        'OR',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: const Color(0xFF959595),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Your Name*',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: f!.hasFocus || f!.hasPrimaryFocus
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: TextFormField(
                    autocorrect: true,
                    focusNode: f,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          firstName = val;
                        },
                      );
                    },
                    onChanged: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          firstName = val;
                        },
                      );
                    },
                    controller: text1,
                    decoration: InputDecoration(
                      hintText: 'First Name*',
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
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: f2!.hasFocus || f2!.hasPrimaryFocus
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: TextFormField(
                    autocorrect: true,
                    focusNode: f2,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          lastName = val;
                        },
                      );
                    },
                    onChanged: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          lastName = val;
                        },
                      );
                    },
                    controller: text2,
                    decoration: InputDecoration(
                      hintText: 'Last Name*',
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
                      color: f2!.hasFocus || f2!.hasPrimaryFocus
                          ? const Color(0xFF226ADD)
                          : const Color(0xFF585858),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Account Information*',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: f3!.hasFocus || f3!.hasPrimaryFocus
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: TextFormField(
                    focusNode: f3,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          nsdEmail = val;
                        },
                      );
                    },
                    onChanged: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          nsdEmail = val;
                        },
                      );
                    },
                    controller: text3,
                    decoration: InputDecoration(
                      hintText: 'Email*',
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
                      color: f3!.hasFocus || f3!.hasPrimaryFocus
                          ? const Color(0xFF226ADD)
                          : const Color(0xFF585858),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: f4!.hasFocus || f4!.hasPrimaryFocus
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: TextFormField(
                    focusNode: f4,
                    textInputAction: TextInputAction.done,
                    obscureText: !_passwordVisible1,
                    onFieldSubmitted: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          accountPassword = val;
                        },
                      );
                    },
                    controller: text4,
                    onChanged: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          accountPassword = val;
                        },
                      );
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF7e7e7e),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible1 = !_passwordVisible1;
                          });
                        },
                      ),
                      hintText: 'Password*',
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
                      color: f4!.hasFocus || f4!.hasPrimaryFocus
                          ? const Color(0xFF226ADD)
                          : const Color(0xFF585858),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: f5!.hasFocus || f5!.hasPrimaryFocus
                        ? const Color(0xFFFBFBFB)
                        : const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  child: TextFormField(
                    focusNode: f5,
                    obscureText: !_passwordVisible2,
                    onFieldSubmitted: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          confirmPassword = val;
                        },
                      );
                    },
                    controller: text5,
                    onChanged: (val) {
                      setState(
                        () {
                          val = val.replaceAll(" ", "");
                          confirmPassword = val;
                        },
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Confirm Password*",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF7e7e7e),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible2 = !_passwordVisible2;
                          });
                        },
                      ),
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
                      color: f5!.hasFocus || f5!.hasPrimaryFocus
                          ? const Color(0xFF226ADD)
                          : const Color(0xFF585858),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    !agreed
                        ? InkWell(
                            onTap: () {
                              if (!agreed) {
                                setState(() {
                                  agreed = true;
                                });
                              }
                            },
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBFBFB),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF7E7E7E),
                                ),
                              ),
                            ))
                        : InkWell(
                            onTap: () {
                              if (agreed) {
                                setState(() {
                                  agreed = true;
                                });
                              }
                            },
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: const Color(0xFF007BFE),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF7E7E7E),
                                ),
                              ),
                              child: const Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xFFFBFBFB),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I accept the ',
                              style: GoogleFonts.getFont(
                                'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _termsDialog(context);
                                },
                            ),
                          ],
                          style: GoogleFonts.getFont(
                            'Poppins',
                            color: const Color(0xFF7E7E7E),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    !agreed2
                        ? InkWell(
                            onTap: () {
                              if (!agreed2) {
                                setState(() {
                                  agreed2 = true;
                                });
                              }
                            },
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBFBFB),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF7E7E7E),
                                ),
                              ),
                            ))
                        : InkWell(
                            onTap: () {
                              if (agreed2) {
                                setState(() {
                                  agreed2 = true;
                                });
                              }
                            },
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: BoxDecoration(
                                color: const Color(0xFF007BFE),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF7E7E7E),
                                ),
                              ),
                              child: const Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Icon(
                                  Icons.check,
                                  color: Color(0xFFFBFBFB),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I accept the ',
                              style: GoogleFonts.getFont(
                                'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _privacyDialog(context);
                                },
                            )
                          ],
                          style: GoogleFonts.getFont(
                            'Poppins',
                            color: const Color(0xFF7e7e7e),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 40),
                      child: !isCreatingAccount
                          ? InkWell(
                              onTap: () async {
                                if (!isCreatingAccount) {
                                  f!.unfocus();
                                  f2!.unfocus();
                                  f3!.unfocus();
                                  f4!.unfocus();
                                  f5!.unfocus();

                                  if (!agreed) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Error: Agree to the Terms of Service before continuing.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    if (agreed2) {
                                      firstName = firstName.replaceAll(" ", "");
                                      lastName = lastName.replaceAll(" ", "");
                                      String name = "$firstName $lastName";
                                      if (Parsing.isValidName(name)) {
                                        if (accountPassword !=
                                            confirmPassword) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error: Passwords do not match.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          try {
                                            setState(() {
                                              isCreatingAccount = true;
                                            });
                                            await _auth
                                                .createUserWithEmailAndPassword(
                                              email: nsdEmail,
                                              password: accountPassword,
                                            );
                                            await API().addUser(
                                                name,
                                                _auth.currentUser!.uid,
                                                _auth.currentUser!.email!);
                                            AppInfo.currentUser = UserData(
                                                name: name,
                                                id: _auth.currentUser!.uid,
                                                email:
                                                    _auth.currentUser!.email!,
                                                lastOpened: "",
                                                conferences: []);

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ConferenceView()),
                                              (route) =>
                                                  false, // This condition removes all previous routes
                                            );
                                          } catch (e) {
                                            if (e is FirebaseAuthException) {
                                              if (e.code == 'weak-password') {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Error: Password is not strong enough.",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else if (e.code ==
                                                  'email-already-in-use') {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Error: An account already exists with this email. Try Google Sign-in?",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else if (e.code ==
                                                  'invalid-email') {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Error: Email is invalid.",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                // Handle other Firebase Authentication errors
                                              }
                                            } else {
                                              // Handle other non-authentication related errors
                                            }
                                            setState(() {
                                              isCreatingAccount = false;
                                            });
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Name is not valid.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg:
                                            "Error: Agree to the Privacy Policy before continuing.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.873,
                                height: 33,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF226ADD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Text(
                                        'Done',
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.black),
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

  Future<void> _termsDialog(BuildContext context) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBFB),
            title: const Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          var uri = Uri.parse(
                              "https://sites.google.com/wesimplex.com/hello/terms-of-service?authuser=0");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {}
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27),
                            border: Border.all(
                              color: const Color(0xFF001535),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.open_in_new,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Text(
                                    'Open Terms of Service',
                                    style: GoogleFonts.getFont(
                                      color: Colors.black,
                                      'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        'By opening this, you are about to be redirected to an external service. Simplex is not responsible for any infringement on third party platforms.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ClashGrotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        elevation: 2,
                        backgroundColor:
                            const Color.fromARGB(255, 164, 151, 255),
                      ),
                      child: Text('I Agree',
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      onPressed: () {
                        setState(() {
                          okPressed = true;
                          Navigator.pop(context);
                          agreed = true;
                        });
                      },
                    ),
                  ],
                ),
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

  Future<void> _privacyDialog(BuildContext context) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBFB),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'ClashGrotesk',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          var uri = Uri.parse(
                              "https://sites.google.com/wesimplex.com/hello/privacy-policy?authuser=0");
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {}
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27),
                            border: Border.all(
                              color: const Color(0xFF001535),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.open_in_new,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Text(
                                    'Open Privacy Policy',
                                    style: GoogleFonts.getFont(
                                      color: Colors.black,
                                      'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        'By opening this, you are about to be redirected to an external service. Simplex is not responsible for any infringement on third party platforms.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ClashGrotesk',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        elevation: 2,
                        backgroundColor:
                            const Color.fromARGB(255, 164, 151, 255),
                      ),
                      child: Text('I Agree',
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      onPressed: () {
                        setState(() {
                          okPressed = true;
                          Navigator.pop(context);
                          agreed2 = true;
                        });
                      },
                    ),
                  ],
                ),
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
}
