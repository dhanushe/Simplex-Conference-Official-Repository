// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplex_conference_redo_repo/app/login/reset_password.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/logic/authentication.dart';
import '../../api/objects/user_data.dart';
import '../navigation/navigation.dart';
import 'conference_view.dart';
import 'create_account.dart';
import 'error_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? text1;
  bool isSigningIn = false;
  TextEditingController? text2;
  FocusNode? f;
  FocusNode? f2;
  String email = "";
  String password = "";
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    API.setLight();
    text1 = TextEditingController();
    text2 = TextEditingController();
    f = FocusNode();
    f2 = FocusNode();
  }

  @override
  void dispose() {
    text1!.dispose();
    text2!.dispose();
    f!.dispose();
    f2!.dispose();
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
                            'Sielify',
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Login',
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: f!.hasFocus || f!.hasPrimaryFocus
                          ? const Color(0xFFFBFBFB)
                          : const Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                          'Poppins',
                          color: const Color(0xFF7E7E7E),
                          fontWeight: FontWeight.w400,
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
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        password = value;
                        setState(() {});
                      },
                      controller: text2,
                      onChanged: (value) {
                        password = value;
                        setState(() {});
                      },
                      focusNode: f2,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF7E7E7E),
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter Password',
                        hintStyle: GoogleFonts.getFont(
                          'Poppins',
                          color: const Color(0xFF7E7E7E),
                          fontWeight: FontWeight.w400,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forgot your Password?',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      !isSigningIn
                          ? InkWell(
                              onTap: () async {
                                if (!isSigningIn) {
                                  f!.unfocus();
                                  f2!.unfocus();
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                    try {
                                      setState(() {
                                        isSigningIn = true;
                                      });
                                    } catch (e) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ErrorPage()),
                                        (route) =>
                                            false, // This condition removes all previous routes
                                      );
                                    }

                                    await API()
                                        .loadUser(_auth.currentUser!.uid);
                                    if (AppInfo.currentUser.lastOpened != "") {
                                      await API().loadData(
                                          AppInfo.currentUser.lastOpened);
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

                                    // Successfully signed in
                                  } catch (e) {
                                    if (e is FirebaseAuthException) {
                                      switch (e.code) {
                                        case 'invalid-credential':
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error: Incorrect credentials provided. Recheck email and/or password.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );

                                          break;
                                        case 'invalid-email':
                                          // Handle invalid email address format
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error: Email is invalid. Did you make a typo?",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          break;
                                        case 'user-not-found':
                                          // Handle when the user does not exist
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error: User not found. Make a new account.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          break;

                                        case 'user-disabled':
                                          Fluttertoast.showToast(
                                            msg:
                                                "Error: User account is disabled.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );

                                          break;
                                        default:
                                          // Handle other Firebase Authentication errors

                                          break;
                                      }
                                    } else {
                                      // Handle other non-authentication related errors
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: 92,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: email != "" && password != ""
                                      ? const Color(0xFF226ADD)
                                      : const Color(0xFFB8B8B8),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.black),
                    ],
                  ),
                ),

                // Generated code for this Row Widget...
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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

                !isSigningIn
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isSigningIn = true;
                            });
                            User? u = await Authentication.signInWithGoogle(
                                context: context);

                            if (u == null) {
                              setState(() {
                                isSigningIn = false;
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
                                      builder: (context) =>
                                          Navigation(reNav: false, pIndex: 0)),
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
                              if (await _agreeDialog(context)) {
                                String name =
                                    "${_auth.currentUser!.displayName!.split(" ")[0]} ${_auth.currentUser!.displayName!.split(" ").last}";
                                await API().addUser(
                                    name,
                                    _auth.currentUser!.uid,
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
                                    'Sign in with Google',
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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: CircularProgressIndicator(color: Colors.black)),

                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 80, 25, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'New User?',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CreateAccount(),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.88,
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD7E4F8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Text(
                                    'Start Here!',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: const Color(0xFF226ADD),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _agreeDialog(BuildContext context) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBFB),
            title: const Text(
              'New Account',
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
                                ..onTap = () async {
                                  var uri = Uri.parse(
                                      "https://github.com/MahirEmran/Sielify/blob/main/Sielify_Terms_and_Conditions.md");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {}
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
                                ..onTap = () async {
                                  var uri = Uri.parse(
                                      "https://github.com/MahirEmran/Sielify/blob/main/Sielify_Privacy_Policy.md");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {}
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
                        });
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
        setState(() {
          isSigningIn = false;
        });
        return false;
      }

      setState(() {});
      return true;
    });
  }
}
