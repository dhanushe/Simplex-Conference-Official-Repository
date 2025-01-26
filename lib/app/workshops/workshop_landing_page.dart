// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:async';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:simplex_conference_redo_repo/api/logic/authentication.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/objects/workshop_data.dart';
import '../../api/logic/dates.dart';

import 'package:flutter/material.dart';

class WorkshopCard extends StatefulWidget {
  WorkshopData w;
  int i;
  WorkshopCard({super.key, required this.w, required this.i});

  @override
  State<WorkshopCard> createState() => _WorkshopCardState(w, i);
}

class _WorkshopCardState extends State<WorkshopCard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  WorkshopData w;
  int i;
  String img = "";
  Timer? timer;
  late ScrollController _scrollController;
  _WorkshopCardState(this.w, this.i);

  @override
  void initState() {
    API.setLight();
    if (i != -1) {
      switch (w.sessions[i]['tag']) {
        case "arts":
          img = "Arts";
          break;
        case "communication":
          img = "Communication";
          break;
        case "business management":
          img = "Business Management";
          break;
        case "education":
          img = "Education";
          break;
        case "entrepreneurship":
          img = "Entrepreneurship";
          break;
        case "finance":
          img = "Finance";
          break;
        case "law & government":
          img = "Law & Government";
          break;
        case "marketing":
          img = "Marketing";
          break;
        case "stem":
          img = "STEM";
          break;
        case "state office":
          img = "State Office";
          break;
        default:
          img = "Misc.";
          break;
      }
    }
    _scrollController = ScrollController();
    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool today =
        w.date == DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

    String end = i == -1 ? w.endTime : w.sessions[i]['endTime']!;
    String start = i == -1 ? w.startTime : w.sessions[i]['startTime']!;
    String loc = i == -1 ? w.location : w.sessions[i]['location']!;
    String date = i == -1 ? w.date : w.sessions[i]['date']!;
    String name = i == -1 ? w.name : w.sessions[i]['name']!;
    String desc = i == -1 ? w.desc : w.sessions[i]['desc']!;
    Widget times = const SizedBox();
    bool nextDay = Dates.parseTimeString(w.startTime)
        .isAfter(Dates.parseTimeString(w.endTime));

    DateTime targetTime = Dates.parseDateTime(date, start);
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

    if (today &&
        !DateTime.now().toLocal().isAfter(Dates.parseDateTime(date, start))) {
      times = Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
        child: Container(
          width: 135,
          height: 26,
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
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    } else if ((!nextDay &&
            DateTime.now().toLocal().isBefore(Dates.parseDateTime(date, end)) &&
            DateTime.now()
                .toLocal()
                .isAfter(Dates.parseDateTime(date, start))) ||
        (DateTime.now().toLocal().isAfter(Dates.parseDateTime(date, start)) &&
            nextDay &&
            DateTime.now().toLocal().isBefore(
                Dates.parseDateTime(date, end).add(const Duration(days: 1))))) {
      times = Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
        child: Container(
          height: 26,
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
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    } else if ((!nextDay &&
            DateTime.now().toLocal().isAfter(Dates.parseDateTime(date, end))) ||
        (nextDay &&
            DateTime.now().toLocal().isAfter(
                Dates.parseDateTime(date, end).add(const Duration(days: 1))))) {
      times = Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
        child: Container(
          height: 26,
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
                    text: 'Done',
                    style: TextStyle(
                      color: Color(0xFF36981E),
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 35, 30, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontFamily: 'ClashGrotesk',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 26,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        times,
                        Container(
                          width: 110,
                          height: 26,
                          decoration: BoxDecoration(
                            color: w.type == "Event"
                                ? const Color.fromARGB(13, 8, 4, 244)
                                : w.type == "Session"
                                    ? const Color.fromARGB(14, 255, 111, 0)
                                    : const Color.fromARGB(14, 0, 174, 101),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
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
                                        ? const Color(0xFFFF6F00)
                                        : const Color(0xFF00AE66),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        (w.type != "Session" &&
                                    AppInfo.currentConferenceUser.agendaItems
                                        .containsKey(w.id)) ||
                                (AppInfo.currentConferenceUser.agendaItems
                                        .containsKey(w.id) &&
                                    AppInfo.currentConferenceUser
                                            .agendaItems[w.id] ==
                                        i) ||
                                w.type == "Event"
                            ? Container(
                                width: 95,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(10, 25, 164, 174),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Text(
                                    "Selected",
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: const Color(0xFF19A5AE),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  w.type == "Session"
                      ? Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 10, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 8, 0),
                                child: Container(
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: const Color(0xC0ECEBFF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Icon(
                                          Icons.sell_outlined,
                                          color: Color(0xFF252C72),
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(4, 0, 0, 0),
                                          child: Text(
                                            img,
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: const Color(0xFF252C72),
                                              fontSize: 12,
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
                        )
                      : const SizedBox(),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 39,
                          height: 39,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0ECFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF226ADD),
                            size: 22,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      (!kIsWeb && Platform.isIOS) ? 14 : 13,
                                ),
                              ),
                              Text(
                                AppInfo.conference.location,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: const Color(0xFF8A8A8A),
                                  fontSize:
                                      (!kIsWeb && Platform.isIOS) ? 14 : 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 8, 25, 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 39,
                          height: 39,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0ECFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xFF226ADD),
                            size: 22,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${start.replaceAll(":", ".").toUpperCase()} - ${end.replaceAll(":", ".").toUpperCase()}",
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      (!kIsWeb && Platform.isIOS) ? 14 : 13,
                                ),
                              ),
                              Text(
                                DateFormat("EEEE, MMMM d").format(
                                    DateTime.parse(date.replaceAll('/', '-'))),
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: const Color(0xFF8A8A8A),
                                  fontSize:
                                      (!kIsWeb && Platform.isIOS) ? 14 : 13,
                                ),
                              ),
                            ],
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
                        Flexible(
                          child: Text(
                            desc,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              color: const Color(0xFF717171),
                              fontSize: (!kIsWeb && Platform.isIOS) ? 14 : 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (w.type == "Event") {
                              Fluttertoast.showToast(
                                msg:
                                    "You cannot remove mandatory items from your agenda.",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              if (AppInfo.currentConferenceUser.agendaItems
                                  .containsKey(w.id)) {
                                int index = AppInfo
                                    .currentConferenceUser.agendaItems[w.id]!;
                                if (index == -1 || index == i) {
                                  AppInfo.currentConferenceUser.agendaItems
                                      .remove(w.id);
                                } else {
                                  AppInfo.currentConferenceUser
                                      .agendaItems[w.id] = i;
                                }
                                API().updateAgendaUser(
                                    AppInfo.currentConferenceUser);
                                setState(() {});
                              } else {
                                AppInfo.currentConferenceUser
                                    .agendaItems[w.id] = i;
                                API().updateAgendaUser(
                                    AppInfo.currentConferenceUser);
                                setState(() {});
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.68,
                            height: 41,
                            decoration: BoxDecoration(
                              color: w.type == "Event"
                                  ? const Color(0xFF8D8D92)
                                  : (w.type != "Session" &&
                                              AppInfo.currentConferenceUser
                                                  .agendaItems
                                                  .containsKey(w.id)) ||
                                          (AppInfo.currentConferenceUser
                                                  .agendaItems
                                                  .containsKey(w.id) &&
                                              AppInfo.currentConferenceUser
                                                      .agendaItems[w.id] ==
                                                  i)
                                      ? const Color(0xFF18AE9F)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: w.type == "Event"
                                    ? const Color(0xFF8D8D92)
                                    : const Color(0xFF18AE9F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon((w.type != "Session" && AppInfo.currentConferenceUser.agendaItems.containsKey(w.id)) || (AppInfo.currentConferenceUser.agendaItems.containsKey(w.id) && AppInfo.currentConferenceUser.agendaItems[w.id] == i) || w.type == "Event" ? Symbols.check : Symbols.add,
                                    color: (w.type != "Session" &&
                                                AppInfo.currentConferenceUser.agendaItems
                                                    .containsKey(w.id)) ||
                                            (AppInfo.currentConferenceUser.agendaItems
                                                    .containsKey(w.id) &&
                                                AppInfo.currentConferenceUser.agendaItems[w.id] ==
                                                    i) ||
                                            w.type == "Event"
                                        ? Colors.white
                                        : const Color(0xFF18AE9F),
                                    size: 22,
                                    fill: (w.type != "Session" && AppInfo.currentConferenceUser.agendaItems.containsKey(w.id)) ||
                                            (AppInfo.currentConferenceUser.agendaItems
                                                    .containsKey(w.id) &&
                                                AppInfo.currentConferenceUser.agendaItems[w.id] == i) ||
                                            w.type == "Event"
                                        ? 1.0
                                        : 0.0),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: Text(
                                    "Add to My Agenda",
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: (w.type != "Session" &&
                                                    AppInfo
                                                        .currentConferenceUser
                                                        .agendaItems
                                                        .containsKey(w.id)) ||
                                                (AppInfo.currentConferenceUser
                                                        .agendaItems
                                                        .containsKey(w.id) &&
                                                    AppInfo.currentConferenceUser
                                                                .agendaItems[
                                                            w.id] ==
                                                        i) ||
                                                w.type == "Event"
                                            ? Colors.white
                                            : const Color(0xFF18AE9F)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(height: 20),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            DateTime time1 = Dates.parseDateTime(date, start);
                            DateTime time2 = Dates.parseDateTime(date, end);
                            if (time2.isBefore(time1)) {
                              time2 = time2.add(Duration(days: 1));
                            }
                            Event event = Event(
                              title: name,
                              description: desc,
                              location: loc,
                              startDate: time1,
                              endDate: time2,
                              iosParams: IOSParams(
                                reminder: Duration(
                                    minutes: 30), // on iOS, you can set alarm notification after your event.
                                // on iOS, you can set url to your event.
                              ),
                            );

                            Add2Calendar.addEvent2Cal(event);
                            // if(w.type == "Event") {
                            //      Fluttertoast.showToast(
                            //                 msg: "You cannot remove mandatory items from your agenda.",
                            //                 toastLength: Toast.LENGTH_SHORT,
                            //                 backgroundColor: Colors.red,
                            //                 textColor: Colors.white,
                            //                 fontSize: 16.0,
                            //               );
                            // }
                            // else {

                            // if (AppInfo.currentConferenceUser.agendaItems
                            //     .containsKey(w.id)) {
                            //   int index = AppInfo
                            //       .currentConferenceUser.agendaItems[w.id]!;
                            //   if (index == -1 || index == i) {
                            //     AppInfo.currentConferenceUser.agendaItems
                            //         .remove(w.id);
                            //   } else {
                            //     AppInfo.currentConferenceUser
                            //         .agendaItems[w.id] = i;
                            //   }
                            //   API().updateAgendaUser(
                            //       AppInfo.currentConferenceUser);
                            //   setState(() {});
                            // } else {
                            //   AppInfo.currentConferenceUser.agendaItems[w.id] =
                            //       i;
                            //   API().updateAgendaUser(
                            //       AppInfo.currentConferenceUser);
                            //   setState(() {});
                            // }
                            // }
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.68,
                            height: 41,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: const Color(0xFF18AE9F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Symbols.add,
                                    color: const Color(0xFF18AE9F),
                                    size: 22,
                                    fill: 1.0),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: Text(
                                    "Add to Calendar",
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: const Color(0xFF18AE9F)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(height: 20),
                 Authentication.googleSignInAccount != null ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            DateTime time1 = Dates.parseDateTime(date, start);
                            DateTime time2 = Dates.parseDateTime(date, end);
                            if (time2.isBefore(time1)) {
                              time2 = time2.add(Duration(days: 1));
                            }
                            Authentication.addEventToGoogleCalendar(name, desc, loc, time1, time2);
                            // if(w.type == "Event") {
                            //      Fluttertoast.showToast(
                            //                 msg: "You cannot remove mandatory items from your agenda.",
                            //                 toastLength: Toast.LENGTH_SHORT,
                            //                 backgroundColor: Colors.red,
                            //                 textColor: Colors.white,
                            //                 fontSize: 16.0,
                            //               );
                            // }
                            // else {

                            // if (AppInfo.currentConferenceUser.agendaItems
                            //     .containsKey(w.id)) {
                            //   int index = AppInfo
                            //       .currentConferenceUser.agendaItems[w.id]!;
                            //   if (index == -1 || index == i) {
                            //     AppInfo.currentConferenceUser.agendaItems
                            //         .remove(w.id);
                            //   } else {
                            //     AppInfo.currentConferenceUser
                            //         .agendaItems[w.id] = i;
                            //   }
                            //   API().updateAgendaUser(
                            //       AppInfo.currentConferenceUser);
                            //   setState(() {});
                            // } else {
                            //   AppInfo.currentConferenceUser.agendaItems[w.id] =
                            //       i;
                            //   API().updateAgendaUser(
                            //       AppInfo.currentConferenceUser);
                            //   setState(() {});
                            // }
                            // }
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.68,
                            height: 41,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: const Color(0xFF18AE9F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Symbols.add,
                                    color: const Color(0xFF18AE9F),
                                    size: 22,
                                    fill: 1.0),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 0, 0),
                                  child: Text(
                                    "Add to Google Calendar",
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: const Color(0xFF18AE9F)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]) : SizedBox(),
                ],
              ));
        });
  }
}
