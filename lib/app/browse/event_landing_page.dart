// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/objects/event_data.dart';
import '../../api/logic/dates.dart';
import '../navigation/navigation.dart';

class EventLandingPage extends StatefulWidget {
  EventData e;
  EventLandingPage({super.key, required this.e});

  @override
  State<EventLandingPage> createState() => _EventLandingPageState(e);
}

class _EventLandingPageState extends State<EventLandingPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  EventData e;
  _EventLandingPageState(this.e);
  late ScrollController _scrollController;
  bool dataLoaded = true;
  List<String> prelimOptions = [];
  Timer? timer;
  String prelim = "";
  Map<String, List<String>> orderedMap = {};
  bool showPast = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    API.setDark();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {});
    });
    e.competitors.forEach((key, val) {
      String lastPart = key.split(" ").last;
      if (lastPart.length == 1 && !prelimOptions.contains(lastPart)) {
        prelimOptions.add(lastPart);
      }
    });
    prelimOptions.sort((a, b) => a.compareTo(b));
    if (prelimOptions[0] != "F") {
      prelim = prelimOptions[0];
    }
    List<String> filteredKeys = e.competitors.keys.toList();

    for (String key in filteredKeys) {
      orderedMap[key] = e.competitors[key]!;
    }
    // Future.delayed(Duration(seconds: 3), () {
    //   setState(() {
    //     dataLoaded = true;
    //   });
    // });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          // Align(
          //   alignment: const AlignmentDirectional(0, 1),
          //   child: Container(
          //     width: MediaQuery.sizeOf(context).width,
          //     height: 130,
          //     decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [
          //           Color(0x00ECECEC),
          //           Color.fromARGB(217, 236, 236, 236)
          //         ],
          //         stops: [0, 1],
          //         begin: AlignmentDirectional(0, -1),
          //         end: AlignmentDirectional(0, 1),
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: const AlignmentDirectional(0, 1),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
              child: InkWell(
                onTap: () {
                  if (AppInfo.currentConferenceUser.events.contains(e.id)) {
                    AppInfo.currentConferenceUser.events.remove(e.id);
                    AppInfo.currentEvents
                        .removeWhere((element) => element.id == e.id);
                    API().addEventUser(
                        AppInfo.currentConferenceUser, AppInfo.conference.id);
                    setState(() {});
                  } else {
                    AppInfo.currentConferenceUser.events.add(e.id);
                    AppInfo.currentEvents.add(e);
                    API().addEventUser(
                        AppInfo.currentConferenceUser, AppInfo.conference.id);
                    setState(() {});
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.68,
                  height: 41,
                  decoration: BoxDecoration(
                    color: AppInfo.currentConferenceUser.events.contains(e.id)
                        ? const Color(0xFF18AE9F)
                        : Colors.white,
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
                      Icon(
                          AppInfo.currentConferenceUser.events.contains(e.id)
                              ? Symbols.check
                              : Symbols.add,
                          color: !AppInfo.currentConferenceUser.events
                                  .contains(e.id)
                              ? const Color(0xFF18AE9F)
                              : Colors.white,
                          size: 22,
                          fill: AppInfo.currentConferenceUser.events
                                  .contains(e.id)
                              ? 1.0
                              : 0.0),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                        child: Text(
                          !AppInfo.currentConferenceUser.events.contains(e.id)
                              ? 'This is My Event'
                              : "This is My Event",
                          style: TextStyle(fontFamily: 'DM Sans',
                            
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: !AppInfo.currentConferenceUser.events
                                    .contains(e.id)
                                ? const Color(0xFF18AE9F)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (b, a) {
          // Handle back button press here
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Navigation(
                pIndex: 2,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 60),
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
                                    pIndex: 2,
                                    reNav: false,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(-1.0, 0.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end);
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  color: const Color(0xFF000000),
                                  size: (!kIsWeb && Platform.isIOS) ? 15 : 17,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      6, 0, 0, 0),
                                  child: Text(
                                    'Competitive Events',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Colors.black,
                                      fontSize:
                                          (!kIsWeb && Platform.isIOS) ? 18 : 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 27,
                              decoration: BoxDecoration(
                                color: const Color(0xBFECEBFF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: Text(
                                    '${e.round} | ${getEventType()}',
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
                                      color: const Color(0xFF252C72),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppInfo.conference.bpLink != ""
                          ? Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  25, 6, 25, 0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrl(Uri.parse(
                                            AppInfo.conference.bpLink))) {
                                          await launchUrl(
                                              Uri.parse(
                                                  AppInfo.conference.bpLink),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                      child: Container(
                                        height: 27,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE3ECFB),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 6,
                                              color: Color(0x198A8A8A),
                                              offset: Offset(
                                                0,
                                                3,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12, 0, 12, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.open_in_new,
                                                color: Color(0xFF252C72),
                                                size: 14,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(6, 0, 0, 0),
                                                child: Text(
                                                  'View in BluePandas',
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color:
                                                        const Color(0xFF252C72),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))
                          : const SizedBox(),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      (!kIsWeb && Platform.isIOS) ? 26.5 : 26,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      getPrelimSelectWidgets().isNotEmpty
                          ? Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  25, 25, 25, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: getPrelimSelectWidgets(),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 20, 0, 13),
                        child: MediaQuery(
                          data: MediaQuery.of(context).removePadding(
                              removeBottom: true, removeTop: true),
                          child: SafeArea(
                            child: Scrollbar(
                              controller: _scrollController,
                              // reverse: true,
                              thickness: 2.0,
                              radius: const Radius.circular(15),
                              thumbVisibility: true,
                              trackVisibility: false,
                              interactive: true,

                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 7.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 39,
                                        height: 39,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0ECFF),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.calendar_today_outlined,
                                          color: Color(0xFF226ADD),
                                          size: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getPrelimTimes(),
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              DateFormat("EEEE, MMMM d").format(
                                                  DateTime.parse(e.date
                                                      .replaceAll('/', '-'))),
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                color: const Color(0xFF8A8A8A),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(25, 0, 0, 0),
                                        child: Container(
                                          width: 39,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE0ECFF),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.location_on_outlined,
                                            color: Color(0xFF226ADD),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getEventType() == "Case Study"
                                                  ? "Prep: ${getLocation()}"
                                                  : "Present: ${getLocation()}",
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              getEventType() == "Case Study"
                                                  ? "Present: ${getPrepLocation()}"
                                                  : AppInfo.conference.location,
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                color: const Color(0xFF8A8A8A),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      for (Widget item in getPrelimWidgets()) (item),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 25, 25, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Text(
                                'Past Teams',
                                style: TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showPast = !showPast;
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 21,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(12),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                    child: Text(
                                      showPast ? 'Hide' : 'Show',
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: const Color(0xFF585858),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      showPast
                          ? Column(children: getPastItems())
                          : const SizedBox(),
                      const SizedBox(height: 100),
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

  String getEventType() {
    String t = e.type.toLowerCase().replaceAll(' ', '');
    String type = "";
    if (t == "case" || t == "rp") {
      type = "Case Study";
    } else if (t.contains('pres')) {
      type = "Presentation";
    } else if (t.contains('chapter')) {
      type = 'Chapter';
    }

    return type;
  }

  List<Widget> getPrelimSelectWidgets() {
    List<Widget> items = [];
    if (e.round == "Final Round") {
      return [];
    }

    for (int i = 0; i < prelimOptions.length; i++) {
      items.add(
        prelim == prelimOptions[i]
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      prelim = prelimOptions[i];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: 91,
                      height: 33,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12, 0, 12, 0),
                          child: Text(
                            prelimOptions[i],
                            maxLines: 1,
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      prelim = prelimOptions[i];
                      // List<String> filteredKeys = e.competitors.keys
                      //     .where((key) => key.contains(prelim))
                      //     .toList();
                      // filteredKeys.sort((a, b) => Dates.parseTimeString(
                      //         a.replaceAll(".", ":"))
                      //     .compareTo(
                      //         Dates.parseTimeString(b.replaceAll(".", ":"))));
                      // orderedMap = {};
                      // for (String key in filteredKeys) {
                      //   if (!Dates.isBeforeCurrentTime(Dates.getCheckinTime(
                      //           key.replaceAll(".", ":"))) &&
                      //       Dates.isSameDateAsNow(e.date)) {
                      //   } else {
                      //     orderedMap[key] = e.competitors[key]!;
                      //   }
                      // }
                    });
                  },
                  child: Container(
                    width: 37,
                    height: 33,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFBFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0x0F3B4071),
                        width: 2,
                      ),
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        prelimOptions[i],
                        maxLines: 1,
                        style: TextStyle(fontFamily: 'DM Sans',
                          
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                )),
      );
    }
    return items;
  }

  String getPrelimTimes() {
    List<String> filteredKeys =
        e.competitors.keys.where((key) => key.contains(prelim)).toList();

    List<Map<String, dynamic>> times = filteredKeys.map((timeString) {
      List<String> parts = timeString.split(' ');
      String time = parts[0];
      String identifier = parts[1];
      DateTime dateTime = Dates.parseTimeString(time);
      return {'time': dateTime, 'identifier': identifier};
    }).toList();

    DateTime earliestTime = times
        .map((e) => e['time'] as DateTime)
        .reduce((a, b) => a.isBefore(b) ? a : b)
        .subtract(const Duration(minutes: 20));
    DateTime latestTime = times
        .map((e) => e['time'] as DateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // Format the times into the desired format
    int earliestHour =
        earliestTime.hour > 12 ? earliestTime.hour - 12 : earliestTime.hour;
    int latestHour =
        latestTime.hour > 12 ? latestTime.hour - 12 : latestTime.hour;

    String formattedEarliestTime =
        '${earliestHour..toString()}.${earliestTime.minute.toString().padLeft(2, '0')}${earliestTime.hour >= 12 ? 'PM' : 'AM'}';
    String formattedLatestTime =
        '${latestHour.toString()}.${latestTime.minute.toString().padLeft(2, '0')}${latestTime.hour >= 12 ? 'PM' : 'AM'}';

    // Return the time range
    return '$formattedEarliestTime - $formattedLatestTime';
  }

  String getLocation() {
    List<String> filteredKeys =
        e.competitors.keys.where((key) => key.contains(prelim)).toList();
    return e.competitors[filteredKeys[0]]!.last.split(";")[1];
  }

  String getPrepLocation() {
    List<String> filteredKeys =
        e.competitors.keys.where((key) => key.contains(prelim)).toList();
    return e.competitors[filteredKeys[0]]!.last.split(";").length > 2
        ? e.competitors[filteredKeys[0]]!.last.split(";")[3]
        : "No Prep location";
  }

  List<Widget> getPrelimWidgets() {
    List<Widget> items = [];
    String type = getEventType();
    bool c = type == "Case Study";

    Map<String, List<String>> events = Map.fromEntries(
        orderedMap.entries.where((entry) => entry.key.contains(prelim)));

    List<String> keys = events.keys.toList();
    keys.sort((a, b) => Dates.parseTimeString(a.split(" ")[0])
        .compareTo(Dates.parseTimeString(b.split(" ")[0])));
    for (int i = 0; i < keys.length; i++) {
      String time = keys[i].split(" ")[0];

      List<String> items2 = events[keys[i]]!;
      List<String> otherInfo = items2.last.split(";");
      items2 = items2.sublist(0, items2.length - 1);

      DateTime targetTime = Dates.parseDateTime(e.date, time)
          .subtract(const Duration(minutes: 20));

      if ((DateTime.now().toLocal().isAfter(targetTime))) {
        continue;
      } else {}
      Duration timeDifference = targetTime.difference(DateTime.now().toLocal());

      String checkInTime = DateFormat('h.mma').format(targetTime).toUpperCase();

      String tempPrep = DateFormat('h.mma')
          .format(targetTime.add(const Duration(minutes: 35)))
          .toUpperCase();
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

      if (!c) {
        items.add(
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.88,
              height: 150,
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
                  Container(
                    width: 84,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Text(
                              'Check-in',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: const Color(0xAFFFFFFF),
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 8,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 3, 0, 0),
                            child: AutoSizeText(
                              checkInTime,
                              maxLines: 1,
                              style: TextStyle(fontFamily: 'DM Sans',
                                
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: Text(
                              'Perform',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: const Color(0xA6FFFFFF),
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 8,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            time.replaceAll(":", '.').toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Dates.isSameDateAsNow(e.date)
                                        ? Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: Container(
                                              width: 110,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: hours == 0 &&
                                                        minutes <= 30
                                                    ? const Color.fromARGB(
                                                        9, 114, 37, 37)
                                                    : const Color(0xC0ECEBFF),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Starts in ',
                                                        style: TextStyle(
                                                          color: hours == 0 &&
                                                                  minutes <= 30
                                                              ? const Color(
                                                                  0xFFAE1919)
                                                              : const Color(
                                                                  0xFF252C72),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${hours}h ${minutes}m',
                                                        style: TextStyle(
                                                          color: hours == 0 &&
                                                                  minutes <= 30
                                                              ? const Color(
                                                                  0xFFAE1919)
                                                              : const Color(
                                                                  0xFF252C72),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      
                                                      fontSize: (!kIsWeb &&
                                                              Platform.isIOS)
                                                          ? 11
                                                          : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    i == 0
                                        ? Container(
                                            width: 80,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: const Color(0x08272727),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: Text(
                                                'Upcoming',
                                                style: TextStyle(fontFamily: 'DM Sans',
                                                  
                                                  color:
                                                      const Color(0xFF606060),
                                                  fontSize: 9,
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
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: AutoSizeText(
                                  items2
                                      .map((name) => name.split(' ').last)
                                      .toList()
                                      .join(', '),
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: Colors.black,
                                    fontSize:
                                        (!kIsWeb && Platform.isIOS) ? 19 : 17,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        otherInfo[0],
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'RedHatDisplay',
                                          color: const Color(0xFF8D8D92),
                                          fontWeight: FontWeight.w500,
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 14
                                              : 12,
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
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        items.add(
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.88,
              height: 150,
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
                  Container(
                    width: 84,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Text(
                              'Check-in',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: const Color(0xAFFFFFFF),
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 8,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 3, 0, 0),
                            child: AutoSizeText(
                              checkInTime,
                              maxLines: 1,
                              style: TextStyle(fontFamily: 'DM Sans',
                                
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 0),
                            child: Text(
                              'Prep',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: const Color(0xA6FFFFFF),
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 8,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            time,
                            maxLines: 1,
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 10,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 0),
                            child: Text(
                              'Perform',
                              style: TextStyle(
                                fontFamily: 'RedHatDisplay',
                                color: const Color(0xA6FFFFFF),
                                fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 8,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            otherInfo.length > 2
                                ? otherInfo[2]
                                    .replaceAll(' ', '')
                                    .replaceAll(':', '.')
                                    .toUpperCase()
                                : tempPrep.toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: (!kIsWeb && Platform.isIOS) ? 11 : 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Dates.isSameDateAsNow(e.date)
                                        ? Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: Container(
                                              width: 110,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: hours == 0 &&
                                                        minutes <= 30
                                                    ? const Color.fromARGB(
                                                        9, 114, 37, 37)
                                                    : const Color(0xC0ECEBFF),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Starts in ',
                                                        style: TextStyle(
                                                          color: hours == 0 &&
                                                                  minutes <= 30
                                                              ? const Color(
                                                                  0xFFAE1919)
                                                              : const Color(
                                                                  0xFF252C72),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${hours}h ${minutes}m',
                                                        style: TextStyle(
                                                          color: hours == 0 &&
                                                                  minutes <= 30
                                                              ? const Color(
                                                                  0xFFAE1919)
                                                              : const Color(
                                                                  0xFF252C72),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    ],
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      
                                                      fontSize: (!kIsWeb &&
                                                              Platform.isIOS)
                                                          ? 11
                                                          : 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    i == 0
                                        ? Container(
                                            width: 80,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: const Color(0x08272727),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              child: Text(
                                                'Upcoming',
                                                style: TextStyle(fontFamily: 'DM Sans',
                                                  
                                                  color:
                                                      const Color(0xFF606060),
                                                  fontSize: 9,
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
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: AutoSizeText(
                                  items2
                                      .map((name) => name.split(' ').last)
                                      .toList()
                                      .join(', '),
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: Colors.black,
                                    fontSize:
                                        (!kIsWeb && Platform.isIOS) ? 19 : 17,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        otherInfo[0],
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'RedHatDisplay',
                                          color: const Color(0xFF8D8D92),
                                          fontWeight: FontWeight.w500,
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 14
                                              : 12,
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
                  ),
                ],
              ),
            ),
          ),
        );
      }
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
                      'There are no upcoming teams for this event (and/or prelim).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'DM Sans',
                        
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

  List<Widget> getPastItems() {
    List<Widget> items = [];
    String type = getEventType();
    bool c = type == "Case Study";

    Map<String, List<String>> events = Map.fromEntries(
        orderedMap.entries.where((entry) => entry.key.contains(prelim)));

    List<String> keys = events.keys.toList();
    keys.sort((a, b) => Dates.parseTimeString(a.split(" ")[0])
        .compareTo(Dates.parseTimeString(b.split(" ")[0])));
    for (int i = 0; i < keys.length; i++) {
      String time = keys[i].split(" ")[0];

      List<String> items2 = events[keys[i]]!;
      List<String> otherInfo = items2.last.split(";");
      items2 = items2.sublist(0, items2.length - 1);

      DateTime targetTime = Dates.parseDateTime(e.date, time)
          .subtract(const Duration(minutes: 20));

      if (!(DateTime.now().toLocal().isAfter(targetTime))) {
        continue;
      } else {}

      String checkInTime = DateFormat('h.mma').format(targetTime).toUpperCase();
      String tempPrep = DateFormat('h.mma')
          .format(targetTime.add(const Duration(minutes: 35)))
          .toUpperCase();

      if (!c) {
        items.add(SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.88,
            child: Stack(children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.88,
                    height: 150,
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
                        Container(
                          width: 84,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                18, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Text(
                                    'Check-in',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Color(0xAFFFFFFF),
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 3, 0, 0),
                                  child: AutoSizeText(
                                    checkInTime,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: Text(
                                    'Perform',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Color(0xA6FFFFFF),
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  time.replaceAll(":", '.').toUpperCase(),
                                  maxLines: 1,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: AutoSizeText(
                                        items2
                                            .map((name) => name.split(' ').last)
                                            .toList()
                                            .join(', '),
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                        style: TextStyle(fontFamily: 'DM Sans',
                                          
                                          color: Colors.black,
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 19
                                              : 17,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 8, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              otherInfo[0],
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'RedHatDisplay',
                                                color: const Color(0xFF8D8D92),
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    (!kIsWeb && Platform.isIOS)
                                                        ? 14
                                                        : 12,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xA8C7C7C7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )
            ])));
      } else {
        items.add(SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.88,
            child: Stack(children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.88,
                    height: 150,
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
                        Container(
                          width: 84,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                18, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Text(
                                    'Check-in',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Color(0xAFFFFFFF),
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 3, 0, 0),
                                  child: AutoSizeText(
                                    checkInTime,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Text(
                                    'Prep',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Color(0xA6FFFFFF),
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  time,
                                  maxLines: 1,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Text(
                                    'Perform',
                                    style: TextStyle(
                                      fontFamily: 'RedHatDisplay',
                                      color: Color(0xA6FFFFFF),
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                AutoSizeText(
                                  otherInfo.length > 2
                                      ? otherInfo[2]
                                          .replaceAll(' ', '')
                                          .replaceAll(':', '.')
                                          .toUpperCase()
                                      : tempPrep.toUpperCase(),
                                  maxLines: 1,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 15, 15, 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: AutoSizeText(
                                        items2
                                            .map((name) => name.split(' ').last)
                                            .toList()
                                            .join(', '),
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                        style: TextStyle(fontFamily: 'DM Sans',
                                          
                                          color: Colors.black,
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 19
                                              : 17,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 8, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              otherInfo[0],
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'RedHatDisplay',
                                                color: const Color(0xFF8D8D92),
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    (!kIsWeb && Platform.isIOS)
                                                        ? 14
                                                        : 12,
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xA8C7C7C7),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )
            ])));
      }
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
                      'There are no past teams for this event (and/or this prelim).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'DM Sans',
                        
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
