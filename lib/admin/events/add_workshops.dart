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

  bool loadingEvents = false;
  bool excludeFinal = true;
  bool deletingData = false;
  bool dataLoaded = false;
  bool showAnnouncements = false;

  List<WorkshopData> events = [];

  _AddWorkshopsAdminState() {
    API().getWorkshops(AppInfo.conference.id).then((value) {
      events = value;
      events.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        dataLoaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                          padding: EdgeInsets.fromLTRB(50, 40, 0, 40),
                          child: Text(
                            'Modify Agenda Items',
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
              padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Changes made are automatically reflected in the app - be careful!',
                    style: TextStyle(fontFamily: 'DM Sans',
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 113, 2, 0),
                      
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 40, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload File',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !loadingEvents
                      ? InkWell(
                          onTap: () async {
                            setState(() {
                              loadingEvents = true;
                            });
                            try {
                              await _uploadSpreadsheet(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 3),
                                      backgroundColor:
                                          const Color.fromARGB(255, 11, 43, 31),
                                      content: Text(
                                          'Workshops Uploaded! Please reload the website.',
                                          style: TextStyle(fontFamily: 'DM Sans',
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            
                                          ))));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor:
                                          const Color.fromARGB(255, 43, 11, 11),
                                      content: Text(
                                          'Error in uploading workshops. Please try again later.',
                                          style: TextStyle(fontFamily: 'DM Sans',
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            
                                          ))));
                            }
                          },
                          child: Container(
                            width: 250,
                            height: 60,
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
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 0),
                                  child: Icon(
                                    Icons.file_upload_outlined,
                                    color: Color(0xFF000000),
                                    size: 22,
                                  ),
                                ),
                                Text(
                                  'Upload Spreadsheet',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: const Color(0xFF000000),
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : const CircularProgressIndicator(color: Colors.black),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                      child: !deletingData
                          ? InkWell(
                              onTap: () async {
                                setState(() {
                                  deletingData = true;
                                });
                                try {
                                  await deleteData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 43, 11, 11),
                                          content: Text('Items removed.',
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                
                                              ))));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: const Color.fromARGB(
                                              255, 43, 11, 11),
                                          content: Text(
                                              'Error in performing action. Please try again later.',
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                
                                              ))));
                                }
                              },
                              child: Container(
                                width: 250,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 146, 161),
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
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 8, 0),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Color(0xFF000000),
                                        size: 22,
                                      ),
                                    ),
                                    Text(
                                      'Remove All Items',
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: const Color(0xFF000000),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 30, 50, 40),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          'https://docs.google.com/document/d/1SX36Oui-mFzDXoU47wSq-hc8K_oETqov0omeHhLk3vU/edit#bookmark=id.lu69hhi1a2q8'));
                    },
                    child: Container(
                      width: 250,
                      height: 60,
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
                            style: TextStyle(fontFamily: 'DM Sans',
                              
                              color: const Color(0xFF000000),
                              fontSize: 17,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Icon(
                              Icons.open_in_new,
                              color: Color(0xFF000000),
                              size: 22,
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
              padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 50, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'All Agenda Items (may have to reload website)',
                    style: TextStyle(fontFamily: 'DM Sans',
                      
                      fontSize: 22,
                      color: Colors.black,
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
                    ? getEventWidgets()
                    : showAnnouncements
                        ? [
                            const CircularProgressIndicator(
                                color: Color(0xFF000000))
                          ]
                        : [const SizedBox()],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  List<Widget> getEventWidgets() {
    List<Widget> items = [];
    for (int i = 0; i < events.length; i++) {
      items.add(// Generated code for this Row Widget...
          Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(50, 8, 50, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 675,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xfFFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                  child: Text(
                    '${events[i].name} (${DateFormat('MMM. d').format(DateFormat('yyyy-MM-dd').parse(events[i].date))}, ${events[i].startTime})',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
        
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(37, 0, 0, 0),
              child: InkWell(
                onTap: () async {
                  await API()
                      .deleteWorkshop(AppInfo.conference.id, events[i].id);
                  events.removeAt(i);
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
          ],
        ),
      ));

      if (events[i].sessions.isNotEmpty) {
        for (int j = 0; j < events[i].sessions.length; j++) {
          items.add(// Generated code for this Row Widget...
              Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(75, 8, 50, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 650,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xfFFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                      child: Text(
                        '${events[i].sessions[j]['name']} (${DateFormat('MMM. d').format(DateFormat('yyyy-MM-dd').parse(events[i].sessions[j]['date']!))}, ${events[i].sessions[j]['startTime']})',
                        style: TextStyle(fontFamily: 'DM Sans',
                          color: Colors.black,
                         
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(37, 0, 0, 0),
                  child: InkWell(
                    onTap: () async {
                      await API().deleteSession(
                          AppInfo.conference.id, events[i].id, j);
                      events[i].sessions.removeAt(j);
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
              ],
            ),
          ));
        }
      }
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

  Future<void> uploadData(List<Map<dynamic, dynamic>> dataList) async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('workshops');
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
      // Get reference to the user document
      DocumentReference userRef = usersCollection.doc(userDoc.id);

      // Update the "agendaItems" field with the modified map
      await userRef.update({'agendaItems': {}});
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
