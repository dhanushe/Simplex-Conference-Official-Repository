import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'workshop_browse.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/objects/workshop_data.dart';
import '../../api/logic/bottom_sheets.dart';

import '../../api/logic/dates.dart';

class ConfAgendaPage extends StatefulWidget {
  const ConfAgendaPage({super.key});

  @override
  State<ConfAgendaPage> createState() => _ConfAgendaPageState();
}

class _ConfAgendaPageState extends State<ConfAgendaPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> dates = [];
  List<WorkshopData> workshops = AppInfo.currentWorkshops;
  Timer? timer;

  bool showPast = false;

  // Runs this code when the page is initially loaded
  @override
  void initState() {
    workshops.sort((a, b) => Dates.parseTimeString(a.startTime)
        .compareTo(Dates.parseTimeString(b.startTime)));
    dates = Dates.generateDateList(
        AppInfo.conference.startDate, AppInfo.conference.endDate);

    super.initState();
    API.setDark();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {});
    });
  }

  // Runs this code when the page is gotten rid of
  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  // Returns the UI for the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 1,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 60),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 8, 25, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Icon(
                            Symbols.calendar_month,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        Text(
                          'Conference Agenda',
                          style: TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 18, 0, 0),
                    child: getDateWidgets().length > 4
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: getDateWidgets(),
                            ))
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            children: getDateWidgets(),
                          ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 18, 0, 0),
                      child: Text(
                        DateFormat('EEEE, MMMM d')
                            .format(DateTime.parse(AppInfo.selectedDate)),
                        style: const TextStyle(
                          fontFamily: 'RedHatDisplay',
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0x0C3B4071),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: !AppInfo.showMySchedule
                                    ? [
                                        Expanded(
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 7,
                                                  color: Color(0x1D000000),
                                                  offset: Offset(
                                                    0,
                                                    2.6,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              border: Border.all(
                                                color: const Color(0x083B4071),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Schedule',
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: (!kIsWeb &&
                                                            Platform.isIOS)
                                                        ? 13
                                                        : 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              AppInfo.showMySchedule =
                                                  !AppInfo.showMySchedule;
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'My Schedule',
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: (!kIsWeb &&
                                                              Platform.isIOS)
                                                          ? 13
                                                          : 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    : [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              AppInfo.showMySchedule =
                                                  !AppInfo.showMySchedule;
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Schedule',
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 7,
                                                  color: Color(0x1D000000),
                                                  offset: Offset(
                                                    0,
                                                    2.6,
                                                  ),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              border: Border.all(
                                                color: const Color(0x083B4071),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'My Schedule',
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
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
                      ],
                    ),
                  ),

                  for (Widget item in getWorkshopWidgets()) (item),
                  // Generated code for this Row Widget...
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
                            'Past Items',
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                      ? Column(children: getPastWorkshops())
                      : const SizedBox(),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Parses a String formatted in h:mm format, makes it a DateTime object

  // Gets a list of dates from the start date to end date

  // Gets all the widgets for date selection
  List<Widget> getDateWidgets() {
    List<Widget> items = [];

    String date2 = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
    String currentTime = DateFormat('h:mm a').format(DateTime.now().toLocal());

    if (date2 != AppInfo.selectedDate && currentTime == "12:00 AM") {
      AppInfo.selectedDate = date2;
      dates = Dates.generateDateList(
          AppInfo.conference.startDate, AppInfo.conference.endDate);
    }

    for (int i = 0; i < dates.length; i++) {
      items.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
          child: InkWell(
            onTap: () {
              if (dates[i] == "Today") {
                AppInfo.selectedDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
              } else {
                AppInfo.selectedDate = dates[i];
              }
              setState(() {});
            },
            child: Container(
              width: (dates[i] == "Today" &&
                          AppInfo.selectedDate ==
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now().toLocal())) ||
                      dates[i] == AppInfo.selectedDate
                  ? 96
                  : 82,
              height: 26,
              decoration: BoxDecoration(
                color: (dates[i] == "Today" &&
                            AppInfo.selectedDate ==
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now().toLocal())) ||
                        dates[i] == AppInfo.selectedDate
                    ? Colors.black
                    : const Color(0xFFfbfbfb),
                borderRadius: BorderRadius.circular(18),
                border: (dates[i] == "Today" &&
                            AppInfo.selectedDate ==
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now().toLocal())) ||
                        dates[i] == AppInfo.selectedDate
                    ? null
                    : Border.all(
                        color: const Color(0x473B4071),
                      ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Text(
                  dates[i] == 'Today' ? 'Today' : formatDateString(dates[i]),
                  style: TextStyle(fontFamily: 'DM Sans',
                    
                    color: (dates[i] == "Today" &&
                                AppInfo.selectedDate ==
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now().toLocal())) ||
                            dates[i] == AppInfo.selectedDate
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  // Formats a date string from yyyy-MM-dd to a different format
  String formatDateString(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMM. dd').format(date);
    return formattedDate;
  }

  // Gets the various workshop widgets
  List<Widget> getWorkshopWidgets() {
    Iterable<WorkshopData> workshops2 = !AppInfo.showMySchedule
        ? workshops.where(
            (element) => element.date == AppInfo.selectedDate,
          )
        : workshops.where((element) =>
            element.date == AppInfo.selectedDate &&
            (AppInfo.currentConferenceUser.agendaItems
                    .containsKey(element.id) ||
                element.type == "Event"));
    List<Widget> items = [];

    for (WorkshopData w in workshops2) {
      bool today =
          w.date == DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

      Widget times = const SizedBox();
      bool nextDay = Dates.parseTimeString(w.startTime)
          .isAfter(Dates.parseTimeString(w.endTime));

      if ((!nextDay &&
              DateTime.now()
                  .toLocal()
                  .isAfter(Dates.parseDateTime(w.date, w.endTime))) ||
          (nextDay &&
              DateTime.now().toLocal().isAfter(
                  Dates.parseDateTime(w.date, w.endTime)
                      .add(const Duration(days: 1))))) {
        continue;
      } else {}
      if (today) {
        DateTime targetTime = Dates.parseDateTime(w.date, w.startTime);
        Duration timeDifference =
            targetTime.difference(DateTime.now().toLocal());

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

        if (!DateTime.now()
            .toLocal()
            .isAfter(Dates.parseDateTime(w.date, w.startTime))) {
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
                    style: TextStyle(fontFamily: 'DM Sans',
                      
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
                    .isBefore(Dates.parseDateTime(w.date, w.endTime))) ||
            (nextDay &&
                DateTime.now().toLocal().isBefore(
                    Dates.parseDateTime(w.date, w.endTime)
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
                    style: TextStyle(fontFamily: 'DM Sans',
                      
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopBrowsePage(w: w)),
                        );
                      } else {
                        BottomSheets.getCheckinPage(context, w, -1);
                      }
                    },
                    child: Stack(children: [
                      Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color: w.type == "Event"
                                                        ? const Color(
                                                            0xFF0904F4)
                                                        : w.type == "Session"
                                                            ? const Color(
                                                                0xFFFF6F00)
                                                            : const Color(
                                                                0xFF00AE66),
                                                    fontSize: 10,
                                                    fontWeight: (!kIsWeb &&
                                                            Platform.isIOS)
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
                                                const AlignmentDirectional(
                                                    -1, 0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                w.name,
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                style: TextStyle(fontFamily: 'DM Sans',
                                                  
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          w.type != "Session"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 12, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                                  .fromSTEB(
                                                                  4, 0, 0, 0),
                                                          child: Text(
                                                            w.location,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'RedHatDisplay',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 12, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 0, 8, 0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      WorkshopBrowsePage(
                                                                          w: w)),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 108,
                                                            height: 22,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFFFF6F00),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              // border:
                                                              //     Border.all(
                                                              //   color: const Color(
                                                              //       0x0F3B4071),
                                                              //   width: 1,
                                                              // ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      12,
                                                                      0,
                                                                      12,
                                                                      0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      'View Sessions',
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(fontFamily: 'DM Sans',
                                                                       
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: (!kIsWeb &&
                                                                                Platform.isIOS)
                                                                            ? 12
                                                                            : 10,
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
                                                ),
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
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Text(
                                        'Start',
                                        style: TextStyle(
                                          fontFamily: 'RedHatDisplay',
                                          color: w.type == "Event"
                                              ? const Color.fromARGB(
                                                  180, 8, 4, 244)
                                              : w.type == "Session"
                                                  ? const Color.fromARGB(
                                                      180, 255, 111, 0)
                                                  : const Color.fromARGB(
                                                      180, 0, 174, 101),
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 12
                                              : 10,
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      w.startTime
                                          .toUpperCase()
                                          .replaceAll(":", "."),
                                      maxLines: 1,
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: w.type == "Event"
                                            ? const Color.fromARGB(
                                                255, 8, 4, 244)
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 15, 0, 0),
                                      child: Text(
                                        'End',
                                        style: TextStyle(
                                          fontFamily: 'RedHatDisplay',
                                          color: w.type == "Event"
                                              ? const Color.fromARGB(
                                                  180, 8, 4, 244)
                                              : w.type == "Session"
                                                  ? const Color.fromARGB(
                                                      180, 255, 111, 0)
                                                  : const Color.fromARGB(
                                                      180, 0, 174, 101),
                                          fontSize: (!kIsWeb && Platform.isIOS)
                                              ? 12
                                              : 10,
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      w.endTime
                                          .toUpperCase()
                                          .replaceAll(":", "."),
                                      maxLines: 1,
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: w.type == "Event"
                                            ? const Color.fromARGB(
                                                255, 8, 4, 244)
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
                    ]),
                  )),
            ),
            Align(
              alignment: const AlignmentDirectional(1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 125, 83, 0),
                child: InkWell(
                  onTap: () {
                    if (AppInfo.currentConferenceUser.agendaItems
                        .containsKey(w.id)) {
                         FirebaseMessaging.instance.unsubscribeFromTopic(w.id);
                      AppInfo.currentConferenceUser.agendaItems.remove(w.id);
                      API().updateAgendaUser(AppInfo.currentConferenceUser);
                      setState(() {});
                    } else {
                      if (w.type == "Session") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopBrowsePage(w: w)),
                        );
                      } else {
                         FirebaseMessaging.instance.unsubscribeFromTopic(w.id);
                        AppInfo.currentConferenceUser.agendaItems[w.id] = -1;
                        API().updateAgendaUser(AppInfo.currentConferenceUser);
                        setState(() {});
                      }
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
                    if (AppInfo.currentConferenceUser.agendaItems
                        .containsKey(w.id)) {
                           FirebaseMessaging.instance.unsubscribeFromTopic(w.id);
                      AppInfo.currentConferenceUser.agendaItems.remove(w.id);
                      API().updateAgendaUser(AppInfo.currentConferenceUser);
                      setState(() {});
                    } else {
                      if (w.type == "Session") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopBrowsePage(w: w)),
                        );
                      } else {
                         FirebaseMessaging.instance.subscribeToTopic(w.id);
                        AppInfo.currentConferenceUser.agendaItems[w.id] = -1;
                        API().updateAgendaUser(AppInfo.currentConferenceUser);
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppInfo.currentConferenceUser.agendaItems
                                  .containsKey(w.id) ||
                              w.type == "Event"
                          ? const Color(0xFF18AE9F)
                          : Colors.black,
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: const Color(0xFFF8f8f8),
                      //   width: 5,
                      // ),
                    ),
                    child: Icon(
                      AppInfo.currentConferenceUser.agendaItems
                                  .containsKey(w.id) ||
                              w.type == "Event"
                          ? Symbols.check
                          : w.type != "Session"
                              ? Symbols.add
                              : Icons.chevron_right,
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
                      'There are no more agenda items for this day.',
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

  List<Widget> getPastWorkshops() {
    Iterable<WorkshopData> workshops2 = !AppInfo.showMySchedule
        ? workshops.where(
            (element) => element.date == AppInfo.selectedDate,
          )
        : workshops.where((element) =>
            element.date == AppInfo.selectedDate &&
            (AppInfo.currentConferenceUser.agendaItems
                    .containsKey(element.id) ||
                element.type == "Event"));
    List<Widget> items = [];

    for (WorkshopData w in workshops2) {
      Widget times = const SizedBox();
      bool nextDay = Dates.parseTimeString(w.startTime)
          .isAfter(Dates.parseTimeString(w.endTime));

      if ((!nextDay &&
              DateTime.now()
                  .toLocal()
                  .isAfter(Dates.parseDateTime(w.date, w.endTime))) ||
          (nextDay &&
              DateTime.now().toLocal().isAfter(
                  Dates.parseDateTime(w.date, w.endTime)
                      .add(const Duration(days: 1))))) {
      } else {
        continue;
      }

      items.add(
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.88,
          child: Stack(children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: InkWell(
                  onTap: () {
                    if (w.type == "Session") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkshopBrowsePage(w: w)),
                      );
                    } else {
                      BottomSheets.getCheckinPage(context, w, -1);
                    }
                  },
                  child: Stack(children: [
                    Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                style: TextStyle(fontFamily: 'DM Sans',
                                                  
                                                  color: w.type == "Event"
                                                      ? const Color(0xFF0904F4)
                                                      : w.type == "Session"
                                                          ? const Color(
                                                              0xFFFF6F00)
                                                          : const Color(
                                                              0xFF00AE66),
                                                  fontSize: 10,
                                                  fontWeight: (!kIsWeb &&
                                                          Platform.isIOS)
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
                                              w.name,
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                color: Colors.black,
                                                fontSize: 17,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        w.type != "Session"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 12, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                                .fromSTEB(
                                                                4, 0, 0, 0),
                                                        child: Text(
                                                          w.location,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'RedHatDisplay',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 12, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 0, 8, 0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    WorkshopBrowsePage(
                                                                        w: w)),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 108,
                                                          height: 22,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFFFF6F00),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            // border: Border.all(
                                                            //   color: const Color(
                                                            //       0x0F3B4071),
                                                            //   width: 1,
                                                            // ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    12,
                                                                    0,
                                                                    12,
                                                                    0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      const AlignmentDirectional(
                                                                          0, 0),
                                                                  child: Text(
                                                                    'View Sessions',
                                                                    maxLines: 1,
                                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                                      
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: Platform
                                                                              .isIOS
                                                                          ? 12
                                                                          : 10,
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
                                              ),
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
                                    alignment:
                                        const AlignmentDirectional(-1, 0),
                                    child: Text(
                                      'Start',
                                      style: TextStyle(
                                        fontFamily: 'RedHatDisplay',
                                        color: w.type == "Event"
                                            ? const Color.fromARGB(
                                                180, 8, 4, 244)
                                            : w.type == "Session"
                                                ? const Color.fromARGB(
                                                    180, 255, 111, 0)
                                                : const Color.fromARGB(
                                                    180, 0, 174, 101),
                                        fontSize: (!kIsWeb && Platform.isIOS)
                                            ? 12
                                            : 10,
                                      ),
                                    ),
                                  ),
                                  AutoSizeText(
                                    w.startTime
                                        .toUpperCase()
                                        .replaceAll(":", "."),
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 15, 0, 0),
                                    child: Text(
                                      'End',
                                      style: TextStyle(
                                        fontFamily: 'RedHatDisplay',
                                        color: w.type == "Event"
                                            ? const Color.fromARGB(
                                                180, 8, 4, 244)
                                            : w.type == "Session"
                                                ? const Color.fromARGB(
                                                    180, 255, 111, 0)
                                                : const Color.fromARGB(
                                                    180, 0, 174, 101),
                                        fontSize: (!kIsWeb && Platform.isIOS)
                                            ? 12
                                            : 10,
                                      ),
                                    ),
                                  ),
                                  AutoSizeText(
                                    w.endTime
                                        .toUpperCase()
                                        .replaceAll(":", "."),
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
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
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: InkWell(
                onTap: () {
                  if (w.type == "Session") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkshopBrowsePage(w: w)),
                    );
                  } else {
                    BottomSheets.getCheckinPage(context, w, -1);
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.88,
                  height: 136,
                  decoration: BoxDecoration(
                    color: (!nextDay &&
                                DateTime.now().toLocal().isAfter(
                                    Dates.parseDateTime(w.date, w.endTime))) ||
                            (nextDay &&
                                DateTime.now().toLocal().isAfter(
                                    Dates.parseDateTime(w.date, w.endTime)
                                        .add(const Duration(days: 1))))
                        ? const Color(0xA8C7C7C7)
                        : const Color(0x00FFFFFF),
                    borderRadius: BorderRadius.circular(25),
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
                    if (AppInfo.currentConferenceUser.agendaItems
                        .containsKey(w.id)) {
                              FirebaseMessaging.instance.unsubscribeFromTopic(w.id);
                      AppInfo.currentConferenceUser.agendaItems.remove(w.id);
                      API().updateAgendaUser(AppInfo.currentConferenceUser);
                      setState(() {});
                    } else {
                      if (w.type == "Session") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopBrowsePage(w: w)),
                        );
                      } else {
                            FirebaseMessaging.instance.subscribeToTopic(w.id);
                        AppInfo.currentConferenceUser.agendaItems[w.id] = -1;
                        API().updateAgendaUser(AppInfo.currentConferenceUser);
                        setState(() {});
                      }
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
                    if (AppInfo.currentConferenceUser.agendaItems
                        .containsKey(w.id)) {
                      AppInfo.currentConferenceUser.agendaItems.remove(w.id);
                      API().updateAgendaUser(AppInfo.currentConferenceUser);
                      setState(() {});
                    } else {
                      if (w.type == "Session") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopBrowsePage(w: w)),
                        );
                      } else {
                        AppInfo.currentConferenceUser.agendaItems[w.id] = -1;
                        API().updateAgendaUser(AppInfo.currentConferenceUser);
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppInfo.currentConferenceUser.agendaItems
                                  .containsKey(w.id) ||
                              w.type == "Event"
                          ? const Color(0xFF18AE9F)
                          : Colors.black,
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: const Color(0xFFF8f8f8),
                      //   width: 5,
                      // ),
                    ),
                    child: Icon(
                      AppInfo.currentConferenceUser.agendaItems
                                  .containsKey(w.id) ||
                              w.type == "Event"
                          ? Symbols.check
                          : w.type != "Session"
                              ? Symbols.add
                              : Icons.chevron_right,
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
                      if (AppInfo.currentConferenceUser.agendaItems
                          .containsKey(w.id)) {
                                FirebaseMessaging.instance.unsubscribeFromTopic(w.id);
                        AppInfo.currentConferenceUser.agendaItems.remove(w.id);
                        API().updateAgendaUser(AppInfo.currentConferenceUser);
                        setState(() {});
                      } else {
                        if (w.type == "Session") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkshopBrowsePage(w: w)),
                          );
                        } else {
                              FirebaseMessaging.instance.subscribeToTopic(w.id);
                          AppInfo.currentConferenceUser.agendaItems[w.id] = -1;
                          API().updateAgendaUser(AppInfo.currentConferenceUser);
                          setState(() {});
                        }
                      }
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xA8C7C7C7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      );
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
                      'There are no past agenda items for this day.',
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
