// ignore_for_file: must_be_immutable, use_build_context_synchronously, no_logic_in_create_state

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ConfMapPage extends StatefulWidget {
  const ConfMapPage({super.key});

  @override
  State<ConfMapPage> createState() => _ConfMapPageState();
}

class _ConfMapPageState extends State<ConfMapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _ConfMapPageState();

  bool uploading = false;
  bool saving = false;
  List<String> images = [];

  @override
  void initState() {
    images = AppInfo.conference.map;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  save() async {
    if (!saving) {
      setState(() {
        saving = true;
      });
      await API().updateConferenceMap(AppInfo.conference.id, images);
      AppInfo.conference = await API().getConference(AppInfo.conference.id);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color.fromARGB(255, 11, 43, 31),
          content: Text(
              'Changes Saved! Refresh the app and look at the Conference Map to view changes.',
              style: TextStyle(fontFamily: 'DM Sans',
                fontSize: 16,
                color: const Color(0xFFe9e9e9),
                
              ))));
      setState(() {
        saving = false;
      });
    }
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
        child: // Generated code for this Column Widget...
            SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                                'Conference Maps',
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
                            alignment: Alignment.centerRight,
                            child: !saving
                                ? TextButton(
                                    onPressed: () => save(),
                                    style: ButtonStyle(
                                        shape: const WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        overlayColor:
                                            // only show lighter color if hovered
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          if (states.contains(
                                                  WidgetState.hovered) &&
                                              !states.contains(
                                                  WidgetState.focused) &&
                                              !states.contains(
                                                  WidgetState.pressed)) {
                                            return const Color.fromARGB(
                                                255, 138, 91, 240);
                                            // this is a hacky way to accomplish the ink effect
                                          } else if (states.contains(
                                              WidgetState.pressed)) {
                                            return const Color.fromARGB(
                                                255, 94, 28, 236);
                                          } else {
                                            return null;
                                          }
                                        }),
                                        foregroundColor:
                                            const WidgetStatePropertyAll(
                                                Colors.white),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 115, 57, 237))),
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Edit Conference Maps',
                          style: TextStyle(fontFamily: 'DM Sans',
                            color: Colors.black,
                   
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Upload Image',
                          style: TextStyle(fontFamily: 'DM Sans',
                            color: Colors.black,
                         
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 400,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0x00000000),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 15, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 6, 0),
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        color: Color(0xFF000000),
                                        size: 28,
                                      ),
                                    ),
                                    Text(
                                      'Upload New',
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: const Color(0xFF000000),
                                        fontSize: 18,
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 35, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Current Images',
                          style: TextStyle(fontFamily: 'DM Sans',
                            color: Colors.black,
                   
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 3, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'These may not appear to scale as they are in the app. Check the app to verify the true user experience.',
                          style: TextStyle(fontFamily: 'DM Sans',
          
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: getImageWidgets(),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!saving) {
                          setState(() {
                            saving = true;
                          });
                          await API().updateConferenceMap(
                              AppInfo.conference.id, images);
                          AppInfo.conference =
                              await API().getConference(AppInfo.conference.id);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              backgroundColor:
                                  const Color.fromARGB(255, 11, 43, 31),
                              content: Text(
                                  'Changes Saved! Refresh the app and look at the Conference Map to view changes.',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    
                                  ))));
                          setState(() {
                            saving = false;
                          });
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF202225),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF3E3E3E),
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 15, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Save',
                                      style: TextStyle(fontFamily: 'DM Sans',
                                        
                                        color: const Color(0xFFE9E9E9),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ));
  }

  Future<void> _pickImage() async {
    setState(() {
      uploading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      type: FileType.image,
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

        images.add(imageUrl);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: TextStyle(fontFamily: 'DM Sans',
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  
                ))));

        setState(() {
          uploading = false;
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

        images.add(imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('Image Uploaded!',
                style: TextStyle(fontFamily: 'DM Sans',
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  
                ))));

        setState(() {});
      }
    }
  }

  List<Widget> getImageWidgets() {
    List<Widget> items2 = [];
    for (int i = 0; i < images.length; i++) {
      String item = images[i];

      items2.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  item,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      child: InkWell(
                        onTap: () {
                          if (i == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content:
                                    Text('Cannot move the leftmost image left.',
                                        style: TextStyle(fontFamily: 'DM Sans',
                                          fontSize: 16,
                                          color: const Color(0xFFe9e9e9),
                                          
                                        ))));
                          } else {
                            String temp = images[i - 1];
                            images[i - 1] = images[i];
                            images[i] = temp;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      child: InkWell(
                        onTap: () {
                          if (i == images.length - 1) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text(
                                    'Cannot move the rightmost image right.',
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      
                                    ))));
                          } else {
                            String temp = images[i + 1];
                            images[i + 1] = images[i];
                            images[i] = temp;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        images.removeAt(i);
                        setState(() {});
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF310801),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 18,
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
    return items2;
  }
}
