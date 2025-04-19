// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/logic/dates.dart';
import '../../api/objects/workshop_data.dart';
import '../../api/logic/bottom_sheets.dart';
import '../navigation/navigation.dart';

class WorkshopBrowsePage extends StatefulWidget {
  WorkshopData w;
  WorkshopBrowsePage({super.key, required this.w});

  @override
  State<WorkshopBrowsePage> createState() => _WorkshopBrowsePageState(w);
}

class _WorkshopBrowsePageState extends State<WorkshopBrowsePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> dates = [];
  List<WorkshopData> workshops = AppInfo.currentWorkshops;
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
  WorkshopData w;
  _WorkshopBrowsePageState(this.w);
  List<Map<String, String>> sessions = [];

  @override
  void initState() {
    sessions = w.sessions;
    sessions.sort((a, b) => Dates.parseTimeString(a['startTime']!)
        .compareTo(Dates.parseTimeString(b['startTime']!)));

    super.initState();
    API.setDark();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  pIndex: 3,
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
            // Return true to allow the back navigation, or false to block it
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height * 1,
            ),
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
              // Generated code for this Column Widget...
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 8, 25, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Navigation(
                                pIndex: 3,
                                reNav: false,
                              ),
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
                            (route) =>
                                false, // This condition removes all previous routes
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                              size: 17,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                              child: Text(
                                'Conference Agenda',
                                style: TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 8, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
                              child: Text(
                                w.name,
                                style: const TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 26,
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
                          const EdgeInsetsDirectional.fromSTEB(25, 15, 0, 15),
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
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${w.startTime.replaceAll(':', '.').toUpperCase()} - ${w.endTime.replaceAll(':', '.').toUpperCase()}',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  DateFormat("EEEE, MMMM d").format(
                                          DateTime.parse(
                                              w.date.replaceAll('/', '-'))) +
                                      Dates.addSuffix(int.parse(
                                          DateFormat("EEEE, MMMM d")
                                              .format(DateTime.parse(
                                                  w.date.replaceAll('/', '-')))
                                              .split(" ")
                                              .last)),
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: const Color(0xFF8A8A8A),
                                    fontSize: 13,
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
                          const EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Available Sessions',
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: const Color(0xFF8A8A8A),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (Widget item in getWorkshopWidgets()) (item),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ])),
          ),
        ));
  }

  List<Widget> getWorkshopWidgets() {
    List<Widget> items = [];

    for (int i = 0; i < sessions.length; i++) {
      items.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: InkWell(
          onTap: () {
            BottomSheets.getCheckinPage(
              context,
              w,
              i,
            );
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.88,
            height: 130,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.sessions[i]['name']!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontFamily: 'DM Sans',
                                
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              w.sessions[i]['desc']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'DM Sans',
                                
                                color: const Color(0xFF717171),
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF2E2E2E),
                              size: 13,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 0, 0, 0),
                              child: Text(
                                w.sessions[i]['location']!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'RedHatDisplay',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (AppInfo.currentConferenceUser.agendaItems
                              .containsKey(w.id)) {
                            int index = AppInfo
                                .currentConferenceUser.agendaItems[w.id]!;
                            if (index == i) {
                                  FirebaseMessaging.instance.unsubscribeFromTopic(w.id + i.toString());
                              AppInfo.currentConferenceUser.agendaItems
                                  .remove(w.id);
                            } else {
                                FirebaseMessaging.instance.subscribeToTopic(w.id + i.toString());
                              AppInfo.currentConferenceUser.agendaItems[w.id] =
                                  i;
                            }
                            API().updateAgendaUser(
                                AppInfo.currentConferenceUser);
                            setState(() {});
                          } else {
                              FirebaseMessaging.instance.subscribeToTopic(w.id + i.toString());
                            AppInfo.currentConferenceUser.agendaItems[w.id] = i;
                            API().updateAgendaUser(
                                AppInfo.currentConferenceUser);
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: BoxDecoration(
                            color: AppInfo.currentConferenceUser.agendaItems
                                        .containsKey(w.id) &&
                                    AppInfo.currentConferenceUser
                                            .agendaItems[w.id] ==
                                        i
                                ? const Color(0xFF18AE9F)
                                : Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Icon(
                              AppInfo.currentConferenceUser.agendaItems
                                          .containsKey(w.id) &&
                                      AppInfo.currentConferenceUser
                                              .agendaItems[w.id] ==
                                          i
                                  ? Symbols.check
                                  : Symbols.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    if (items.isEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.88,
            decoration: BoxDecoration(
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
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(18, 15, 18, 15),
                    child: Text(
                      'There are no items available for the selected session.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'DM Sans',
                        
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }
}
