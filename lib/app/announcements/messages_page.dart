// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'announcements.dart';
import '../../api/logic/API.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? timer;

  @override
  void initState() {
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
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 1,
          child: const SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 65, 0, 60),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(25, 8, 25, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Icon(
                            Symbols.notifications,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        Text(
                          'Announcements',
                          style: TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnnouncementsPage(),
                ])),
          ])),
        ));
  }
}
