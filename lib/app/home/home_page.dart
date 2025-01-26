// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:simplex_conference_redo_repo/app/home/about_conference_page.dart';
import 'package:simplex_conference_redo_repo/app/home/all_agenda_items.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/bottom_sheets.dart';
import '../../api/logic/dates.dart';
import '../browse/event_landing_page.dart';
import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/objects/event_data.dart';
import '../../api/objects/workshop_data.dart';
import '../login/conference_view.dart';
import '../navigation/navigation.dart';

import 'img_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedEvent = "";

  late DateTime targetTime;
  bool isLeaving = false;
  late Duration timeDifference;
  Timer? timer;

  @override
  void initState() {
    if (AppInfo.currentEvents.isNotEmpty) {
      selectedEvent = AppInfo.currentEvents[0].name;
    }
    API().configureFirebaseMessaging(AppInfo.conference.id);
    super.initState();
    API.setLight();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxLetters = (0.1 * MediaQuery.sizeOf(context).width - 23).toInt();
    String username = AppInfo.currentConferenceUser.name;
    if (username.length > maxLetters) {
      List<String> tokens = username.split(" ");
      username = "${tokens[0]} ${tokens[1][0]}.";
    }

    List<Widget> agendaItems = getAgendaItems();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 267,
                child: Stack(
                  alignment: const AlignmentDirectional(0, 0),
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 267,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                    Opacity(
                      opacity: 0.2,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 267,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                AppInfo.conference.homeBg),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    25, 0, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!isLeaving) {
                                          setState(() {
                                            isLeaving = true;
                                          });
                                          API().leaveConference(
                                            AppInfo.currentUser,
                                          );

                                          AppInfo.selectedDate =
                                              DateFormat('yyyy-MM-dd').format(
                                                  DateTime.now().toLocal());
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ConferenceView()),
                                            (route) =>
                                                false, // This condition removes all previous routes
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: const Color(0x1CFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                                size: (!kIsWeb &&
                                                        (!kIsWeb &&
                                                            Platform.isIOS))
                                                    ? 15
                                                    : 14,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(3, 0, 0, 0),
                                                child: Text(
                                                  'Exit Conference',
                                                  style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: (!kIsWeb &&
                                                            (!kIsWeb &&
                                                                Platform.isIOS))
                                                        ? 13
                                                        : 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          await API()
                                              .loadData(AppInfo.conference.id);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Navigation(
                                                      pIndex: 0,
                                                      reNav: false,
                                                    )),
                                            (route) =>
                                                false, // This condition removes all previous routes
                                          );
                                          Fluttertoast.showToast(
                                            msg: "Conference refreshed!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: Container(
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: const Color(0x1CFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 0, 10, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.refresh,
                                                  color: Colors.white,
                                                  size: (!kIsWeb &&
                                                          (!kIsWeb &&
                                                              Platform.isIOS))
                                                      ? 16
                                                      : 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(3, 0, 0, 0),
                                                  child: Text(
                                                    'Refresh',
                                                    style: GoogleFonts.getFont(
                                                      'Poppins',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: (!kIsWeb &&
                                                              (!kIsWeb &&
                                                                  Platform
                                                                      .isIOS))
                                                          ? 13
                                                          : 11,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                        ? const EdgeInsetsDirectional.fromSTEB(
                                            26, 20, 0, 0)
                                        : const EdgeInsetsDirectional.fromSTEB(
                                            25, 15, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: CachedNetworkImage(
                                        imageUrl: AppInfo.conference.logo,
                                        height: (!kIsWeb &&
                                                (!kIsWeb && Platform.isIOS))
                                            ? 27
                                            : 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    25, 12, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        AppInfo.conference.name,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: 'ClashGrotesk',
                                          color: Colors.white,
                                          fontWeight: (!kIsWeb &&
                                                  (!kIsWeb && Platform.isIOS))
                                              ? FontWeight.w500
                                              : FontWeight.w300,
                                          fontSize: (!kIsWeb &&
                                                  (!kIsWeb && Platform.isIOS))
                                              ? 31
                                              : 29,
                                          height: 0.9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                        ? const EdgeInsetsDirectional.fromSTEB(
                                            25, 10, 25, 0)
                                        : const EdgeInsetsDirectional.fromSTEB(
                                            25, 12, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: const Color(0xDAFFFFFF),
                                      size: (!kIsWeb &&
                                              (!kIsWeb && Platform.isIOS))
                                          ? 18
                                          : 16,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 0, 0),
                                        child: AutoSizeText(
                                          AppInfo.conference.location,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.getFont(
                                            'Poppins',
                                            color: const Color(0xD9FFFFFF),
                                            fontWeight: (!kIsWeb &&
                                                    (!kIsWeb && Platform.isIOS))
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: (!kIsWeb &&
                                                    (!kIsWeb && Platform.isIOS))
                                                ? 14
                                                : 13,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                        ? const EdgeInsetsDirectional.fromSTEB(
                                            25, 5, 25, 0)
                                        : const EdgeInsetsDirectional.fromSTEB(
                                            25, 4, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.event,
                                      color: const Color(0xDAFFFFFF),
                                      size: (!kIsWeb &&
                                              (!kIsWeb && Platform.isIOS))
                                          ? 18
                                          : 17,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 0, 0, 0),
                                        child: AutoSizeText(
                                          Dates.formatDateRange(
                                              AppInfo.conference.startDate,
                                              AppInfo.conference.endDate),
                                          maxLines: 2,
                                          style: GoogleFonts.getFont(
                                            'Poppins',
                                            color: const Color(0xD9FFFFFF),
                                            fontWeight: (!kIsWeb &&
                                                    (!kIsWeb && Platform.isIOS))
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            fontSize: (!kIsWeb &&
                                                    (!kIsWeb && Platform.isIOS))
                                                ? 14
                                                : 13,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            'My Schedule',
                            style: TextStyle(
                              fontFamily: 'ClashGrotesk',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                  ? 28
                                  : 26,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              AppInfo.selectedDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now().toLocal());
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Navigation(
                                          pIndex: 3,
                                          reNav: false,
                                        )),
                                (route) =>
                                    false, // This condition removes all previous routes
                              );
                            },
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xC1E6E6E6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: Text(
                                    'View in Agenda',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: const Color(0xFF656567),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: agendaItems.length <= 3
                          ? agendaItems
                          : [
                              for (int i = 0;
                                  i < 3 && i < agendaItems.length;
                                  i++)
                                (agendaItems[i]),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    top: 15, end: 25),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllagendaWidget()),
                                      // This condition removes all previous routes
                                    );
                                  },
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'See All...',
                                          style: GoogleFonts.getFont(
                                            'Poppins',
                                            color: const Color(0xFF0904F4),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(4, 0, 0, 0),
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0904F4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            'My Events',
                            style: TextStyle(
                              fontFamily: 'ClashGrotesk',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                  ? 28
                                  : 26,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Navigation(
                                          pIndex: 2,
                                          reNav: false,
                                        )),
                                (route) =>
                                    false, // This condition removes all previous routes
                              );
                            },
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xC1E6E6E6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: Text(
                                    'View in Competitive Events',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: const Color(0xFF656567),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (Widget item in getEventWidgets()) (item),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Information',
                            style: TextStyle(
                              fontFamily: 'ClashGrotesk',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && (!kIsWeb && Platform.isIOS))
                                  ? 28
                                  : 26,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(23, 10, 23, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ImgView(img: AppInfo.conference.map),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.425,
                              height: 75,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFE5F9),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Color(0x1A8A8A8A),
                                    offset: Offset(
                                      0,
                                      3,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            18, 0, 15, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AutoSizeText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            'Building\nMaps',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: const Color(0xFF8A00DE),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              height: 0.95,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF8A00DE),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.chevron_right,
                                              color: Colors.white,
                                              size: 24,
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
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AboutConferencePage()),
                              );
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.425,
                              height: 75,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDEEFD),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 6,
                                    color: Color(0x1A8A8A8A),
                                    offset: Offset(
                                      0,
                                      3,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            18, 0, 15, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AutoSizeText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            'About This\nConference',
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: const Color(0xFF0081F4),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              height: 0.95,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0081F4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.chevron_right,
                                              color: Colors.white,
                                              size: 24,
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
                        ],
                      ),
                    ),
                    for (Widget item in getTiles()) (item),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
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
                      'You are being directed to an external third-party application by opening this link. Sielify bears no responsibility for any violations on third-party platforms.\n\nLink: $s',
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

  List<Widget> getTiles() {
    List<Widget> items = [];
    for (int i = 0; i < AppInfo.conference.tiles.length; i++) {
      Map<String, String> tile = AppInfo.conference.tiles[i];

      if (tile['type']! == "row") {
        Color c;
        Color c2;
        Color c3;
        Color c4;
        switch (int.parse(tile['img1']!)) {
          case 1:
            c = const Color(0xFF89345D);
            c2 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c = const Color(0xFF07946A);
            c2 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c = const Color(0xFFFF5959);
            c2 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c = const Color(0xFFFB8700);
            c2 = const Color(0xFFFCECD9);
            break;
          case 5:
            c = const Color(0xFFCD7C02);
            c2 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c = const Color(0xFF8A00DE);
            c2 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c = const Color(0xFF0081F4);
            c2 = const Color(0xFFDDEEFD);
            break;
          default:
            c = const Color(0xFF000000);
            c2 = const Color(0xFFFFFFFF);
        }

        switch (int.parse(tile['img2']!)) {
          case 1:
            c3 = const Color(0xFF89345D);
            c4 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c3 = const Color(0xFF07946A);
            c4 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c3 = const Color(0xFFFF5959);
            c4 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c3 = const Color(0xFFFB8700);
            c4 = const Color(0xFFFCECD9);
            break;
          case 5:
            c3 = const Color(0xFFCD7C02);
            c4 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c3 = const Color(0xFF8A00DE);
            c4 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c3 = const Color(0xFF0081F4);
            c4 = const Color(0xFFDDEEFD);
            break;
          default:
            c3 = const Color(0xFF000000);
            c4 = const Color(0xFFFFFFFF);
        }

        items.add(
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(23, 10, 23, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(tile['link1']!))) {
                      _confirmOpenLinkDialog(context, tile['link1']!);
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.425,
                    height: 75,
                    decoration: BoxDecoration(
                      color: c2,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Color(0x1A8A8A8A),
                          offset: Offset(
                            0,
                            3,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              18, 0, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  tile['name1']!,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: c,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
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
                InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(tile['link2']!))) {
                      _confirmOpenLinkDialog(context, tile['link2']!);
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.425,
                    height: 75,
                    decoration: BoxDecoration(
                      color: c4,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Color(0x1A8A8A8A),
                          offset: Offset(
                            0,
                            3,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              18, 0, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  tile['name2']!,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: c3,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c3,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
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
              ],
            ),
          ),
        );
      } else {
        Color c;
        Color c2;
        switch (int.parse(tile['img']!)) {
          case 1:
            c = const Color(0xFF89345D);
            c2 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c = const Color(0xFF07946A);
            c2 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c = const Color(0xFFFF5959);
            c2 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c = const Color(0xFFFB8700);
            c2 = const Color(0xFFFCECD9);
            break;
          case 5:
            c = const Color(0xFFCD7C02);
            c2 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c = const Color(0xFF8A00DE);
            c2 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c = const Color(0xFF0081F4);
            c2 = const Color(0xFFDDEEFD);
            break;
          default:
            c = const Color(0xFF000000);
            c2 = const Color(0xFFFFFFFF);
        }

        items.add(
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(tile['link']!))) {
                  _confirmOpenLinkDialog(context, tile['link']!);
                }
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.883,
                height: 90,
                decoration: BoxDecoration(
                  color: c2,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Color(0x1A8A8A8A),
                      offset: Offset(
                        0,
                        3,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              tile['name']!,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: c,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 24,
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
    }
    return items;
  }

  List<Widget> getEventWidgets() {
    List<Widget> items = [];
    for (EventData e in AppInfo.currentEvents) {
      items.add(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.88,
          child: Stack(children: [
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Navigation(
                                pIndex: 2,
                                reNav: false,
                              )),
                      (route) => false,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventLandingPage(e: e)),
                      // This condition removes all previous routes
                    );
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.86,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Color(0x1B8A8A8A),
                          offset: Offset(
                            0,
                            3,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(
                          (!kIsWeb && (!kIsWeb && Platform.isIOS)) ? 17 : 20),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              e.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    (!kIsWeb && Platform.isIOS) ? 14.5 : 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Align(
              alignment: const AlignmentDirectional(1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Navigation(
                                pIndex: 2,
                                reNav: false,
                              )),
                      (route) => false,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventLandingPage(e: e)),
                      // This condition removes all previous routes
                    );
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFFf8f8f8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 2, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Navigation(
                                pIndex: 2,
                                reNav: false,
                              )),
                      (route) => false,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventLandingPage(e: e)),
                      // This condition removes all previous routes
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 31, 31, 31),
                      shape: BoxShape.circle,
                    ),
                    child: const Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(0xFFF9F9F9),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ])));
    }

    if (items.isEmpty) {
      items.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.88,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Color(0x1A8A8A8A),
                offset: Offset(
                  0,
                  3,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 15, 18, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Text(
                      'You do not have any bookmarked events.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return items;
  }

  List<Widget> getAgendaItems() {
    List<Widget> items = [];
    List<WorkshopData> workshops = AppInfo.currentWorkshops;
    List<String> userWorkshops =
        AppInfo.currentConferenceUser.agendaItems.keys.toList();
    workshops.sort((a, b) => Dates.parseTimeString(a.startTime)
        .compareTo(Dates.parseTimeString(b.startTime)));
    Iterable<WorkshopData> workshops2 = workshops.where(
      (element) =>
          (userWorkshops.contains(element.id) || element.type == "Event") &&
          element.date ==
              DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()),
    );

    for (WorkshopData w in workshops2) {
      String start = w.type == "Session"
          ? w.sessions[AppInfo.currentConferenceUser.agendaItems[w.id]!]
              ['startTime']!
          : w.startTime;
      String end = w.type == "Session"
          ? w.sessions[AppInfo.currentConferenceUser.agendaItems[w.id]!]
              ['endTime']!
          : w.endTime;
      String name = w.type == "Session"
          ? w.sessions[AppInfo.currentConferenceUser.agendaItems[w.id]!]
              ['name']!
          : w.name;
      String loc = w.type == "Session"
          ? w.sessions[AppInfo.currentConferenceUser.agendaItems[w.id]!]
              ['location']!
          : w.location;
      bool nextDay =
          Dates.parseTimeString(start).isAfter(Dates.parseTimeString(end));
      if ((!nextDay &&
              DateTime.now()
                  .toLocal()
                  .isAfter(Dates.parseDateTime(w.date, end))) ||
          (nextDay &&
              DateTime.now().toLocal().isAfter(Dates.parseDateTime(w.date, end)
                  .add(const Duration(days: 1))))) {
        continue;
      }
      DateTime targetTime = Dates.parseDateTime(w.date, start);
      Duration timeDifference = targetTime.difference(DateTime.now().toLocal());

      // Adjust targetTime if it's earlier than the current time
      if (targetTime.isBefore(DateTime.now().toLocal())) {
        targetTime = targetTime.add(const Duration(days: 1));
      }
      int hours = timeDifference.inHours;
      int minutes = (timeDifference.inMinutes % 60);
      minutes++;
      if (minutes == 60) {
        minutes = 0;
        hours += 1;
      }

      Widget times = const SizedBox();

      if (!DateTime.now()
          .toLocal()
          .isAfter(Dates.parseDateTime(w.date, start))) {
        times = Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
          child: Container(
            width: 110,
            height: 18,
            decoration: BoxDecoration(
              color: hours == 0 && minutes <= 30
                  ? const Color.fromARGB(9, 114, 37, 37)
                  : const Color(0xC0ECEBFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Starts in ',
                      style: TextStyle(
                        color: hours == 0 && minutes <= 30
                            ? const Color(0xFFAE1919)
                            : const Color(0xFF252C72),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: '${hours}h ${minutes}m',
                      style: TextStyle(
                        color: hours == 0 && minutes <= 30
                            ? const Color(0xFFAE1919)
                            : const Color(0xFF252C72),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontSize: (!kIsWeb && Platform.isIOS) ? 12 : 10,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if ((!nextDay &&
              DateTime.now()
                  .toLocal()
                  .isBefore(Dates.parseDateTime(w.date, end))) ||
          (nextDay &&
              DateTime.now().toLocal().isBefore(Dates.parseDateTime(w.date, end)
                  .add(const Duration(days: 1))))) {
        times = Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
          child: Container(
            height: 18,
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 64, 183, 53),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: const [
                    TextSpan(
                      text: 'In Progress',
                      style: TextStyle(
                        color: Color(0xFF36981E),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontSize:
                        (!kIsWeb && (!kIsWeb && Platform.isIOS)) ? 12 : 10,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      items.add(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.88,
          child: Stack(children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: InkWell(
                  onTap: () {
                    if (w.type == "Session") {
                      BottomSheets.getCheckinPage(context, w,
                          AppInfo.currentConferenceUser.agendaItems[w.id]!);
                    } else {
                      BottomSheets.getCheckinPage(context, w, -1);
                    }
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.88,
                    height: 136,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Color(0x1A8A8A8A),
                          offset: Offset(
                            0,
                            3,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 18, 15, 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        times,
                                        Container(
                                          width: 80,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: w.type == "Event"
                                                ? const Color.fromARGB(
                                                    13, 8, 4, 244)
                                                : w.type == "Session"
                                                    ? const Color.fromARGB(
                                                        14, 255, 111, 0)
                                                    : const Color.fromARGB(
                                                        14, 0, 174, 101),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                            child: Text(
                                              w.type == "Event"
                                                  ? 'Mandatory'
                                                  : w.type == "Session"
                                                      ? "Session"
                                                      : "Item",
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                color: w.type == "Event"
                                                    ? const Color(0xFF0904F4)
                                                    : w.type == "Session"
                                                        ? const Color(
                                                            0xFFFF6F00)
                                                        : const Color(
                                                            0xFF00AE66),
                                                fontSize: 10,
                                                fontWeight: (!kIsWeb &&
                                                        (!kIsWeb &&
                                                            Platform.isIOS))
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            name,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: Colors.black,
                                              fontSize: (!kIsWeb &&
                                                      (!kIsWeb &&
                                                          Platform.isIOS))
                                                  ? 19
                                                  : 17,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 12, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                              size: 13,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(4, 0, 0, 0),
                                                child: Text(
                                                  loc,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontFamily: 'ClashGrotesk',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ])
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 102,
                          decoration: BoxDecoration(
                            color: w.type == "Event"
                                ? const Color.fromARGB(21, 8, 4, 244)
                                : w.type == "Session"
                                    ? const Color.fromARGB(21, 255, 111, 0)
                                    : const Color.fromARGB(21, 0, 174, 101),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                17, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(-1, 0),
                                  child: Text(
                                    'Start',
                                    style: TextStyle(
                                      fontFamily: 'ClashGrotesk',
                                      color: w.type == "Event"
                                          ? const Color.fromARGB(180, 8, 4, 244)
                                          : w.type == "Session"
                                              ? const Color.fromARGB(
                                                  180, 255, 111, 0)
                                              : const Color.fromARGB(
                                                  180, 0, 174, 101),
                                      fontSize: (!kIsWeb &&
                                              (!kIsWeb && Platform.isIOS))
                                          ? 12
                                          : 10,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  start.toUpperCase().replaceAll(":", "."),
                                  maxLines: 1,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: w.type == "Event"
                                        ? const Color.fromARGB(255, 8, 4, 244)
                                        : w.type == "Session"
                                            ? const Color.fromARGB(
                                                255, 255, 111, 0)
                                            : const Color.fromARGB(
                                                255, 0, 174, 101),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 15, 0, 0),
                                  child: Text(
                                    'End',
                                    style: TextStyle(
                                      fontFamily: 'ClashGrotesk',
                                      color: w.type == "Event"
                                          ? const Color.fromARGB(180, 8, 4, 244)
                                          : w.type == "Session"
                                              ? const Color.fromARGB(
                                                  180, 255, 111, 0)
                                              : const Color.fromARGB(
                                                  180, 0, 174, 101),
                                      fontSize: (!kIsWeb &&
                                              (!kIsWeb && Platform.isIOS))
                                          ? 12
                                          : 10,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  end.toUpperCase().replaceAll(":", "."),
                                  maxLines: 1,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: w.type == "Event"
                                        ? const Color.fromARGB(255, 8, 4, 244)
                                        : w.type == "Session"
                                            ? const Color.fromARGB(
                                                255, 255, 111, 0)
                                            : const Color.fromARGB(
                                                255, 0, 174, 101),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
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
            ),
            Align(
              alignment: const AlignmentDirectional(1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 125, 83, 0),
                child: InkWell(
                  onTap: () {
                    if (w.type == "Session") {
                      BottomSheets.getCheckinPage(context, w,
                          AppInfo.currentConferenceUser.agendaItems[w.id]!);
                    } else {
                      BottomSheets.getCheckinPage(context, w, -1);
                    }
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFf8f8f8),
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: const Color(0xFFF8f8f8),
                      //   width: 5,
                      // ),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 130, 88, 0),
                child: InkWell(
                  onTap: () {
                    if (w.type == "Session") {
                      BottomSheets.getCheckinPage(context, w,
                          AppInfo.currentConferenceUser.agendaItems[w.id]!);
                    } else {
                      BottomSheets.getCheckinPage(context, w, -1);
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: const Color(0xFFF8f8f8),
                      //   width: 5,
                      // ),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ])));
    }

    if (items.isEmpty) {
      items.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.88,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                color: Color(0x1A8A8A8A),
                offset: Offset(
                  0,
                  3,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(18, 15, 18, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Text(
                      'There are no more selected agenda items for today.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return items;
  }
}
