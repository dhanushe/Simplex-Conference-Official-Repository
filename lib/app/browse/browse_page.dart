// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/objects/event_data.dart';

import '../../api/logic/parsing.dart';
import 'event_landing_page.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String search = "";
  TextEditingController? text;
  bool dataLoaded = true;
  FocusNode? f;
  List<EventData> events = [];
  bool showOpenEventsOnly = false;

  _BrowsePageState() {
    events = AppInfo.allEvents;
    events.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  }

  @override
  void initState() {
    f = FocusNode();
    text = TextEditingController();
    super.initState();
    API.setDark();
  }

  @override
  void dispose() {
    f?.dispose();
    text?.dispose();

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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF9f9f9),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 65, 0, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(25, 8, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                            child: Icon(
                              Symbols.trophy,
                              color: Colors.black,
                              size: 28,
                            ),
                          ),
                          Text(
                            'Competitive Events',
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 5),
                      child: Container(
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
                        height: 44,
                        width: MediaQuery.sizeOf(context).width * 0.88,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (val) {
                            setState(
                              () {
                                search = val;
                              },
                            );
                          },
                          controller: text,
                          onChanged: (val) {
                            setState(
                              () {
                                search = val;
                              },
                            );
                          },
                          focusNode: f,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFAEAEAE),
                              fontSize: 13,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0x5BE0E0E0),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF226ADD),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    20, 6, 0, 6),
                            prefixIcon: Icon(
                              Icons.search,
                              color: f!.hasFocus || f!.hasPrimaryFocus
                                  ? const Color(0xFF226ADD)
                                  : text!.text == ""
                                      ? const Color(0xFFAEAEAE)
                                      : const Color(0xFF585858),
                              size: 20,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            color: f!.hasFocus || f!.hasPrimaryFocus
                                ? const Color(0xFF226ADD)
                                : const Color(0xFF585858),
                            fontSize: 13,
                          ),
                          minLines: null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          SizedBox(width: 25),
                          GestureDetector(
                        onTap: () {
                          setState(() {
                            showOpenEventsOnly = !showOpenEventsOnly;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: showOpenEventsOnly
                                ? const Color(0xFF19A5AE)
                                : const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Text(
                            'Open Event',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: showOpenEventsOnly
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF585858),
                            ),
                          ),
                        ),
                      ),
                      ])
                    ),
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        children: getEventWidgets(search)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getEventWidgets(String search) {
    List<Widget> items = [];

    for (EventData e in events) {
      if ((!showOpenEventsOnly || e.isOpen) &&
          Parsing.normalizeString(e.name.toLowerCase())
              .contains(Parsing.normalizeString(search.toLowerCase()))) {
        items.add(SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.88,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventLandingPage(e: e)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.86,
                    height: e.isOpen ? 60 : 40, // Adjust height for open events
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
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
                      borderRadius: (!kIsWeb && Platform.isIOS)
                          ? BorderRadius.circular(17)
                          : BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (e.isOpen)
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4EB),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              child: Text(
                                'Open Event',
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 10,
                                  color: const Color(0xFFFB8500),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4), // Space between tag and name
                          Flexible(
                            child: Text(
                              e.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: const Color(0xFF585858),
                                fontWeight: FontWeight.w400,
                                fontSize: (!kIsWeb && Platform.isIOS) ? 13.5 : 12,
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
                  padding:  EdgeInsetsDirectional.fromSTEB(0,  !e.isOpen ? 15 : 24, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventLandingPage(e: e)),
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
                  padding:  EdgeInsetsDirectional.fromSTEB(0, !e.isOpen ? 18 : 28, 2, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventLandingPage(e: e)),
                      );
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7F7F7F),
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
            ],
          ),
        ));
      }
    }

    if (items.isEmpty) {
      items.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.88,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'No events with the inputted search.',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    color: const Color(0xFF585858),
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    items.add(const SizedBox(height: 35));

    return items;
  }
}
