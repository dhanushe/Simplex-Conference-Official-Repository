// ignore_for_file: use_build_context_synchronously, must_be_immutable, no_logic_in_create_state

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:file_picker/file_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';

class ConferenceSettingsPage extends StatefulWidget {
  void Function(int) updateIndex;
  ConferenceSettingsPage({super.key, required this.updateIndex});

  @override
  State<ConferenceSettingsPage> createState() =>
      _ConferenceSettingsPageState(updateIndex: updateIndex);
}

class _ConferenceSettingsPageState extends State<ConferenceSettingsPage> {
  void Function(int)
      updateIndex; // hacky way to have refresh occur immediately after saving
  _ConferenceSettingsPageState({required this.updateIndex});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? _nameController;
  TextEditingController? _descriptionController;
  TextEditingController? _locationController;
  TextEditingController? _helpLinkController;
  TextEditingController? _startDateController;
  TextEditingController? _endDateController;
  TextEditingController? _passwordController;
  TextEditingController? _codeController;

  String name = AppInfo.conference.name;
  String shortDesc = AppInfo.conference.desc;
  String location = AppInfo.conference.location;
  String startDate = AppInfo.conference.startDate;
  String endDate = AppInfo.conference.endDate;
  String logo = AppInfo.conference.logo;
  String help = AppInfo.conference.helpLink;
  String password = AppInfo.conference.password;
  String specificLoc = AppInfo.conference.specificLoc;
  String code = AppInfo.conference.code;
  String homeBg = AppInfo.conference.homeBg;
  bool isSaving = false;
  bool uploadingImage = false;

  @override
  void initState() {
    super.initState();

    // date formatting shenanigans

    _nameController = TextEditingController(text: name);
    _descriptionController = TextEditingController(text: shortDesc);
    _startDateController = TextEditingController(text: prettifyDate(startDate));
    _endDateController = TextEditingController(text: prettifyDate(endDate));
    _locationController = TextEditingController(text: location);
    _helpLinkController = TextEditingController(text: help);
    _passwordController = TextEditingController(text: password);
    _codeController = TextEditingController(text: code);
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _descriptionController?.dispose();
    // text3?.dispose();
    _locationController?.dispose();
    _helpLinkController?.dispose();
    _passwordController?.dispose();
    _codeController?.dispose();
    super.dispose();
  }

  // takes a String rep of date in the form yyyy-MM-dd
  // and turns it into MMMM dd, yyyy
  // Ex: 2024-04-13 -> April 13, 2024
  String prettifyDate(String original) {
    return DateFormat.yMMMMd('en_US')
        .format(DateFormat('yyyy-MM-dd').parse(original));
  }

