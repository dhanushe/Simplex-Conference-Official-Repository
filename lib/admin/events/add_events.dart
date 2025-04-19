// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state, must_be_immutable

import 'dart:math';
import 'dart:developer' as dv;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_excel/excel.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import '../../api/objects/event_data.dart';

class AddEventsAdmin extends StatefulWidget {
  const AddEventsAdmin({
    super.key,
  });

  @override
  State<AddEventsAdmin> createState() => _AddEventsAdminState();
}

class _AddEventsAdminState extends State<AddEventsAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<EventData> events = [];

  _AddEventsAdminState() {
    API().getAllEvents(AppInfo.conference.id).then((value) {
      events = value;
      events.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        dataLoaded = true;
      });
    });
  }

  bool loadingEvents = false;
  bool excludeFinal = true;
  bool showAnnouncements = false;
  bool dataLoaded = false;
  bool deletingData = false;
  String search = "";
  int eventIndex = -1;
  late Map<String, String> selectedCompetitor;
  TextEditingController? text;
  String eventName = "";
  String eventDate = "";
  bool eventIsOpen = false;

  FocusNode? f;

  @override
  void initState() {
    text = TextEditingController();
    f = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    f!.dispose();
    text!.dispose();
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
            Material(
              elevation: 1,
              child: Container(
                width: MediaQuery.of(context).size.width / 5 * 4,
                color: Colors.white,
                child: const Column(
                  children: [
                    Row(mainAxisSize: MainAxisSize.max, children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25, 40, 0, 40),
                          child: Text(
                            'Modify Events',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // create a bunch of space to move the other buttons all the way to the end
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.white,
                        elevation: 0.5,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width:
                                        MediaQuery.sizeOf(context).width * .18),
                              const Text('Edit Info',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 15),
                              InkWell(
                                onTap: () async {
                                  await launchUrl(Uri.parse(
                                      'https://docs.google.com/document/d/1SX36Oui-mFzDXoU47wSq-hc8K_oETqov0omeHhLk3vU/edit#bookmark=id.8ouigf96e2ca'));
                                },
                                child: Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0x0026292D),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Open Instructions',
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 0, 0),
                                        child: Icon(
                                          Icons.open_in_new,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    !loadingEvents
                                        ? InkWell(
                                            onTap: () async {
                                              setState(() {
                                                loadingEvents = true;
                                              });
                                              try {
                                                await _uploadSpreadsheet(
                                                    context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255, 11, 43, 31),
                                                        content: Text(
                                                            'Events Uploaded!',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'DM Sans',
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFFe9e9e9),
                                                            ))));
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255, 43, 11, 11),
                                                        content: Text(
                                                            'Error in uploading events. Please try again later.',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'DM Sans',
                                                              fontSize: 16,
                                                              color: const Color(
                                                                  0xFFe9e9e9),
                                                            ))));
                                              }
                                            },
                                            child: Container(
                                              width: 180,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0x0026292D),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 8, 0),
                                                    child: Icon(
                                                      Icons.file_upload_outlined,
                                                      color: Color(0xFF000000),
                                                      size: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Upload Spreadsheet',
                                                    style: TextStyle(
                                                      fontFamily: 'DM Sans',
                                                      color: const Color(
                                                          0xFF000000),
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        : const CircularProgressIndicator(
                                            color: Colors.black),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: !deletingData
                                    ? InkWell(
                                        onTap: () async {
                                          setState(() {
                                            deletingData = true;
                                          });
                                          try {
                                            await deleteData();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 43, 11, 11),
                                                    content: Text(
                                                        'Events removed.',
                                                        style: TextStyle(
                                                          fontFamily: 'DM Sans',
                                                          fontSize: 16,
                                                          color: const Color(
                                                              0xFFe9e9e9),
                                                        ))));
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 43, 11, 11),
                                                    content: Text(
                                                        'Error in performing action. Please try again later.',
                                                        style: TextStyle(
                                                          fontFamily: 'DM Sans',
                                                          fontSize: 16,
                                                          color: const Color(
                                                              0xFFe9e9e9),
                                                        ))));
                                          }
                                        },
                                        child: Container(
                                          width: 180,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 146, 161),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 8, 0),
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  color: Color(0xFF000000),
                                                  size: 15,
                                                ),
                                              ),
                                              Text(
                                                'Remove All Events',
                                                style: TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  color:
                                                      const Color(0xFF000000),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.black)),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 15, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Uploading Final Schedule?',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Switch(
                                      // This bool value toggles the switch.
                                      value: !excludeFinal,
                                      activeColor: Colors.green,
                                      onChanged: (bool value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          excludeFinal = !value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                       eventIndex != -1 ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        25, 20, 25, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: Colors.white,
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20, 20, 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * .22),
                                const Text(
                                  'Edit Selected Event',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // Event Name
                                const Text(
                                  'Event Name',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: eventName),
                                    onChanged: (value) {
                                     eventName = value;
                                     setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(
                                              20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Event Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // Event Date
                                const Text(
                                  'Event Date',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: eventDate),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(
                                              20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      suffix: TextButton(
                                        child: const Text(
                                          'Select Date',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.parse(
                                              eventDate),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2031),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              eventDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                               
                               
                                const SizedBox(height: 6),
                                
                               
                                // Event Open Status
                                const Text(
                                  'Is Event Open?',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButton<bool>(
                                  value:eventIsOpen,
                                  items: const [
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text('Open'),
                                    ),
                                    DropdownMenuItem(
                                      value: false,
                                      child: Text('Closed'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      eventIsOpen = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Save/Discard Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          // Reset changes
                                          eventIndex = -1;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 243, 237, 254),
                                      ),
                                      child: const Text(
                                        'Discard Changes',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 57, 237),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () async {
                                        // Save changes to the database

                                        events[eventIndex] = EventData(
                                            id: events[eventIndex].id,
                                            name: eventName,
                                            color: events[eventIndex].color
                                                .toString(),
                                            competitors:
                                                events[eventIndex].competitors,
                                            date: eventDate,
                                            times: events[eventIndex].times,
                                            type: events[eventIndex].type,
                                            round: events[eventIndex].round,
                                            isLate: events[eventIndex].isLate,
                                            isOpen: eventIsOpen,
                                          );
                                         API()
                                            .updateEvent(events[eventIndex], AppInfo.conference.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Changes Saved!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        eventIndex = -1;
                                        setState(() {});

                                        _sendNotification("Your event ${events[eventIndex].name} has been updated.", "", events[eventIndex].id, AppInfo.conference.name);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 115, 57, 237),
                                      ),
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(color: Colors.white),
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
                  ) : SizedBox(),
                    ],
                  ),
                  SizedBox(width: 15),
                  Column(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.white,
                        elevation: 0.5,
                        child: Container(
                            height: MediaQuery.sizeOf(context).height - 80,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 20, 20, 30.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.sizeOf(context)
                                                  .width *
                                              .22),
                                      const Text('Events',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      const Text('(may have to reload)',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black)),
                                      const SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 123, 4, 4),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 123, 4, 4),
                                                  width: 2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.timer_outlined,
                                              color: Color(0xFFE9E9E9),
                                              size: 22,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          const Text(
                                              'means an event is running late!',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color.fromARGB(
                                                      255, 123, 4, 4)))
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Padding(
                                        padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 0, 5),
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
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          height: 44,
                                          width: MediaQuery.sizeOf(context)
                                                  .width *
                                              0.2,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
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
                                              enabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x5BE0E0E0),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF226ADD),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                      20, 6, 0, 6),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: f!.hasFocus ||
                                                        f!.hasPrimaryFocus
                                                    ? const Color(0xFF226ADD)
                                                    : text!.text == ""
                                                        ? const Color(
                                                            0xFFAEAEAE)
                                                        : const Color(
                                                            0xFF585858),
                                                size: 20,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'DM Sans',
                                              color: f!.hasFocus ||
                                                      f!.hasPrimaryFocus
                                                  ? const Color(0xFF226ADD)
                                                  : const Color(0xFF585858),
                                              fontSize: 13,
                                            ),
                                            minLines: null,
                                          ),
                                        ),
                                      ),
                                      dataLoaded
                                          ? SingleChildScrollView(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children:
                                                      getEventWidgets()))
                                          : const CircularProgressIndicator(
                                              color: Color(0xFF000000))
                                    ]))),
                      )
                    ],
                  ),
                  SizedBox(width: 15),

                   eventIndex != -1 ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        25, 20, 25, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                   
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: Colors.white,
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20, 20, 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * .22),
                                const Text(
                                  'Edit Competitors',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),])))])) : SizedBox(),
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getEventWidgets() {
    List<Widget> items = [];
    for (int i = 0; i < events.length; i++) {
      if (search != "" &&
          !events[i].name.toLowerCase().contains(search.toLowerCase())) {
        continue;
      }
      items.add(// Generated code for this Row Widget...
          Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () {
                if (eventIndex == i) {
                  eventIndex = -1;
                } else {
                  eventIndex = i;
                  eventName = events[i].name;
                  eventDate = events[i].date;
                  eventIsOpen = events[i].isOpen;
              
                }
                setState(() {
                  
                });
              },
              child:
            Container(
              width: MediaQuery.sizeOf(context).width * .15,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFf9f9f9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: eventIndex == i ? Color(0xFF7339ED) :const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: AutoSizeText(
                    events[i].name,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: InkWell(
                onTap: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this event?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete) {
                    await API().deleteEvent(
                        AppInfo.conference.id, events[i].id);
                    eventIndex = -1;
                    events.removeAt(i);
                    setState(() {});
                  }
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: InkWell(
                onTap: () async {
                  events[i].isLate = !events[i].isLate;
                  await API()
                      .updateLateEvent(events[i], AppInfo.conference.id);
                  if (events[i].isLate) {
                    _sendNotification(
                        "Your event ${events[i].name} has been marked as running late and times shown may not be accurate.",
                        "",
                        events[i].id,
                        AppInfo.conference.name);
                  }

                  setState(() {});
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: events[i].isLate
                        ? Color.fromARGB(255, 123, 4, 4)
                        : Color(0xFFE9e9e9),
                    border: Border.all(
                        color: Color.fromARGB(255, 123, 4, 4), width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: events[i].isLate
                        ? Color(0xFFE9E9E9)
                        : Color(0xFF000000),
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return items;
  }

  Future<void> _uploadSpreadsheet(BuildContext context) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked
    bool gotEvents = false;
    List<Map<String, dynamic>> events = [];

    if (pickedFile != null) {
      // try {

      var bytes = pickedFile.files.single.bytes!.toList();
      var excel = Excel.decodeBytes(bytes);
      String lastName = "";
      String times = "";
      String endTime = "";
      int lastIndex = -1;

      bool prelimExists = false;
      var table = excel.tables.keys.first;
      for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
        var row = excel.tables[table]!.rows[i];

        if (row[17] == null ||
            row[17]?.value == null ||
            (row[2]?.value == "Final" &&
                excludeFinal &&
                prelimExists &&
                row[1]?.value.toString() == lastName)) {
          continue;
        } else if (row[2]?.value != 'Final' && !excludeFinal) {
          continue;
        }

        if (row[13]?.value.toString() != "true" &&
            row[17]?.value.toString() != "") {
          if (row[1]?.value.toString() != lastName) {
            if (lastIndex != -1) {
              times += ' - $endTime';
              events[lastIndex]['times'] = times;
            }
            lastName = row[1]!.value.toString();
            String date = row[3]!.value.toString();
            DateTime inputDate;
            if (date.contains("T")) {
              date = date.substring(0, date.indexOf("T"));
              inputDate = DateFormat('yyyy-MM-dd').parse(date);
            } else if (int.tryParse(row[3]!.value.toString()) != null) {
              inputDate = DateTime.fromMillisecondsSinceEpoch(
                  int.tryParse(row[3]!.value.toString())! *
                      24 *
                      60 *
                      60 *
                      1000);
            } else {
              inputDate = DateFormat('M/d/yyyy').parse(date);
            }
            String outputDateString =
                DateFormat('yyyy-MM-dd').format(inputDate);

            times = row[0]?.value.toString() == "Case" ||
                    row[0]!.value.toString().contains("RP")
                ? row[15]!.value.toString().toLowerCase().replaceAll(' ', '')
                : row[17]!.value.toString().toLowerCase().replaceAll(' ', '');
            endTime = getEndTime(times);

            // Format the DateTime object into the desired format

            String location = row[4]!.value.toString();
            if (int.tryParse(location) != null) {
              location = "Room $location";
            }
            String location2 = "";
            if (row[5] != null) {
              location2 = row[5]!.value.toString();
              if (int.tryParse(location2) != null) {
                location2 = "Room $location2";
              }
            }
            String round = row[2]!.value.toString().contains("Prelim")
                ? 'Preliminary Round'
                : "Final Round";
            prelimExists = round == "Preliminary Round";
            String extra =
                row[10]!.value.toString().replaceAll('High School', 'HS');
            extra += ";$location";
            if (row[0]!.value.toString() == "Case" ||
                row[0]!.value.toString().replaceAll(' ', '') == "RP") {
              extra +=
                  ';${row[17]!.value.toString().toLowerCase().replaceAll(' ', '')}';
              extra += ";$location2";
            }

            String time = row[0]!.value.toString() == "Case" ||
                    row[0]!.value.toString().replaceAll(' ', '') == "RP"
                ? row[15]!.value.toString().toLowerCase().replaceAll(' ', '')
                : row[17]!.value.toString().toLowerCase().replaceAll(' ', '');
            String r = row[2]!.value.toString();

            String extraChar = r.contains('Prelim') ? r[r.length - 1] : 'F';

            List<String> tokens =
                parseNames(row[12]!.value.toString()) + [extra];
            dv.log(row[18]!.value.toString());
            dv.log(row[19]!.value.toString());
            events.add({
              'name': row[1]!.value.toString(),
              'type': row[0]!.value.toString(),
              'round': round.contains("Prelim")
                  ? 'Preliminary Round'
                  : "Final Round",
              'location': location,
              'prepLocation': location2,
              'date': outputDateString,
              'color': getRandomColor(),
              'competitors': {'$time $extraChar': tokens},
              'isOpen': row[19] != null &&
                  row[19]?.value.toString().toLowerCase() == "true",
              'isLate': false,
            });
            lastIndex++;
          } else {
            String location = row[4]!.value.toString();
            if (int.tryParse(location) != null) {
              location = "Room $location";
            }
            String location2 = "";
            if (row[5] != null) {
              location2 = row[5]!.value.toString();
              if (int.tryParse(location2) != null) {
                location2 = "Room $location2";
              }
            }
            String extra =
                row[10]!.value.toString().replaceAll('High School', 'HS');
            extra += ";$location";
            if (row[0]!.value.toString() == "Case" ||
                row[0]!.value.toString().replaceAll(' ', '') == "RP") {
              extra +=
                  ';${row[17]!.value.toString().toLowerCase().replaceAll(' ', '')}';
              extra += ";$location2";
            }

            String time = row[0]!.value.toString() == "Case" ||
                    row[0]!.value.toString().replaceAll(' ', '') == "RP"
                ? row[15]!.value.toString().toLowerCase().replaceAll(' ', '')
                : row[17]!.value.toString().toLowerCase().replaceAll(' ', '');
            String r = row[2]!.value.toString();

            String extraChar = r.contains('Prelim') ? r[r.length - 1] : 'F';

            List<String> tokens =
                parseNames(row[12]!.value.toString()) + [extra];
            events[lastIndex]['competitors']['$time $extraChar'] = tokens;
          }
        }
      }
      times += ' - $endTime';
      events[events.length - 1]['times'] = times;

      gotEvents = true;
      // } catch (e) {
      //   dev.log(e.toString());
      //   setState(() {
      //     loadingEvents = false;
      //   });
      // }
    }

    if (gotEvents) {
      await uploadData(events);
    }

    setState(() {
      loadingEvents = false;
    });
  }

  bool isFirstAfterSecond(String time1, String time2) {
    // Convert time strings to DateTime objects
    DateTime dateTime1 = parseTimeString(time1);
    DateTime dateTime2 = parseTimeString(time2);

    // Compare DateTime objects
    return dateTime1.isAfter(dateTime2);
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

  Future<void> uploadData(List<Map<dynamic, dynamic>> dataList) async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('events');
    // await collection.get().then((querySnapshot) {
    //   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    //     doc.reference.delete();
    //   }
    // });
    for (Map<dynamic, dynamic> dataMap in dataList) {
      await collection.add(dataMap);
    }
  }

  Future<void> deleteData() async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('events');
    await collection.get().then((querySnapshot) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    CollectionReference conferencesCollection =
        FirebaseFirestore.instance.collection('conferences');

    // Get reference to the specific conference document
    DocumentReference conferenceDoc =
        conferencesCollection.doc(AppInfo.conference.id);

    // Get reference to the "users" collection inside the conference document
    CollectionReference usersCollection = conferenceDoc.collection('users');

    // Get all documents in the "users" collection
    QuerySnapshot usersSnapshot = await usersCollection.get();

    // Update each user document
    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Get reference to the user document
      DocumentReference userRef = usersCollection.doc(userDoc.id);

      // Update the "events" field to an empty map
      await userRef.update({'events': []});
    }
    setState(() {
      deletingData = false;
    });
  }

  List<String> parseNames(String input) {
    List<String> namesList = [];

    // Split the input string by semicolon to get individual name pairs
    List<String> namePairs = input.split(';');

    for (String namePair in namePairs) {
      // Trim any leading or trailing spaces
      String trimmedNamePair = namePair.trim();

      // Split each name pair into Last Name and First Name
      List<String> nameParts = trimmedNamePair.split(',');

      if (nameParts.length == 2) {
        // Extract First Name and Last Name and format the name
        String firstName = nameParts[1].trim();
        String lastName = nameParts[0].trim();
        String formattedName = '$firstName $lastName';

        // Add the formatted name to the list
        namesList.add(formattedName);
      }
    }
    namesList.sort();

    return namesList;
  }

  String getRandomColor() {
    List<String> strings = [
      '0x8944C309',
      '0x8DBB0B0B',
      '0x0044C309',
      '0x98E9BF02',
      '0x9AB03DFF'
    ];
    Random random = Random();

    // Generate a random index within the range of the list
    int randomIndex = random.nextInt(strings.length);

    // Return the randomly selected string
    return strings[randomIndex];
  }

  String getEndTime(String inputTime) {
    // Parse the input time string
    DateTime parsedTime = parseTimeString(inputTime);

    // Subtract 20 minutes
    DateTime resultTime = parsedTime.add(const Duration(minutes: 20));

    // Convert to 12-hour format
    int hour12 = resultTime.hour > 12 ? resultTime.hour - 12 : resultTime.hour;
    if (hour12 == 0) {
      // Midnight (00:xx) should be represented as 12:xx AM
      hour12 = 12;
    }

    // Format the result time as a string
    String formattedResult =
        "$hour12:${resultTime.minute.toString().padLeft(2, '0')}";

    // Determine if it's AM or PM
    String amPm = resultTime.hour < 12 ? "am" : "pm";

    // Return the formatted result
    return "$formattedResult$amPm";
  }

  DateTime parseTimeString(String timeString) {
    // Parse the time string to a DateTime object with the current date
    DateTime currentDate = DateTime.now().toLocal();

    // Parse the timeString without the am/pm part
    DateTime targetTime = DateFormat('h:mm').parse(timeString);

    // Add am/pm part to targetTime based on currentDate
    targetTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      targetTime.hour +
          (timeString.contains('pm') && targetTime.hour < 12 ? 12 : 0),
      targetTime.minute,
    );

    return targetTime;
  }
}
