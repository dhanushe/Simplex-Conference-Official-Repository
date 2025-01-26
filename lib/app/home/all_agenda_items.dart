import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/logic/bottom_sheets.dart';
import '../../api/logic/dates.dart';
import '../../api/objects/workshop_data.dart';
import '../navigation/navigation.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllagendaWidget extends StatefulWidget {
  const AllagendaWidget({super.key});

  @override
  State<AllagendaWidget> createState() => _AllagendaWidgetState();
}

class _AllagendaWidgetState extends State<AllagendaWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? timer;
  @override
  void initState() {
    startTimer();
    API.setLight();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> agendaItems = getAgendaItems();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: PopScope(
        canPop: false,
        onPopInvoked: (b) {
          // Handle back button press here
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Navigation(
                pIndex: 0,
                reNav: false,
              ),
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
            (route) => false, // This condition removes all previous routes
          );
        },
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height * 1,
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
                  height: 186,
                  child: Stack(
                    alignment: const AlignmentDirectional(0, -1),
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 186,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 186,
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
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 65, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      25, 8, 25, 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 200),
                                          reverseTransitionDuration:
                                              const Duration(milliseconds: 200),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              Navigation(
                                            pIndex: 0,
                                            reNav: false,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(-1.0, 0.0);
                                            const end = Offset.zero;
                                            final tween =
                                                Tween(begin: begin, end: end);
                                            final offsetAnimation =
                                                animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                        (route) =>
                                            false, // This condition removes all previous routes
                                      );
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Color(0xC7FFFFFF),
                                          size: 17,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  6, 0, 0, 0),
                                          child: Text(
                                            'Home',
                                            style: TextStyle(
                                              fontFamily: 'ClashGrotesk',
                                              color: Color(0xC5FFFFFF),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25, 12, 25, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'All Agenda Items',
                                        style: TextStyle(
                                          fontFamily: 'ClashGrotesk',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: Text(
                                  DateFormat("EEEE, MMMM d")
                                      .format(DateTime.now().toLocal()),
                                  style: const TextStyle(
                                    fontFamily: 'ClashGrotesk',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25, 3, 25, 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'All Agenda Items for Today',
                                style: TextStyle(
                                  fontFamily: 'ClashGrotesk',
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (Widget item in agendaItems) (item),
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
                    fontSize: (!kIsWeb && Platform.isIOS) ? 12 : 10,
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
                                                fontWeight:
                                                    (!kIsWeb && Platform.isIOS)
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
                                              fontSize:
                                                  (!kIsWeb && Platform.isIOS)
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
                                      fontSize:
                                          (!kIsWeb && Platform.isIOS) ? 12 : 10,
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
                                      fontSize:
                                          (!kIsWeb && Platform.isIOS) ? 12 : 10,
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