  String reversePrettifyDate(String pretty) {
    return DateFormat('yyyy-MM-dd')
        .format(DateFormat.yMMMMd('en_US').parse(pretty));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 1,
          child: Container(
            width: MediaQuery.of(context).size.width / 5 * 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(50, 40, 0, 40),
                        child: Text(
                          'Conference Settings',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // create a bunch of space to move the other buttons all the way to the end
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5 * 2,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () => discard(),
                          style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              foregroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 115, 57, 237)),
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 243, 237, 254))),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Discard Changes',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: !isSaving
                          ? TextButton(
                              onPressed: () => save(),
                              style: ButtonStyle(
                                  shape: const MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  overlayColor:
                                      // only show lighter color if hovered
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                            .contains(MaterialState.hovered) &&
                                        !states
                                            .contains(MaterialState.focused) &&
                                        !states
                                            .contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(
                                          255, 138, 91, 240);
                                      // this is a hacky way to accomplish the ink effect
                                    } else if (states
                                        .contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(
                                          255, 94, 28, 236);
                                    } else {
                                      return null;
                                    }
                                  }),
                                  foregroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.white),
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Color.fromARGB(255, 115, 57, 237))),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
                                ),
                              ))
                          : const CircularProgressIndicator(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(55.0, 40, 40, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Name',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          SizedBox(
                            // height: 50,
                            width: 280,
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                  border: MaterialStateOutlineInputBorder
                                      .resolveWith((states) {
                                    return OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.grey.shade300));
                                  }),
                                  hintText: 'Enter a Name',
                                  helperMaxLines: 10,
                                  helperStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15),
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w200)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'IMPORTANT NOTE',
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 57, 237),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                              'Changing this field will also change the\nusername of the account')
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Description',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: 280,
                            child: TextField(
                              // expands: true,
                              minLines: 2,
                              maxLines: 2,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                  // helperMaxLines: 2,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 15, 5, 10),
                                  border: MaterialStateOutlineInputBorder
                                      .resolveWith((states) {
                                    return OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.grey.shade300));
                                  }),
                                  hintText: 'Enter a Description',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w200)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 500,
                      width: 320,
                      child: Material(
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
                              const Text('General Location',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              const Text(
                                  'Put general locations like city and state'),
                              const SizedBox(height: 15),
                              SizedBox(
                                // height: 50,
                                width: 280,
                                child: TextField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 5, 10),
                                      border: MaterialStateOutlineInputBorder
                                          .resolveWith((states) {
                                        return OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.grey.shade300));
                                      }),
                                      hintText: 'Enter a Location',
                                      helperMaxLines: 10,
                                      helperStyle: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15),
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.w200)),
                                ),
                              ),
                              SizedBox(height: 15),
                              const Text('Specific Location',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              const Text(
                                  'Put specific address for something like a conference center'),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                child: const Text('Pick location'),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MapLocationPicker(
                                          apiKey:
                                              "AIzaSyDGtvdkDK3mHBoAIdYeoMwfLU9GU-XF3pM",
                                          popOnNextButtonTaped: true,
                                          onNext: (GeocodingResult? result) {
                                            if (result != null) {
                                              setState(() {
                                                specificLoc =
                                                    result.formattedAddress ??
                                                        "";
                                              });
                                            }
                                          },
                                          onSuggestionSelected:
                                              (PlacesDetailsResponse? result) {
                                            if (result != null) {
                                              setState(() {
                                                specificLoc = result.result
                                                        .formattedAddress ??
                                                    "";
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 15),
                              Container(
                                width: 280,
                                constraints: BoxConstraints(maxHeight: 150),
                                child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(specificLoc == ""
                                            ? "None"
                                            : specificLoc)
                                      ],
                                    )),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  SizedBox(
                    width:
                        320, // get box to conform with the size of the other boxes
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.white,
                      elevation: 0.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Conference Dates',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 20),
                            const Text(
                              'Start Date',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(78, 63, 115, 1)),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                                width: 280,
                                child: TextField(
                                  readOnly: true,
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 5, 10),
                                      border: MaterialStateOutlineInputBorder
                                          .resolveWith((states) {
                                        return OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.grey.shade300));
                                      }),
                                      suffix: TextButton(
                                        child: const Text('Select New',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 115, 57, 237),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () async {
                                          DateTime dateTime = DateTime.parse(
                                              reversePrettifyDate(
                                                  _startDateController!.text));
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle:
                                                                const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            115,
                                                                            57,
                                                                            237)), // button text color
                                                          ),
                                                        ),
                                                        colorScheme:
                                                            const ColorScheme
                                                                .dark(
                                                          primary: Color.fromARGB(
                                                              255,
                                                              115,
                                                              57,
                                                              237), // color of calendar background and highlight text
                                                          onPrimary: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255), // color of the circle current selected
                                                          onSurface: // color of the dates
                                                              Color.fromARGB(
                                                                  255, 0, 0, 0),
                                                          surface: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255), // color of the calendar background
                                                        ).copyWith(
                                                                background:
                                                                    Colors
                                                                        .black),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                  initialDate: dateTime,
                                                  firstDate: DateTime(2024),
                                                  lastDate: DateTime(2031));
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);

                                            setState(() {
                                              _startDateController!.text =
                                                  prettifyDate(formattedDate);
                                            });
                                          }
                                        },
                                      )),
                                )),
                            const SizedBox(height: 15),
                            const Text(
                              'End Date',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(78, 63, 115, 1)),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                                width: 280,
                                child: TextField(
                                  readOnly: true,
                                  controller: _endDateController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 10, 5, 10),
                                      border: MaterialStateOutlineInputBorder
                                          .resolveWith((states) {
                                        return OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.grey.shade300));
                                      }),
                                      suffix: TextButton(
                                        child: const Text('Select New',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 115, 57, 237),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () async {
                                          DateTime dateTime = DateTime.parse(
                                              reversePrettifyDate(
                                                  _endDateController!.text));
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: ThemeData(
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle:
                                                                const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            115,
                                                                            57,
                                                                            237)), // button text color
                                                          ),
                                                        ),
                                                        colorScheme:
                                                            const ColorScheme
                                                                .dark(
                                                          primary: Color.fromARGB(
                                                              255,
                                                              115,
                                                              57,
                                                              237), // color of calendar background and highlight text
                                                          onPrimary: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255), // color of the circle current selected
                                                          onSurface: // color of the dates
                                                              Color.fromARGB(
                                                                  255, 0, 0, 0),
                                                          surface: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255), // color of the calendar background
                                                        ).copyWith(
                                                                background:
                                                                    Colors
                                                                        .black),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                  initialDate: dateTime,
                                                  firstDate: DateTime(2024),
                                                  lastDate: DateTime(2031));
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);

                                            setState(() {
                                              _endDateController!.text =
                                                  prettifyDate(formattedDate);
                                            });
                                          }
                                        },
                                      )),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Password',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          SizedBox(
                            // height: 50,
                            width: 280,
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                  border: MaterialStateOutlineInputBorder
                                      .resolveWith((states) {
                                    return OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.grey.shade300));
                                  }),
                                  hintText: 'Enter a Password',
                                  helperMaxLines: 10,
                                  helperStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15),
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w200)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'IMPORTANT NOTE',
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 57, 237),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                              'Changing this field will change the\npassword of the account')
                        ],
                      ),
                    ),
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Code',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          SizedBox(
                            // height: 50,
                            width: 280,
                            child: TextField(
                              controller: _codeController,
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                  border: MaterialStateOutlineInputBorder
                                      .resolveWith((states) {
                                    return OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.grey.shade300));
                                  }),
                                  hintText: 'Enter a Code',
                                  helperMaxLines: 10,
                                  helperStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15),
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w200)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'IMPORTANT NOTE',
                            style: TextStyle(
                                color: Color.fromARGB(255, 115, 57, 237),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                              'Changing this field will change the\ncode users use to sign into your conference')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Logo',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      color: Colors.black,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child:
                                              Image.network(logo, height: 40)))
                                ]),
                          ),
                          const SizedBox(height: 15),
                          !uploadingImage
                              ? Container(
                                  height: 80,
                                  color: Colors.white,
                                  width: 280,
                                  child: InkWell(
                                    onTap: () async {
                                      await _pickImage();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 10, 15, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: const Color(0xff000000),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              : Container(
                                  height: 80,
                                  color: Colors.white,
                                  width: 280,
                                  child: const Column(children: [
                                    CircularProgressIndicator(
                                        color: Colors.black)
                                  ])),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.white,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conference Background',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    height: 135,
                                    child: Stack(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 135,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Opacity(
                                          opacity: 0.2,
                                          child: Container(
                                            width: 200,
                                            height: 135,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        homeBg),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 15),
                          !uploadingImage
                              ? Container(
                                  height: 80,
                                  color: Colors.white,
                                  width: 280,
                                  child: InkWell(
                                    onTap: () async {
                                      await _pickImage2();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              15, 10, 15, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            style: GoogleFonts.getFont(
                                              'Poppins',
                                              color: const Color(0xff000000),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              : Container(
                                  height: 80,
                                  color: Colors.white,
                                  width: 280,
                                  child: const Column(children: [
                                    CircularProgressIndicator(
                                        color: Colors.black)
                                  ])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
    //         const Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 'Conference Logo',
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'Poppins',
    //                   fontSize: 18,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             children: [
    //               Container(
    //                 width: 400,
    //                 height: 80,
    //                 decoration: BoxDecoration(
    //                   color: const Color(0xFF26292D),
    //                   borderRadius: BorderRadius.circular(8),
    //                   border: Border.all(
    //                     color: const Color(0xFF3E3E3E),
    //                     width: 2,
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding:
    //                       const EdgeInsetsDirectional.fromSTEB(25, 0, 10, 0),
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       ClipRRect(
    //                         borderRadius: BorderRadius.circular(8),
    //                         child: Image.network(
    //                           logo,
    //                           width: 100,
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                       !uploadingImage
    //                           ? InkWell(
    //                               onTap: () async {
    //                                 await _pickImage();
    //                               },
    //                               child: const Padding(
    //                                 padding: EdgeInsetsDirectional.fromSTEB(
    //                                     15, 10, 15, 10),
    //                                 child: Row(
    //                                   mainAxisSize: MainAxisSize.max,
    //                                   mainAxisAlignment: MainAxisAlignment.end,
    //                                   children: [
    //                                     Padding(
    //                                       padding:
    //                                           EdgeInsetsDirectional.fromSTEB(
    //                                               0, 0, 6, 0),
    //                                       child: Icon(
    //                                         Icons.file_upload_outlined,
    //                                         color: Color(0xFFE9E9E9),
    //                                         size: 28,
    //                                       ),
    //                                     ),
    //                                     Text(
    //                                       'Upload New',
    //                                       style: TextStyle(
    //                                         fontFamily: 'Poppins',
    //                                         color: Color(0xFFE9E9E9),
    //                                         fontSize: 18,
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             )
    //                           : const CircularProgressIndicator(
    //                               color: Colors.white),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 'Location',
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'Poppins',
    //                   fontSize: 18,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Flexible(
    //                 child: SizedBox(
    //                   width: MediaQuery.sizeOf(context).width * 0.25,
    //                   child: TextFormField(
    //                     controller: text4,
    //                     onChanged: (value) {
    //                       location = value;
    //                     },
    //                     obscureText: false,
    //                     decoration: InputDecoration(
    //                       hintText: 'Put location here...',
    //                       hintStyle: const TextStyle(
    //                         fontFamily: 'Poppins',
    //                         color: Color(0xFFE9E9E9),
    //                         fontSize: 14,
    //                       ),
    //                       enabledBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       focusedBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       errorBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       focusedErrorBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       filled: true,
    //                       fillColor: const Color(0xFF26292D),
    //                       contentPadding: const EdgeInsetsDirectional.fromSTEB(
    //                           25, 15, 25, 15),
    //                     ),
    //                     style: const TextStyle(
    //                       fontFamily: 'Poppins',
    //                       color: Color(0xFFE9E9E9),
    //                       fontSize: 14,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 'Help Desk Link',
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'Poppins',
    //                   fontSize: 18,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Flexible(
    //                 child: SizedBox(
    //                   width: MediaQuery.sizeOf(context).width * 0.25,
    //                   child: TextFormField(
    //                     controller: text5,
    //                     onChanged: (value) {
    //                       help = value;
    //                     },
    //                     obscureText: false,
    //                     decoration: InputDecoration(
    //                       hintText: 'Put link here...',
    //                       hintStyle: const TextStyle(
    //                         fontFamily: 'Poppins',
    //                         color: Color(0xFFE9E9E9),
    //                         fontSize: 14,
    //                       ),
    //                       enabledBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       focusedBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       errorBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       focusedErrorBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                           color: Color(0xFF3E3E3E),
    //                           width: 2,
    //                         ),
    //                         borderRadius: BorderRadius.circular(8),
    //                       ),
    //                       filled: true,
    //                       fillColor: const Color(0xFF26292D),
    //                       contentPadding: const EdgeInsetsDirectional.fromSTEB(
    //                           25, 15, 25, 15),
    //                     ),
    //                     style: const TextStyle(
    //                       fontFamily: 'Poppins',
    //                       color: Color(0xFFE9E9E9),
    //                       fontSize: 14,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Padding(
    //           padding: EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(
    //                 'Start Date',
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'Poppins',
    //                   fontSize: 18,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: EdgeInsetsDirectional.fromSTEB(0, 0, 408, 0),
    //                 child: Text(
    //                   'End Date',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontFamily: 'Poppins',
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.max,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Container(
    //                 width: 400,
    //                 height: 62,
    //                 decoration: BoxDecoration(
    //                   color: const Color(0xFF26292D),
    //                   borderRadius: BorderRadius.circular(8),
    //                   border: Border.all(
    //                     color: const Color(0xFF3E3E3E),
    //                     width: 2,
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding:
    //                       const EdgeInsetsDirectional.fromSTEB(25, 0, 10, 0),
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         formatDate(startDate),
    //                         style: const TextStyle(
    //                           fontFamily: 'Poppins',
    //                           color: Color(0xFFE9E9E9),
    //                           fontSize: 14,
    //                         ),
    //                       ),
    //                       InkWell(
    //                         onTap: () async {
    //                           DateTime dateTime = DateTime.parse(startDate);
    //                           DateTime? pickedDate = await showDatePicker(
    //                               context: context,
    //                               builder: (context, child) {
    //                                 return Theme(
    //                                   data: ThemeData(
    //                                     textButtonTheme: TextButtonThemeData(
    //                                       style: TextButton.styleFrom(
    //                                         textStyle: const TextStyle(
    //                                           color: Color.fromARGB(
    //                                               255, 255, 255, 255),
    //                                         ), // button text color
    //                                       ),
    //                                     ),
    //                                     colorScheme: const ColorScheme.dark(
    //                                       primary:
    //                                           Color(0xFF1b1d21), // <-- SEE HERE
    //                                       onPrimary: Color.fromARGB(255, 255,
    //                                           255, 255), // <-- SEE HERE
    //                                       onSurface: Colors.white,
    //                                       surface: Colors.black,
    //                                     ).copyWith(background: Colors.black),
    //                                   ),
    //                                   child: child!,
    //                                 );
    //                               },
    //                               initialDate: dateTime,
    //                               firstDate: DateTime(2024),
    //                               lastDate: DateTime(2031));
    //                           if (pickedDate != null) {
    //                             String formattedDate =
    //                                 DateFormat('yyyy-MM-dd').format(pickedDate);

    //                             setState(() {
    //                               startDate = formattedDate;
    //                             });
    //                           }
    //                         },
    //                         child: const Padding(
    //                           padding: EdgeInsetsDirectional.fromSTEB(
    //                               15, 10, 15, 10),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.max,
    //                             mainAxisAlignment: MainAxisAlignment.end,
    //                             children: [
    //                               Padding(
    //                                 padding: EdgeInsetsDirectional.fromSTEB(
    //                                     0, 0, 6, 0),
    //                                 child: Icon(
    //                                   Icons.calendar_today,
    //                                   color: Color(0xFFE9E9E9),
    //                                   size: 24,
    //                                 ),
    //                               ),
    //                               Text(
    //                                 'Select New',
    //                                 style: TextStyle(
    //                                   fontFamily: 'Poppins',
    //                                   color: Color(0xFFE9E9E9),
    //                                   fontSize: 16,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 86, 0),
    //                 child: Container(
    //                   width: 400,
    //                   height: 62,
    //                   decoration: BoxDecoration(
    //                     color: const Color(0xFF26292D),
    //                     borderRadius: BorderRadius.circular(8),
    //                     border: Border.all(
    //                       color: const Color(0xFF3E3E3E),
    //                       width: 2,
    //                     ),
    //                   ),
    //                   child: Padding(
    //                     padding:
    //                         const EdgeInsetsDirectional.fromSTEB(25, 0, 10, 0),
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.max,
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           formatDate(endDate),
    //                           style: const TextStyle(
    //                             fontFamily: 'Poppins',
    //                             color: Color(0xFFE9E9E9),
    //                             fontSize: 14,
    //                           ),
    //                         ),
    //                         InkWell(
    //                           onTap: () async {
    //                             DateTime dateTime = DateTime.parse(endDate);
    //                             DateTime? pickedDate = await showDatePicker(
    //                                 context: context,
    //                                 builder: (context, child) {
    //                                   return Theme(
    //                                     data: ThemeData(
    //                                       textButtonTheme: TextButtonThemeData(
    //                                         style: TextButton.styleFrom(
    //                                           textStyle: const TextStyle(
    //                                             color: Color.fromARGB(
    //                                                 255, 255, 255, 255),
    //                                           ), // button text color
    //                                         ),
    //                                       ),
    //                                       colorScheme: const ColorScheme.dark(
    //                                         primary: Color(
    //                                             0xFF1b1d21), // <-- SEE HERE
    //                                         onPrimary: Color.fromARGB(255, 255,
    //                                             255, 255), // <-- SEE HERE
    //                                         onSurface: Colors.white,
    //                                         surface: Colors.black,
    //                                       ).copyWith(background: Colors.black),
    //                                     ),
    //                                     child: child!,
    //                                   );
    //                                 },
    //                                 initialDate: dateTime,
    //                                 firstDate: DateTime(2024),
    //                                 lastDate: DateTime(2031));
    //                             if (pickedDate != null) {
    //                               String formattedDate =
    //                                   DateFormat('yyyy-MM-dd')
    //                                       .format(pickedDate);

    //                               setState(() {
    //                                 endDate = formattedDate;
    //                               });
    //                             }
    //                           },
    //                           child: const Padding(
    //                             padding: EdgeInsetsDirectional.fromSTEB(
    //                                 15, 10, 15, 10),
    //                             child: Row(
    //                               mainAxisSize: MainAxisSize.max,
    //                               mainAxisAlignment: MainAxisAlignment.end,
    //                               children: [
    //                                 Padding(
    //                                   padding: EdgeInsetsDirectional.fromSTEB(
    //                                       0, 0, 6, 0),
    //                                   child: Icon(
    //                                     Icons.calendar_today,
    //                                     color: Color(0xFFE9E9E9),
    //                                     size: 24,
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   'Select New',
    //                                   style: TextStyle(
    //                                     fontFamily: 'Poppins',
    //                                     color: Color(0xFFE9E9E9),
    //                                     fontSize: 16,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 60),
    //           child: InkWell(
    //             onTap: () async {
    //
    //             },
    //             child: Container(
    //               width: 200,
    //               height: 62,
    //               decoration: BoxDecoration(
    //                 color: const Color(0xFF282A33),
    //                 borderRadius: BorderRadius.circular(10),
    //                 border: Border.all(
    //                   color: const Color(0xFF3E3E3E),
    //                 ),
    //               ),
    //               child: const Align(
    //                 alignment: AlignmentDirectional(0, 0),
    //                 child: Text(
    //                   'Save',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontFamily: 'Poppins',
    //                     fontSize: 20,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Future<void> _pickImage() async {
    setState(() {
      uploadingImage = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      if (kIsWeb) {
        Uint8List bytes = result.files.first.bytes!;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putData(bytes);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        logo = imageUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {
          uploadingImage = false;
        });
      } else {
        File f = File(result.files[0].path!);

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putFile(f);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        logo = imageUrl;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {});
      }
    } else {
      setState(() {
        uploadingImage = false;
      });
    }
  }

  Future<void> _pickImage2() async {
    setState(() {
      uploadingImage = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      if (kIsWeb) {
        Uint8List bytes = result.files.first.bytes!;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putData(bytes);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        homeBg = imageUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {
          uploadingImage = false;
        });
      } else {
        File f = File(result.files[0].path!);

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putFile(f);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        homeBg = imageUrl;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {});
      }
    } else {
      setState(() {
        uploadingImage = false;
      });
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return "th";
      }
      switch (day % 10) {
        case 1:
          return "st";
        case 2:
          return "nd";
        case 3:
          return "rd";
        default:
          return "th";
      }
    }

    String formattedDate = DateFormat("MMMM d, y").format(dateTime);
    int day = dateTime.day;
    String dayWithSuffix = '$day${daySuffix(day)}';

    return formattedDate.replaceFirst(day.toString(), dayWithSuffix);
  }

  bool checkDates(String firstDate, String secondDate) {
    DateTime firstDateTime = DateTime.parse(firstDate);
    DateTime secondDateTime = DateTime.parse(secondDate);

    return secondDateTime
        .subtract(const Duration(days: 1))
        .isBefore(firstDateTime);
  }

  save() async {
    if (!isSaving) {
      if (code.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 43, 11, 11),
            content: Text('Conference code must be 6 characters.',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));
      } else {
        if (_nameController!.text.isEmpty ||
            _descriptionController!.text.isEmpty ||
            _locationController!.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 1),
              backgroundColor: const Color.fromARGB(255, 43, 11, 11),
              content: Text('One or more fields are empty.',
                  style: GoogleFonts.getFont(
                    fontSize: 16,
                    color: const Color(0xFFe9e9e9),
                    'Poppins',
                  ))));
        } else {
          if (checkDates(reversePrettifyDate(_startDateController!.text),
              reversePrettifyDate(_endDateController!.text))) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: const Color.fromARGB(255, 43, 11, 11),
                content: Text('End date is before start date.',
                    style: GoogleFonts.getFont(
                      fontSize: 16,
                      color: const Color(0xFFe9e9e9),
                      'Poppins',
                    ))));
          } else {
            if (!await canLaunchUrl(Uri.parse(_helpLinkController!.text))) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color.fromARGB(255, 43, 11, 11),
                  content: Text('Help Desk link is invalid.',
                      style: GoogleFonts.getFont(
                        fontSize: 16,
                        color: const Color(0xFFe9e9e9),
                        'Poppins',
                      ))));
            } else {
              setState(() {
                isSaving = true;
              });
              await API().updateConferenceBasic(AppInfo.conference.id, [
                _nameController!.text,
                _descriptionController!.text,
                _locationController!.text,
                logo,
                reversePrettifyDate(_startDateController!.text),
                reversePrettifyDate(_endDateController!.text),
                _helpLinkController!.text,
                _passwordController!.text,
                specificLoc,
                _codeController!.text,
                homeBg
              ]);
              AppInfo.conference =
                  await API().getConference(AppInfo.conference.id);

              setState(() {
                isSaving = false;
              });
              discard();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 3),
                  backgroundColor: const Color.fromARGB(255, 15, 155, 45),
                  content: Text('Changes Saved!',
                      style: GoogleFonts.getFont(
                        fontSize: 16,
                        color: const Color(0xFFe9e9e9),
                        'Poppins',
                      ))));
            }
          }
        }
      }
    }
    updateIndex(1); // provide whatever the index of this page is
  }

  discard() {
    setState(() {
      _startDateController!.text = prettifyDate(AppInfo.conference.startDate);
      _endDateController!.text = prettifyDate(AppInfo.conference.endDate);
      _descriptionController!.text = AppInfo.conference.desc;
      _nameController!.text = AppInfo.conference.name;
      _locationController!.text = AppInfo.conference.location;
      _helpLinkController!.text = AppInfo.conference.helpLink;
      _codeController!.text = AppInfo.conference.code;
      homeBg = AppInfo.conference.homeBg;
      specificLoc = AppInfo.conference.specificLoc;
    });
  }
}
