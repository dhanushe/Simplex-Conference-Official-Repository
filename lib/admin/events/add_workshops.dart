// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state, must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_excel/excel.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../../api/objects/workshop_data.dart';

class AddWorkshopsAdmin extends StatefulWidget {
  const AddWorkshopsAdmin({
    super.key,
  });

  @override
  State<AddWorkshopsAdmin> createState() => _AddWorkshopsAdminState();
}

class _AddWorkshopsAdminState extends State<AddWorkshopsAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<WorkshopData> workshops = [];
  bool loadingWorkshops = false;
  bool deletingData = false;
  bool dataLoaded = false;
  String search = "";
  int workshopIndex = -1;
  TextEditingController? nameController;
  TextEditingController? descController;
  TextEditingController? locationController;
  String workshopDate = "";
  String startTime = "";
  String endTime = "";

  // Add Session fields
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addLocationController = TextEditingController();
  final TextEditingController addDescController = TextEditingController();
  String addDate = "";
  String addStartTime = "";
  String addEndTime = "";
  String addType = "Event";
  final List<String> typeOptions = ["Event", "Other", "Session"];

  // For editing a session in the middle column
  int? selectedSessionWorkshopIndex;
  int? selectedSessionIndex;
  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController sessionDescController = TextEditingController();
  final TextEditingController sessionLocationController = TextEditingController();
  String sessionDate = "";
  String sessionStartTime = "";
  String sessionEndTime = "";
  String sessionTag = "arts";
  final List<String> tagOptions = [
    "arts",
    "communication",
    "business management",
    "education",
    "entrepreneurship",
    "finance",
    "law & government",
    "marketing",
    "stem",
    "state office",
    "misc"
  ];

  // For adding a session to a WorkshopData object of type "Session"
  final TextEditingController addSessionNameController = TextEditingController();
  final TextEditingController addSessionDescController = TextEditingController();
  final TextEditingController addSessionLocationController = TextEditingController();
  String addSessionDate = "";
  String addSessionStartTime = "";
  String addSessionEndTime = "";
  String addSessionTag = "arts";

  @override
  void initState() {
    nameController = TextEditingController();
    descController = TextEditingController();
    locationController = TextEditingController();
    API().getWorkshops(AppInfo.conference.id).then((value) {
      workshops = value;
      workshops.sort((a, b) => a.name.compareTo(b.name));
      setState(() {
        dataLoaded = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController?.dispose();
    descController?.dispose();
    locationController?.dispose();
    addNameController.dispose();
    addLocationController.dispose();
    addDescController.dispose();
    sessionNameController.dispose();
    sessionDescController.dispose();
    sessionLocationController.dispose();
    addSessionNameController.dispose();
    addSessionDescController.dispose();
    addSessionLocationController.dispose();
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
                            'Modify Workshops',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: Edit Info box (copied from add_events.dart, no final toggle)
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .22,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * .22,
                          child: 
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
                                const Text('Edit Info',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () async {
                                    await launchUrl(Uri.parse(
                                        'https://docs.google.com/document/d/1SX36Oui-mFzDXoU47wSq-hc8K_oETqov0omeHhLk3vU/edit#bookmark=id.lu69hhi1a2q8'));
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
                                        const Text(
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
                                  child: !loadingWorkshops
                                      ? InkWell(
                                          onTap: () async {
                                            setState(() {
                                              loadingWorkshops = true;
                                            });
                                            try {
                                              await _uploadSpreadsheet(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration:
                                                          const Duration(seconds: 3),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 11, 43, 31),
                                                      content: Text(
                                                          'Workshops Uploaded! Please reload the website.',
                                                          style: const TextStyle(
                                                            fontFamily: 'DM Sans',
                                                            fontSize: 16,
                                                            color: Color(0xFFe9e9e9),
                                                          ))));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration:
                                                          const Duration(seconds: 1),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 43, 11, 11),
                                                      content: Text(
                                                          'Error in uploading workshops. Please try again later.',
                                                          style: const TextStyle(
                                                            fontFamily: 'DM Sans',
                                                            fontSize: 16,
                                                            color: Color(0xFFe9e9e9),
                                                          ))));
                                            }
                                            setState(() {
                                              loadingWorkshops = false;
                                            });
                                          },
                                          child: Container(
                                            width: 180,
                                            height: 40,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 8, 0),
                                                  child: Icon(
                                                    Icons.file_upload_outlined,
                                                    color: Color(0xFF000000),
                                                    size: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'Upload Spreadsheet',
                                                  style: TextStyle(
                                                    fontFamily: 'DM Sans',
                                                    color: Color(0xFF000000),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : const CircularProgressIndicator(
                                          color: Colors.black),
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
                                                      duration:
                                                          const Duration(seconds: 1),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 43, 11, 11),
                                                      content: Text(
                                                          'Items removed.',
                                                          style: const TextStyle(
                                                            fontFamily: 'DM Sans',
                                                            fontSize: 16,
                                                            color: Color(0xFFe9e9e9),
                                                          ))));
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration:
                                                          const Duration(seconds: 1),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 43, 11, 11),
                                                      content: Text(
                                                          'Error in performing action. Please try again later.',
                                                          style: const TextStyle(
                                                            fontFamily: 'DM Sans',
                                                            fontSize: 16,
                                                            color: Color(0xFFe9e9e9),
                                                          ))));
                                            }
                                            setState(() {
                                              deletingData = false;
                                            });
                                          },
                                          child: Container(
                                            width: 180,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 146, 161),
                                              borderRadius: BorderRadius.circular(8),
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
                                                const Text(
                                                  'Remove All Items',
                                                  style: TextStyle(
                                                    fontFamily: 'DM Sans',
                                                    color: Color(0xFF000000),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const CircularProgressIndicator(
                                          color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),),
                        const SizedBox(height: 20),
                        // --- Add Session Box ---
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
                                const Text('Add Session',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                const SizedBox(height: 15),
                                const Text('Name',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    controller: addNameController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Start Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addStartTime),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      suffix: TextButton(
                                        child: const Text(
                                          'Select Time',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _parseTimeOfDay(addStartTime),
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              addStartTime = _formatTimeOfDay(pickedTime);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('End Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addEndTime),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      suffix: TextButton(
                                        child: const Text(
                                          'Select Time',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _parseTimeOfDay(addEndTime),
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              addEndTime = _formatTimeOfDay(pickedTime);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Location',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    controller: addLocationController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Location',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Date',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addDate),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
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
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: addDate.isNotEmpty
                                                ? DateFormat('yyyy-MM-dd').parse(addDate)
                                                : DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2031),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              addDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Description',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: TextField(
                                    controller: addDescController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Description',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Type',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .18,
                                  child: DropdownButtonFormField<String>(
                                    value: addType,
                                    items: typeOptions
                                        .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        addType = val ?? "Event";
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          addNameController.clear();
                                          addLocationController.clear();
                                          addDescController.clear();
                                          addDate = "";
                                          addStartTime = "";
                                          addEndTime = "";
                                          addType = "Event";
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 243, 237, 254),
                                      ),
                                      child: const Text(
                                        'Discard',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 57, 237),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () async {
                                        // Validation
                                        if (addNameController.text.trim().isEmpty ||
                                            addLocationController.text.trim().isEmpty ||
                                            addDescController.text.trim().isEmpty ||
                                            addDate.isEmpty ||
                                            addStartTime.isEmpty ||
                                            addEndTime.isEmpty ||
                                            addType.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please fill out all fields.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        String sessionId = "";
                                        if (addType == "Session") {
                                          // Find highest sessionId in all workshops
                                          int maxSessionId = 0;
                                          for (var w in workshops) {
                                            if (w.sessionId.isNotEmpty) {
                                              int? sid = int.tryParse(w.sessionId);
                                              if (sid != null && sid < maxSessionId) {
                                                maxSessionId = sid;
                                              }
                                            }
                                          }
                                          sessionId = (maxSessionId - 1).toString();
                                        }
                                        WorkshopData newWorkshop = WorkshopData(
                                          id: "", // Firestore will assign
                                          name: addNameController.text.trim(),
                                          startTime: addStartTime,
                                          endTime: addEndTime,
                                          location: addLocationController.text.trim(),
                                          date: addDate,
                                          desc: addDescController.text.trim(),
                                          tag: "",
                                          type: addType,
                                          sessions: [],
                                          sessionId: sessionId,
                                        );
                                        await uploadData([{
                                          'name': newWorkshop.name,
                                          'startTime': newWorkshop.startTime,
                                          'endTime': newWorkshop.endTime,
                                          'location': newWorkshop.location,
                                          'date': newWorkshop.date,
                                          'desc': newWorkshop.desc,
                                          'tag': newWorkshop.tag,
                                          'type': newWorkshop.type,
                                          'sessions': [],
                                          'sessionId': newWorkshop.sessionId,
                                        }]);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Session Added!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        setState(() {
                                          addNameController.clear();
                                          addLocationController.clear();
                                          addDescController.clear();
                                          addDate = "";
                                          addStartTime = "";
                                          addEndTime = "";
                                          addType = "Event";
                                          // Optionally reload workshops
                                          API().getWorkshops(AppInfo.conference.id).then((value) {
                                            workshops = value;
                                            workshops.sort((a, b) => a.name.compareTo(b.name));
                                            setState(() {});
                                          });
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 115, 57, 237),
                                      ),
                                      child: const Text(
                                        'Add',
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
                  ),
                  const SizedBox(width: 15),
                  // MIDDLE: Workshops and Sessions
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*.22,
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.white,
                      elevation: 0.5,
                      child: Container(
                        height: MediaQuery.sizeOf(context).height - 80,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sessions',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 5),
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
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (val) {
                                      setState(() {
                                        search = val;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        search = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      hintStyle: const TextStyle(
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFAEAEAE),
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
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              20, 6, 0, 6),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Color(0xFFAEAEAE),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Workshop List with Sessions
                              Expanded(
                                child: dataLoaded
                                    ? SingleChildScrollView(
                                        child: Column(
                                          children: workshops
                                              .where((workshop) =>
                                                  search.isEmpty ||
                                                  workshop.name
                                                      .toLowerCase()
                                                      .contains(search
                                                          .toLowerCase()))
                                              .toList()
                                              .asMap()
                                              .entries
                                              .expand((entry) {
                                            int i = entry.key;
                                            WorkshopData workshop = entry.value;
                                            List<Widget> widgets = [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 8, 0, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          workshopIndex = i;
                                                          selectedSessionWorkshopIndex = null;
                                                          selectedSessionIndex = null;
                                                          nameController!.text =
                                                              workshop.name;
                                                          descController!.text =
                                                              workshop.desc;
                                                          locationController!
                                                                  .text =
                                                              workshop.location;
                                                          workshopDate =
                                                              workshop.date;
                                                          startTime =
                                                              workshop.startTime;
                                                          endTime =
                                                              workshop.endTime;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.sizeOf(
                                                                    context)
                                                                .width *
                                                            .15,
                                                        height: 44,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (workshopIndex == i && selectedSessionWorkshopIndex == null)
                                                              ? const Color(
                                                                  0xFFe3d6fa)
                                                              : const Color(
                                                                  0xFFf9f9f9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                            color: (workshopIndex == i && selectedSessionWorkshopIndex == null)
                                                                ? const Color(
                                                                    0xFF7339ED)
                                                                : const Color(
                                                                    0xFFE0E0E0),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  -1, 0),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              '${workshop.name} (${workshop.date}, ${workshop.startTime})',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'DM Sans',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    InkWell(
                                                      onTap: () async {
                                                        bool confirmDelete =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Confirm Deletion'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this workshop?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true),
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );

                                                        if (confirmDelete) {
                                                          await API()
                                                              .deleteWorkshop(
                                                                  AppInfo
                                                                      .conference
                                                                      .id,
                                                                  workshop.id);
                                                          setState(() {
                                                            workshops
                                                                .removeAt(i);
                                                            if (workshopIndex ==
                                                                i) {
                                                              workshopIndex =
                                                                  -1;
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 34,
                                                        height: 34,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 234, 39, 39),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.delete_outline,
                                                          color:
                                                              Color(0xFFE9E9E9),
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ];
                                            // Add sessions if any
                                            if (workshop.sessions.isNotEmpty) {
                                              widgets.addAll(workshop.sessions
                                                  .asMap()
                                                  .entries
                                                  .map((sessionEntry) {
                                                int sessionIndex =
                                                    sessionEntry.key;
                                                Map<String, String> session =
                                                    sessionEntry.value;
                                                bool isSelected = (selectedSessionWorkshopIndex == i && selectedSessionIndex == sessionIndex);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              25, 8, 0, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedSessionWorkshopIndex = i;
                                                            selectedSessionIndex = sessionIndex;
                                                            workshopIndex = -1;
                                                            sessionNameController.text = session['name'] ?? "";
                                                            sessionDescController.text = session['desc'] ?? "";
                                                            sessionLocationController.text = session['location'] ?? "";
                                                            sessionDate = session['date'] ?? "";
                                                            sessionStartTime = session['startTime'] ?? "";
                                                            sessionEndTime = session['endTime'] ?? "";
                                                            sessionTag = session['tag'] ?? tagOptions.first;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.sizeOf(context).width * .13,
                                                          height: 44,
                                                          decoration: BoxDecoration(
                                                            color: isSelected
                                                                ? const Color(0xFFe3d6fa)
                                                                : const Color(0xFFf9f9f9),
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? const Color(0xFF7339ED)
                                                                  : const Color(0xFFE0E0E0),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment: const AlignmentDirectional(-1, 0),
                                                            child: Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                                              child: Text(
                                                                '${session['name']} (${session['date']})',
                                                                style: const TextStyle(
                                                                  fontFamily: 'DM Sans',
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      InkWell(
                                                        onTap: () async {
                                                          bool confirmDelete =
                                                              await showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Confirm Deletion'),
                                                                content: const Text(
                                                                    'Are you sure you want to delete this session?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop(
                                                                                false),
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop(
                                                                                true),
                                                                    child: const Text(
                                                                        'Delete'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );

                                                          if (confirmDelete) {
                                                            workshops[i]
                                                                .sessions
                                                                .removeAt(
                                                                    sessionIndex);
                                                            await API()
                                                                .updateWorkshop(
                                                                    workshops[i],
                                                                    AppInfo
                                                                        .conference
                                                                        .id);
                                                            setState(() {
                                                              if (selectedSessionWorkshopIndex == i && selectedSessionIndex == sessionIndex) {
                                                                selectedSessionWorkshopIndex = null;
                                                                selectedSessionIndex = null;
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 34,
                                                          height: 34,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color.fromARGB(
                                                                255, 234, 39, 39),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.delete_outline,
                                                            color:
                                                                Color(0xFFE9E9E9),
                                                            size: 22,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }));
                                            }
                                            return widgets;
                                          }).toList(),
                                        ),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // RIGHT: Edit Workshop or Edit Session (only if selected)
                  if (workshopIndex != -1)
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .2,
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
                              const Text('Edit Session',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 15),
                              // Workshop Name
                              const Text(
                                'Session Name',
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
                                  controller: nameController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Workshop Name',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Workshop Date
                              const Text(
                                'Workshop Date',
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
                                      text: workshopDate),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
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
                                          initialDate: workshopDate.isNotEmpty
                                              ? DateFormat('yyyy-MM-dd')
                                                  .parse(workshopDate)
                                              : DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2031),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            workshopDate = DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Workshop Description
                              const Text(
                                'Description',
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
                                  controller: descController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Description',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Workshop Location
                              const Text(
                                'Location',
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
                                  controller: locationController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Location',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Start Time
                              const Text(
                                'Start Time',
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
                                      text: startTime),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    suffix: TextButton(
                                      child: const Text(
                                        'Select Time',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 57, 237),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: _parseTimeOfDay(startTime),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            startTime =
                                                _formatTimeOfDay(pickedTime);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // End Time
                              const Text(
                                'End Time',
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
                                      text: endTime),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    suffix: TextButton(
                                      child: const Text(
                                        'Select Time',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 57, 237),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: _parseTimeOfDay(endTime),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            endTime =
                                                _formatTimeOfDay(pickedTime);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Save/Discard Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        workshopIndex = -1;
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
                                      workshops[workshopIndex] = WorkshopData(
                                        id: workshops[workshopIndex].id,
                                        name: nameController!.text,
                                        startTime: startTime,
                                        endTime: endTime,
                                        location: locationController!.text,
                                        date: workshopDate,
                                        desc: descController!.text,
                                        tag: workshops[workshopIndex].tag,
                                        type: workshops[workshopIndex].type,
                                        sessions: workshops[workshopIndex]
                                            .sessions,
                                        sessionId: workshops[workshopIndex]
                                            .sessionId,
                                      );
                                      await API().updateWorkshop(
                                          workshops[workshopIndex],
                                          AppInfo.conference.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Changes Saved!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      setState(() {
                                        workshopIndex = -1;
                                      });
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
                              // Add Session to WorkshopData (only if type == "Session")
                              if (workshops[workshopIndex].type == "Session") ...[
                                const SizedBox(height: 30),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text('Add Workshop to Session',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                const SizedBox(height: 15),
                                const Text('Name',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    controller: addSessionNameController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Start Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addSessionStartTime),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      suffix: TextButton(
                                        child: const Text(
                                          'Select Time',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _parseTimeOfDay(addSessionStartTime),
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              addSessionStartTime = _formatTimeOfDay(pickedTime);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('End Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addSessionEndTime),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      suffix: TextButton(
                                        child: const Text(
                                          'Select Time',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _parseTimeOfDay(addSessionEndTime),
                                          );
                                          if (pickedTime != null) {
                                            setState(() {
                                              addSessionEndTime = _formatTimeOfDay(pickedTime);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Location',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    controller: addSessionLocationController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Location',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Date',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(text: addSessionDate),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
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
                                            color: Color.fromARGB(255, 115, 57, 237),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: addSessionDate.isNotEmpty
                                                ? DateFormat('yyyy-MM-dd').parse(addSessionDate)
                                                : DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2031),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              addSessionDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Description',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: TextField(
                                    controller: addSessionDescController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      hintText: 'Enter Description',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text('Tag',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 260,
                                  child: DropdownButtonFormField<String>(
                                    value: addSessionTag,
                                    items: tagOptions
                                        .map((tag) => DropdownMenuItem(
                                              value: tag,
                                              child: Text(tag),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        addSessionTag = val ?? tagOptions.first;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          addSessionNameController.clear();
                                          addSessionDescController.clear();
                                          addSessionLocationController.clear();
                                          addSessionDate = "";
                                          addSessionStartTime = "";
                                          addSessionEndTime = "";
                                          addSessionTag = "arts";
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 243, 237, 254),
                                      ),
                                      child: const Text(
                                        'Discard',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 115, 57, 237),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      onPressed: () async {
                                        if (addSessionNameController.text.trim().isEmpty ||
                                            addSessionDescController.text.trim().isEmpty ||
                                            addSessionLocationController.text.trim().isEmpty ||
                                            addSessionDate.isEmpty ||
                                            addSessionStartTime.isEmpty ||
                                            addSessionEndTime.isEmpty ||
                                            addSessionTag.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please fill out all fields.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        final ws = workshops[workshopIndex];
                                        ws.sessions.add({
                                          'name': addSessionNameController.text.trim(),
                                          'date': addSessionDate,
                                          'desc': addSessionDescController.text.trim(),
                                          'location': addSessionLocationController.text.trim(),
                                          'startTime': addSessionStartTime,
                                          'endTime': addSessionEndTime,
                                          'tag': addSessionTag,
                                          'sessionId': ws.sessionId,
                                          'type': "",
                                        });
                                        await API().updateWorkshop(ws, AppInfo.conference.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Session Added!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        setState(() {
                                          addSessionNameController.clear();
                                          addSessionDescController.clear();
                                          addSessionLocationController.clear();
                                          addSessionDate = "";
                                          addSessionStartTime = "";
                                          addSessionEndTime = "";
                                          addSessionTag = "arts";
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 115, 57, 237),
                                      ),
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (selectedSessionWorkshopIndex != null && selectedSessionIndex != null)
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .22,
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
                              const Text('Edit Session',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 15),
                              const Text('Session Name',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  controller: sessionNameController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Session Name',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('Date',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: sessionDate),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
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
                                          color: Color.fromARGB(255, 115, 57, 237),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: sessionDate.isNotEmpty
                                              ? DateFormat('yyyy-MM-dd').parse(sessionDate)
                                              : DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2031),
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            sessionDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('Description',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  controller: sessionDescController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Description',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('Location',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  controller: sessionLocationController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    hintText: 'Enter Location',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('Start Time',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: sessionStartTime),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    suffix: TextButton(
                                      child: const Text(
                                        'Select Time',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 115, 57, 237),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: _parseTimeOfDay(sessionStartTime),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            sessionStartTime = _formatTimeOfDay(pickedTime);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('End Time',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: sessionEndTime),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    suffix: TextButton(
                                      child: const Text(
                                        'Select Time',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 115, 57, 237),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        TimeOfDay? pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime: _parseTimeOfDay(sessionEndTime),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            sessionEndTime = _formatTimeOfDay(pickedTime);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text('Tag',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 280,
                                child: DropdownButtonFormField<String>(
                                  value: sessionTag,
                                  items: tagOptions
                                      .map((tag) => DropdownMenuItem(
                                            value: tag,
                                            child: Text(tag),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      sessionTag = val ?? tagOptions.first;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedSessionWorkshopIndex = null;
                                        selectedSessionIndex = null;
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
                                      // Validation
                                      if (sessionNameController.text.trim().isEmpty ||
                                          sessionDescController.text.trim().isEmpty ||
                                          sessionLocationController.text.trim().isEmpty ||
                                          sessionDate.isEmpty ||
                                          sessionStartTime.isEmpty ||
                                          sessionEndTime.isEmpty ||
                                          sessionTag.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please fill out all fields.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      // Update session map
                                      final wsIndex = selectedSessionWorkshopIndex!;
                                      final sIndex = selectedSessionIndex!;
                                      workshops[wsIndex].sessions[sIndex] = {
                                        'name': sessionNameController.text.trim(),
                                        'date': sessionDate,
                                        'desc': sessionDescController.text.trim(),
                                        'location': sessionLocationController.text.trim(),
                                        'startTime': sessionStartTime,
                                        'endTime': sessionEndTime,
                                        'tag': sessionTag,
                                        'sessionId': workshops[wsIndex].sessions[sIndex]['sessionId'] ?? "",
                                        'type': workshops[wsIndex].sessions[sIndex]['type'] ?? "",
                                      };
                                      await API().updateWorkshop(
                                          workshops[wsIndex],
                                          AppInfo.conference.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Session Updated!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      setState(() {
                                        selectedSessionWorkshopIndex = null;
                                        selectedSessionIndex = null;
                                      });
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
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      try {
        var bytes = pickedFile.files.single.bytes!.toList();
        var excel = Excel.decodeBytes(bytes);

        var table = excel.tables.keys.first;
        for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
          var row = excel.tables[table]!.rows[i];
          if (row[8] != null && row[6] == null) {
            continue;
          }
          String date = row[3]!.value.toString().replaceAll("/", "-");
          DateTime inputDate;
          if (date.contains("T")) {
            date = date.substring(0, date.indexOf("T"));
            inputDate = DateFormat('yyyy-MM-dd').parse(date);
          } else if (int.tryParse(row[3]!.value.toString()) != null) {
            inputDate = DateTime(1899, 12, 30)
                .add(Duration(days: int.tryParse(row[3]!.value.toString())!));
          } else {
            inputDate = DateFormat('M-d-yyyy').parse(date);
          }
          String outputDateString = DateFormat('yyyy-MM-dd').format(inputDate);
          List<Map<String, String>> sessions = [];
          if (row[8] != null &&
              row[6]!.value.toString().toLowerCase() == "session") {
            for (int j = 1; j < excel.tables[table]!.rows.length; j++) {
              var row2 = excel.tables[table]!.rows[j];
              if (j != i && row2[8] != null) {
                if (row2[8]!.value.toString() == row[8]!.value.toString()) {
                  String date2 = row[3]!.value.toString().replaceAll("/", "-");
                  DateTime inputDate2;
                  if (date2.contains("T")) {
                    date2 = date2.substring(0, date2.indexOf("T"));
                    inputDate2 = DateFormat('yyyy-MM-dd').parse(date2);
                  } else if (int.tryParse(row2[3]!.value.toString()) != null) {
                    inputDate2 = DateTime(1899, 12, 30).add(Duration(
                        days: int.tryParse(row2[3]!.value.toString())!));
                  } else {
                    inputDate2 = DateFormat('M-d-yyyy').parse(date2);
                  }
                  String outputDateString2 =
                      DateFormat('yyyy-MM-dd').format(inputDate2);
                  sessions.add({
                    'name': row2[0]!.value.toString(),
                    'startTime': DateFormat('h:mm a')
                        .format(DateTime.parse(row2[1]!.value.toString()))
                        .toLowerCase()
                        .replaceAll(' ', ''),
                    'endTime': DateFormat('h:mm a')
                        .format(DateTime.parse(row2[2]!.value.toString()))
                        .toLowerCase()
                        .replaceAll(' ', ''),
                    'date': outputDateString2,
                    'desc': row2[4] != null ? row2[4]!.value.toString() : "",
                    'location':
                        row2[5] != null ? row2[5]!.value.toString() : "",
                    'type': row2[6] != null ? row2[6]!.value.toString() : "",
                    'tag': row2[7] != null
                        ? row2[7]!.value.toString().toLowerCase()
                        : "",
                    'sessionId':
                        row2[8] != null ? row[8]!.value.toString() : "",
                  });
                }
              }
            }
          }
          events.add({
            'name': row[0]!.value.toString(),
            'startTime': DateFormat('h:mm a')
                .format(DateTime.parse(row[1]!.value.toString()))
                .toLowerCase()
                .replaceAll(' ', ''),
            'endTime': DateFormat('h:mm a')
                .format(DateTime.parse(row[2]!.value.toString()))
                .toLowerCase()
                .replaceAll(' ', ''),
            'date': outputDateString,
            'desc': row[4] != null ? row[4]!.value.toString() : "",
            'location': row[5] != null ? row[5]!.value.toString() : "",
            'type': row[6] != null ? row[6]!.value.toString() : "",
            'tag': row[7] != null ? row[7]!.value.toString().toLowerCase() : "",
            'sessionId': row[8] != null ? row[8]!.value.toString() : "",
            'sessions': sessions,
          });
        }

        gotEvents = true;
      } catch (e) {
        rethrow;
      }
    }

    if (gotEvents) {
      await uploadData(events);
    }

    setState(() {
      loadingWorkshops = false;
    });
  }

  Future<void> uploadData(List<Map<dynamic, dynamic>> dataList) async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('workshops');
    for (Map<dynamic, dynamic> dataMap in dataList) {
      await collection.add(dataMap);
    }
  }

  Future<void> deleteData() async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('workshops');
    await collection.get().then((querySnapshot) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('users')
        .get();
    CollectionReference usersCollection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('users');

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      DocumentReference userRef = usersCollection.doc(userDoc.id);
      await userRef.update({'agendaItems': {}});
    }

    setState(() {
      deletingData = false;
    });
  }

  List<String> parseNames(String input) {
    List<String> namesList = [];
    List<String> namePairs = input.split(';');

    for (String namePair in namePairs) {
      String trimmedNamePair = namePair.trim();
      List<String> nameParts = trimmedNamePair.split(',');

      if (nameParts.length == 2) {
        String firstName = nameParts[1].trim();
        String lastName = nameParts[0].trim();
        String formattedName = '$firstName $lastName';
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
    int randomIndex = random.nextInt(strings.length);
    return strings[randomIndex];
  }

  String getEndTime(String inputTime) {
    DateTime parsedTime = parseTimeString(inputTime);
    DateTime resultTime = parsedTime.add(const Duration(minutes: 20));
    int hour12 = resultTime.hour > 12 ? resultTime.hour - 12 : resultTime.hour;
    if (hour12 == 0) {
      hour12 = 12;
    }
    String formattedResult =
        "$hour12:${resultTime.minute.toString().padLeft(2, '0')}";
    String amPm = resultTime.hour < 12 ? "am" : "pm";
    return "$formattedResult$amPm";
  }

  DateTime parseTimeString(String timeString) {
    DateTime currentDate = DateTime.now().toLocal();
    DateTime targetTime = DateFormat('h:mm').parse(timeString);
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

  /// Helper to parse a string like "6:30am" or "12:30pm" to TimeOfDay
  TimeOfDay _parseTimeOfDay(String time) {
    if (time.isEmpty) return TimeOfDay.now();
    try {
      final match = RegExp(r'^(\d{1,2}):(\d{2})(am|pm)$').firstMatch(time.replaceAll(' ', '').toLowerCase());
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        String period = match.group(3)!;
        if (period == 'pm' && hour != 12) hour += 12;
        if (period == 'am' && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return TimeOfDay.now();
  }

  /// Helper to format TimeOfDay to "h:mma" (e.g., "6:30am")
  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute$period';
  }
}
