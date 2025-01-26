// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';

import '../../api/logic/dates.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  AnnouncementsPageState createState() => AnnouncementsPageState();
}

class AnnouncementsPageState extends State<AnnouncementsPage> {
  ScrollController _scrollController = ScrollController();
  List<Map<String, String>> announcements = [];
  TextEditingController? textController;
  late int controllerIndex = -1;
  late List<Widget> items = [];
  StreamSubscription<DocumentSnapshot>? _streamSubscription;
  late String? msg = "";
  Timer? timer;

  late bool dataLoaded = false;
  String? announcementText = "";

  AnnouncementsPageState() {
    API().getAnnouncements(AppInfo.conference.id).then(
      (value) {
        announcements = value;
        loadMessages().then((value) {
          dataLoaded = true;
          _setupMessageListener();

          setState(() {});
        });
      },
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    API.setDark();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      loadMessages().then((value) {
        setState(() {});
      });
    });
  }

  void _setupMessageListener() {
    // Replace this with your actual listener setup
    // For example, if you're listening to changes in a Firestore document
    // you can do something like this:
    _streamSubscription = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        List<Map<String, String>> announcementsList = [];
        // Handle the update here
        // Call your initialization method
        List<dynamic> announcementList =
            (documentSnapshot.get('announcements') as List).cast<dynamic>();

        for (int i = 0; i < announcementList.length; i++) {
          dynamic item = announcementList[i];
          Map<String, String> a = {};
          Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
          map.forEach((key, value) {
            a[key.toString()] = value.toString();
          });

          announcementsList.add(a);
        }
        announcementsList.sort((a, b) {
          DateTime timestampA = DateTime.parse(a['timestamp']!);
          DateTime timestampB = DateTime.parse(b['timestamp']!);
          return timestampA.compareTo(timestampB);
        });
        announcements = announcementsList;

        loadMessages().then(
          (value) {
            setState(() {});
          },
        );
      }
    });
  }

  Future<void> loadMessages() async {
    items = [];

    if (items.isEmpty) {
      bool foundFirstNonToday = false;
      for (int i = announcements.length - 1; i >= 0; i--) {
        Map<String, String> a = announcements[i];
        String timestamp = a['timestamp']!;

        DateTime d = DateTime.parse(timestamp).toLocal();

        String d2 = DateFormat('yyyy/MM/dd').format(d);

        if (Dates.formatDateToDay(d2) == "Today" && items.isEmpty) {
          items.add(// Generated code for this Row Widget...
              Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 18, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Today',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(
                      color: Color(0xC1FF0000),
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                        child: Text(
                          '!',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        } else if (Dates.formatDateToDay(d2) != "Today" &&
            !foundFirstNonToday) {
          foundFirstNonToday = true;
          items.add(// Generated code for this Row Widget...
              Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(25, 5, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'All',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ));
        }

        List<TextSpan> msgText = [];
        if (a['text']! != "") {
          int startIndex = 0;
          for (String t in (a['text']!.split(RegExp(r'\s+')))) {
            bool canlaunch;
            try {
              if (t.startsWith("https://")) {
                canlaunch = await canLaunchUrl(Uri.parse(t));
              } else {
                canlaunch = false;
              }
            } catch (e) {
              canlaunch = false;
            }
            if (canlaunch) {
              msgText.add(
                TextSpan(
                  text: a['text']!.indexOf(t, startIndex) - 2 >= 0 &&
                          a['text']!.substring(
                                  a['text']!.indexOf(t, startIndex) - 1,
                                  a['text']!.indexOf(t, startIndex)) ==
                              "\n"
                      ? "\n"
                      : " ",
                  style: GoogleFonts.getFont(
                    color: const Color(0xFF717171),
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
              msgText.add(
                TextSpan(
                  text: t,
                  style: GoogleFonts.getFont(
                    color: const Color.fromARGB(255, 41, 41, 255),
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await launchUrl(Uri.parse(t),
                          mode: LaunchMode.externalApplication);
                    },
                ),
              );

              startIndex = a['text']!.indexOf(t, startIndex) + 1;
            } else {
              msgText.add(
                TextSpan(
                  text: a['text']!.indexOf(t, startIndex) - 2 >= 0 &&
                          a['text']!.substring(
                                  a['text']!.indexOf(t, startIndex) - 1,
                                  a['text']!.indexOf(t, startIndex)) ==
                              "\n"
                      ? "\n" "$t "
                      : "$t ",
                  style: GoogleFonts.getFont(
                    color: const Color(0xFF717171),
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
              startIndex = a['text']!.indexOf(t, startIndex) + 1;
            }
          }
        }

        String time = Dates.giveDateTimestamp(d);

        items.add(// Generated code for this Row Widget...
            Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E1E1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        '${a['name']!.split(" ").first[0]}${a['name']!.split(" ").last[0]}',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: const Color(0xFF2B2B2B),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['name']!,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: const Color(0xFF323232),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                        child: RichText(text: TextSpan(children: msgText)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              time,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: const Color(0xFF0088D4),
                                fontSize: 12,
                              ),
                            ),
                            a['image'] != ""
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(a['image']!))) {
                                          await launchUrl(
                                              Uri.parse(a['image']!),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                      child: Container(
                                        height: 21,
                                        decoration: BoxDecoration(
                                          color: const Color(0xBEE6E6E6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.file_upload_outlined,
                                                color: Color(0xFF616161),
                                                size: 13,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(4, 0, 0, 0),
                                                child: Text(
                                                  'Attachment',
                                                  style: GoogleFonts.getFont(
                                                    'Poppins',
                                                    color:
                                                        const Color(0xFF616161),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));

        items.add(SizedBox(
          width: MediaQuery.sizeOf(context).width * .86,
          child: const Divider(
            height: 30,
            thickness: 2,
            color: Color(0xFFEFEFEF),
          ),
        ));
      }
    }
    items.add(const SizedBox(height: 50));
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    _scrollController.dispose();
    _streamSubscription?.cancel();
    textController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dataLoaded) {
      return Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFf9f9f9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items,
          ));
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0xFFF9f9f9),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [CircularProgressIndicator(color: Colors.black)]));
    }
  }
}
