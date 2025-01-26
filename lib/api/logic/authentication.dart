// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class Authentication {
  static User? user;
  static AuthClient? _authClient;
  static GoogleSignInAccount? googleSignInAccount;

  // This is used for the sign out when the user hits the sign out method.
  // It utilizes the GoogleSignIn class's sign out method to sign out of
  // Google accounts.
  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!kIsWeb) {
        await GoogleSignIn(scopes: [
          'profile',
          'email',
          calendar.CalendarApi.calendarScope
        ]).signOut();
      }
      user = FirebaseAuth.instance.currentUser;
      user = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      googleSignInAccount = await GoogleSignIn(
              scopes: ['profile', 'email', calendar.CalendarApi.calendarScope])
          .signIn();
    } catch (e) {
      FirebaseCrashlytics.instance.log(e.toString());
      Fluttertoast.showToast(
        msg: "An unknown error occurred when signing in.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Fluttertoast.showToast(
            msg:
                "Account already exists under an email. Log in with email and password, then link your Google account.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return user;
        } else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(
            msg: "Error occurred when accessing credentials.",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return user;
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error occurred with Google Sign-in, please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return user;
      }
    }

    return user;
  }

  static Future<void> _handleSignIn(GoogleSignInAccount? _currentUser) async {
    try {
      final GoogleSignInAuthentication auth =
          await _currentUser!.authentication;
      final AccessCredentials credentials = AccessCredentials(
        AccessToken(
          'Bearer',
          auth.accessToken!,
          DateTime.now().add(Duration(hours: 1)), // Set token expiration time
        ),
        null,
        ['https://www.googleapis.com/auth/calendar'],
      );

      final AuthClient client = authenticatedClient(
        http.Client(),
        credentials,
      );

      _authClient = client;
    } catch (error) {
      print(error);
    }
  }

  static Future<AuthCredential?> linkGoogle(
      {required BuildContext context}) async {
    AuthCredential? user;
    GoogleSignInAccount? googleSignInAccount;

    googleSignInAccount = await GoogleSignIn(
            scopes: ['profile', 'email', calendar.CalendarApi.calendarScope])
        .signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      return GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
    }

    return user;
  }

  static Future<void> addEventToGoogleCalendar(String name, String desc,
      String loc, DateTime startTime, DateTime endTime) async {
    final GoogleSignInAuthentication auth =
        await googleSignInAccount!.authentication;
    final AccessCredentials credentials = AccessCredentials(
      AccessToken(
        'Bearer',
        auth.accessToken!,
        DateTime.now().add(Duration(hours: 1)).toUtc(), // Set token expiration time
      ),
      null,
      ['https://www.googleapis.com/auth/calendar'],
    );

    _authClient = authenticatedClient(
      http.Client(),
      credentials,
    );

    final calendar.CalendarApi calendarApi = calendar.CalendarApi(_authClient!);
    final calendar.Event event = calendar.Event(
      summary: name,
      description: desc,
      location: loc,
      start: calendar.EventDateTime(
        dateTime: startTime.toUtc(),
        timeZone: 'UTC',
      ),
      end: calendar.EventDateTime(
        dateTime: endTime.toUtc(),
        timeZone: 'UTC',
      ),
      reminders: calendar.EventReminders(
        useDefault: false,
        overrides: [calendar.EventReminder(method: 'popup', minutes: 15)],
      ),
    );

    try {
      await calendarApi.events.insert(event, 'primary');
      log('Event added to Google Calendar');
    } catch (e) {
      log('Error creating event $e');
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
