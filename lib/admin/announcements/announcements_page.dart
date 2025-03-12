// ignore_for_file: use_build_context_synchronously

import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../home/home_page.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/logic/dates.dart';

class AdminAnnouncements extends StatefulWidget {
  const AdminAnnouncements({super.key});

  @override
  State<AdminAnnouncements> createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends State<AdminAnnouncements> {
  TextEditingController? text1;
  bool sending = false;
  TextEditingController? text2;
  bool uploading = false;
  String name = "";
  String text = "";
  String file = "";
  bool showAnnouncements = false;
  bool dataLoaded = false;
  List<Map<String, String>> announcements = [];
  List<Widget> announcementItems = [];
  _AdminAnnouncementsState() {
    API().getAnnouncements(AppInfo.conference.id).then((value) {
      announcements = value;
      getAnnouncementWidgets().then(
        (value) {
          announcementItems = value;
          setState(() {
            dataLoaded = true;
          });
        },
      );
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    text1 = TextEditingController();
    text2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    text1!.dispose();
    text2!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * .8,
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height - 65,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 50, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Send Announcement',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name (First & Last Only)',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: TextFormField(
                        controller: text1,
                        obscureText: false,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Put name here...',
                          hintStyle: TextStyle(fontFamily: 'DM Sans',
                            
                            color: const Color(0xff000000),
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(0, 38, 41, 45),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              25, 15, 25, 15),
                        ),
                        style: TextStyle(fontFamily: 'DM Sans',
                          
                          color: const Color(0xff000000),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Announcement Text',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.635,
                      child: TextFormField(
                        controller: text2,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Put text here...',
                          hintStyle: TextStyle(fontFamily: 'DM Sans',
                            
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(0, 38, 41, 45),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              25, 20, 25, 20),
                        ),
                        style: TextStyle(fontFamily: 'DM Sans',
                          
                          color: const Color(0xff000000),
                          fontSize: 14,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'File (Optional)',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 400,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0x00FFFFFF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !uploading
                              ? InkWell(
                                  onTap: () async {
                                    await _pickImage();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 10, 15, 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 6, 0),
                                          child: Icon(
                                            Icons.file_upload_outlined,
                                            color: Color(0xff000000),
                                            size: 28,
                                          ),
                                        ),
                                        Text(
                                          'Upload New',
                                          style: TextStyle(fontFamily: 'DM Sans',
                                            
                                            color: const Color(0xff000000),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.black),
                          file != ""
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 15, 0),
                                  child: Column(children: [
                                    InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(file))) {
                                          await launchUrl(Uri.parse(file),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                      child: Container(
                                        width: 125,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0x2E000000),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Open Current',
                                            style: TextStyle(fontFamily: 'DM Sans',
                        
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          file = "";
                                        });
                                      },
                                      child: Container(
                                        width: 125,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              246, 255, 143, 143),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(fontFamily: 'DM Sans',
                                         
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )
                              : Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 15, 0),
                                  child: Container(
                                    width: 125,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0x2EFFFFFF),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Text(
                                        'None',
                                        style: TextStyle(fontFamily: 'DM Sans',
                                
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preview',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Initials are shown as a preview here, in the app they will be corrected to the inputted name\'s initials. In addition, links are also not shown here, but do work in the actual app.',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width * 0.35,
                      decoration: BoxDecoration(
                        color: const Color(0x0014181B),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
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
                                      'ME',
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name != "" ? name : "[Name]",
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: const Color(0xFF323232),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 3, 0, 0),
                                      child: Text(
                                        text != "" ? text : '[Text]',
                                        style: TextStyle(fontFamily: 'DM Sans',
                                          color: const Color(0xFF717171),
                                          
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 5, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Just Now',
                                            style: TextStyle(fontFamily: 'DM Sans',
                                              
                                              color: const Color(0xFF0088D4),
                                              fontSize: 12,
                                            ),
                                          ),
                                          file != ""
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          10, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (await canLaunchUrl(
                                                          Uri.parse(file))) {
                                                        await launchUrl(
                                                            Uri.parse(file),
                                                            mode: LaunchMode
                                                                .externalApplication);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 21,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xBEE6E6E6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                10, 0, 10, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .file_upload_outlined,
                                                              color: Color(
                                                                  0xFF616161),
                                                              size: 13,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      4,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Text(
                                                                'Attachment',
                                                                style:
                                                                    TextStyle(fontFamily: 'DM Sans',
                                                                  
                                                                  color: const Color(
                                                                      0xFF616161),
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
                      )),
                ])),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 60),
              child: !sending
                  ? InkWell(
                      onTap: () async {
                        if (name != "" ||
                            name.split(" ").length < 2 && !sending) {
                          setState(() {
                            sending = true;
                          });
                          List<Map<String, String>> announcements = await API()
                              .getAnnouncements(AppInfo.conference.id);

                          announcements.add({
                            'name': name,
                            'timestamp': DateTime.now().toUtc().toString(),
                            'text': text,
                            'image': file,
                          });

                          await API().updateAnnouncements(
                              announcements, AppInfo.conference.id);
                          _sendNotification(
                              text,
                              "",
                              'announcements-${AppInfo.conference.id}',
                              AppInfo.conference.name);

                          AppInfo.conference =
                              await API().getConference(AppInfo.conference.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 11, 43, 31),
                              content: Text('Announcement Sent!',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    
                                  ))));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (HomePageAdmin(pIndex: 0))),
                            (route) =>
                                false, // This condition removes all previous routes
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content: Text(
                                  'Name is empty or needs to have first AND last name.',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    
                                  ))));
                          setState(() {
                            sending = false;
                          });
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 62,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 40, 42, 51),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            'Post',
                            style: TextStyle(fontFamily: 'DM Sans',
                              color: Colors.black,
                              
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 50, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Previous Announcements',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontSize: 22,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showAnnouncements = !showAnnouncements;
                          });
                        },
                        child: Container(
                          width: 76,
                          height: 33,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 220, 220, 220),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Text(
                              showAnnouncements ? 'Hide' : 'Show',
                              style: TextStyle(fontFamily: 'DM Sans',
                                color: Colors.black,
                                
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: showAnnouncements && dataLoaded
                    ? announcementItems
                    : showAnnouncements
                        ? [const CircularProgressIndicator(color: Colors.black)]
                        : [const SizedBox()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> getAnnouncementWidgets() async {
    List<Widget> items = [];
    for (int i = 0; i < announcements.length; i++) {
      Map<String, String> a = announcements[i];
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
                style: TextStyle(fontFamily: 'DM Sans',
                  color: const Color(0xFF717171),
                  
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
            msgText.add(
              TextSpan(
                text: t,
                style: TextStyle(fontFamily: 'DM Sans',
                  color: const Color.fromARGB(255, 41, 41, 255),
                  
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
                style: TextStyle(fontFamily: 'DM Sans',
                  color: const Color(0xFF717171),
                  
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
            startIndex = a['text']!.indexOf(t, startIndex) + 1;
          }
        }
      }
      String timestamp = a['timestamp']!;

      DateTime d = DateTime.parse(timestamp).toLocal();

      String time = Dates.giveDateTimestamp(d);

      items.add(// Generated code for this Row Widget...
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Container(
                    width: MediaQuery.sizeOf(context).width * 0.35,
                    decoration: BoxDecoration(
                      color: const Color(0x0014181B),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
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
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a['name']!,
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
                                      color: const Color(0xFF323232),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 3, 0, 0),
                                    child: RichText(
                                        text: TextSpan(children: msgText)),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          time,
                                          style: TextStyle(fontFamily: 'DM Sans',
                                            
                                            color: const Color(0xFF0088D4),
                                            fontSize: 12,
                                          ),
                                        ),
                                        a['image'] != ""
                                            ? Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(10, 0, 0, 0),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (await canLaunchUrl(
                                                        Uri.parse(
                                                            a['image']!))) {
                                                      await launchUrl(
                                                          Uri.parse(
                                                              a['image']!),
                                                          mode: LaunchMode
                                                              .externalApplication);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 21,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xBEE6E6E6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              10, 0, 10, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .file_upload_outlined,
                                                            color: Color(
                                                                0xFF616161),
                                                            size: 13,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    4, 0, 0, 0),
                                                            child: Text(
                                                              'Attachment',
                                                              style: TextStyle(fontFamily: 'DM Sans',
                                                                
                                                                color: const Color(
                                                                    0xFF616161),
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
                    )),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: InkWell(
                    onTap: () async {
                      announcements.removeAt(i);
                      announcementItems.removeAt(i);
                      await API().updateAnnouncements(
                          announcements, AppInfo.conference.id);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Color.fromARGB(255, 43, 11, 11),
                          content: Text('Announcement deleted.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFe9e9e9),
                                fontFamily: 'SFPro',
                              ))));
                      setState(() {});
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 234, 39, 39),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE9E9E9),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ])));
      items.add(Row(children: [
        Padding(
            padding: const EdgeInsets.only(left: 50),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * .38,
              child: const Divider(
                height: 30,
                thickness: 2,
                color: Color(0xFFEFEFEF),
              ),
            ))
      ]));
    }
    return items;
  }

  void _sendNotification(String msg, String img, String topic, String title) {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotif');
    callable.call(<String, dynamic>{
      'topic': topic,
      'title': title,
      'body': msg,
      "image": img,
    });
  }

  String formatAnnouncementTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();

    String formattedString = DateFormat('M/d, h:mma').format(dateTime);

    return formattedString;
  }

  Future<void> _pickImage() async {
    setState(() {
      uploading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      type: FileType.custom,
    );

    if (result != null) {
      if (kIsWeb) {
        Uint8List bytes = result.files.first.bytes!;
        String fileExtension = result.files.first.extension!;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        fileName += ".$fileExtension";

        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putData(bytes);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrl += ".$fileExtension";

        file = imageUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('File Uploaded!',
                style: TextStyle(fontFamily: 'DM Sans',
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  
                ))));

        setState(() {
          uploading = false;
        });
      }
    }
  }
}
