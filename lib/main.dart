// ignore_for_file: must_be_immutable, no_logic_in_create_state, library_private_types_in_public_api

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:simplex_conference_redo_repo/app/login/conference_view.dart';
import 'admin/login/welcome_screen.dart';
import 'api/logic/API.dart';

import 'api/app_info.dart';
import 'app/login/error_page.dart';
import 'app/login/firebase_options.dart';
import 'app/login/welcome_screen.dart';
import 'app/navigation/navigation.dart';

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadgeControl.updateBadgeCount(1);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    log(errorDetails.toString());
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString());
    log(stack.toString());
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  if (!kIsWeb) {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      AppInfo.fromNotif = true;
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  bool userExists = false;
  bool loadConference = false;

  bool error = false;

  if (user != null) {
    try {
      await API().loadUser(user.uid);
      userExists = true;
      if (AppInfo.currentUser.lastOpened != "") {
        await API().loadData(AppInfo.currentUser.lastOpened);
        loadConference = true;
      }
    } catch (e) {
      error = true;
    }
  }

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // await API().updateAllUserConference("ztsiYkIWvrv3niV7qISC");

  runApp(MyApp(
      userExists: userExists, loadConference: loadConference, error: error));
}

class MyApp extends StatefulWidget {
  bool userExists;
  bool error;
  bool loadConference;
  MyApp({
    super.key,
    required this.userExists,
    required this.loadConference,
    required this.error,
  });
  @override
  _MyAppState createState() => _MyAppState(
      userExists: userExists, loadConference: loadConference, error: error);
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool userExists;
  bool loadConference;
  bool error;
  _MyAppState({
    required this.userExists,
    required this.loadConference,
    required this.error,
  });
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // API().copyEventsToAnotherConference();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlutterAppBadgeControl.removeBadge();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget w = const WelcomeScreen();

    if (userExists) {
      if (error) {
        w = const ErrorPage();
      } else {
        if (loadConference) {
          w = Navigation(reNav: false, pIndex: AppInfo.fromNotif ? 1 : 0);
        } else {
          w = const ConferenceView();
        }
      }
    }

    API.setLight();

    if (kIsWeb) {
      w = const AdminWelcomePage();
    }

    return MaterialApp(
      title: 'Sielify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: w,
      ),
    );
  }
}

// blue/green gradient

// gradient: LinearGradient(
//                                 colors: [Color(0xFF4B39EF), Color(0xCC13C9B3)],
//                                 stops: [0.4, 0.9],
//                                 begin: AlignmentDirectional(1, -1),
//                                 end: AlignmentDirectional(-1, 1),
//                               ),

// purple/yellow gradient

// gradient: LinearGradient(
//                                 colors: [Color(0xFF4B39EF), Color(0xFFF2BB2A)],
//                                 stops: [0.3, 1],
//                                 begin: AlignmentDirectional(0.87, -1),
//                                 end: AlignmentDirectional(-0.87, 1),
//                               ),
