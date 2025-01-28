// ignore_for_file: must_be_immutable, use_build_context_synchronously, no_logic_in_create_state

import 'package:auto_size_text/auto_size_text.dart';
import '../../flutter_flow%20copy/flutter_flow_drop_down.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class TileEditPage extends StatefulWidget {
  const TileEditPage({
    super.key,
  });

  @override
  State<TileEditPage> createState() => _TileEditPageState();
}

class _TileEditPageState extends State<TileEditPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _TileEditPageState();
  List<Map<String, String>> tiles = AppInfo.conference.tiles;

  TextEditingController? text1;
  TextEditingController? text2;
  TextEditingController? text3;
  TextEditingController? text4;

  String type = "Long Single Item";
  String name1 = "";
  String name2 = "";
  String link1 = "";
  String link2 = "";
  int index1 = 1;
  int index2 = 1;

  bool uploading = false;
  bool saving = false;

  @override
  void initState() {
    text1 = TextEditingController();
    text2 = TextEditingController();
    text3 = TextEditingController();
    text4 = TextEditingController();

    super.initState();
  }

  save() async {
    if (!saving) {
      setState(() {
        saving = true;
      });

      await API().updateConferenceTiles(
        AppInfo.conference.id,
        tiles,
      );
      AppInfo.conference = await API().getConference(AppInfo.conference.id);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color.fromARGB(255, 11, 43, 31),
          content: Text(
              'Changes Saved! Refresh the app and look at the \'Home\' Page to view changes.',
              style: GoogleFonts.getFont(
                fontSize: 16,
                color: const Color(0xFFe9e9e9),
                'Poppins',
              ))));
      setState(() {
        saving = false;
      });
    }
  }

  @override
  void dispose() {
    text1!.dispose();
    text2!.dispose();
    text3!.dispose();
    text4!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width * .8,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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

                          const SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: !saving
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
                                          if (states.contains(
                                                  MaterialState.hovered) &&
                                              !states.contains(
                                                  MaterialState.focused) &&
                                              !states.contains(
                                                  MaterialState.pressed)) {
                                            return const Color.fromARGB(
                                                255, 138, 91, 240);
                                            // this is a hacky way to accomplish the ink effect
                                          } else if (states.contains(
                                              MaterialState.pressed)) {
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 40, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: FlutterFlowDropDown(
                            options: const [
                              'Long Single Item',
                              'Row of Two Items'
                            ],
                            onChanged: (val) {
                              setState(() {
                                type = val!;
                                name1 = "";
                                name2 = "";
                                index1 = 1;
                                index2 = 1;
                                link1 = "";
                                link2 = "";
                              });
                            },
                            initialOption: type,
                            width: MediaQuery.sizeOf(context).width * 0.25,
                            height: 65,
                            textStyle: GoogleFonts.getFont(
                              color: Colors.black,
                              'DM Sans',
                              fontSize: 16,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black,
                              size: 24,
                            ),
                            fillColor: const Color(0x0026292D),
                            elevation: 2,
                            borderColor: Colors.grey.shade300,
                            borderWidth: 2,
                            borderRadius: 12,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                20, 4, 20, 4),
                            hidesUnderline: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            'Display Name',
                            style: GoogleFonts.getFont(
                              color: Colors.black,
                              'DM Sans',
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              child: TextFormField(
                                controller: text1,
                                onChanged: (val) {
                                  name1 = val;
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Put name here...',
                                  hintStyle: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Colors.black,
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
                                  fillColor: const Color(0x0026292D),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          25, 15, 25, 15),
                                ),
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    type == "Row of Two Items"
                        ? Flexible(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  60, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Display Name #2',
                                    style: GoogleFonts.getFont(
                                      color: Colors.black,
                                      'DM Sans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.3,
                                      child: TextFormField(
                                        controller: text2,
                                        onChanged: (val) {
                                          name2 = val;
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Put name here...',
                                          hintStyle: GoogleFonts.getFont(
                                            'Poppins',
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0x0026292D),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(25, 15, 25, 15),
                                        ),
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Embed Link (link the tile opens on click)',
                            style: GoogleFonts.getFont(
                              color: Colors.black,
                              'DM Sans',
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 0, 0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              child: TextFormField(
                                controller: text3,
                                onChanged: (val) {
                                  link1 = val;
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Put link here...',
                                  hintStyle: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Colors.black,
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
                                  fillColor: const Color(0x0026292D),
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          25, 15, 25, 15),
                                ),
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                maxLines: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    type == "Row of Two Items"
                        ? Flexible(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  60, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Embed Link #2',
                                    style: GoogleFonts.getFont(
                                      color: Colors.black,
                                      'DM Sans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.3,
                                      child: TextFormField(
                                        controller: text4,
                                        onChanged: (val) {
                                          link2 = val;
                                          setState(() {});
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Put link here...',
                                          hintStyle: GoogleFonts.getFont(
                                            'Poppins',
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0x0026292D),
                                          contentPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(25, 15, 25, 15),
                                        ),
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Color Select (background of tile)',
                            style: GoogleFonts.getFont(
                              color: Colors.black,
                              'DM Sans',
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 0, 0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0x0014181B),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          index1 = 1;
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF7CBB),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: index1 == 1
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          index1 = 2;
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCDEAD1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: index1 == 2
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          index1 = 3;
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF7F7F),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: index1 == 3
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          index1 = 4;
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFBF9B),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: index1 == 4
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          index1 = 5;
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD79B),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: index1 == 5
                                                ? Colors.black
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 8, 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            index1 = 6;
                                          });
                                        },
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFC791E8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: index1 == 6
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 8, 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            index1 = 7;
                                          });
                                        },
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBCD4E9),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: index1 == 7
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    type != "Long Single Item"
                        ? Flexible(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  60, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Color Select #2',
                                    style: GoogleFonts.getFont(
                                      color: Colors.black,
                                      'DM Sans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.3,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Color(0x0014181B),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 1;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFF7CBB),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 1
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 2;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFCDEAD1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 2
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 3;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFF7F7F),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 3
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 4;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFBF9B),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 4
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 5;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFD79B),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 5
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 6;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFC791E8),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 6
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  index2 = 7;
                                                });
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFBCD4E9),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: index2 == 7
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    width: 2,
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
                          )
                        : const SizedBox(),
                  ],
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
                          'Preview',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              getPreviewWidget(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 15),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (type == 'Long Single Item') {
                          if (!await canLaunchUrl(Uri.parse(link1))) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text('The link provided is not valid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            if (name1 == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor:
                                          const Color.fromARGB(255, 43, 11, 11),
                                      content:
                                          Text('The display name is blank.',
                                              style: GoogleFonts.getFont(
                                                fontSize: 16,
                                                color: const Color(0xFFe9e9e9),
                                                'Poppins',
                                              ))));
                            } else {
                              tiles.add({
                                'name': name1,
                                'type': 'single',
                                'link': link1,
                                'img': index1.toString(),
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor:
                                          const Color.fromARGB(255, 11, 43, 31),
                                      content: Text('Tile Added!',
                                          style: GoogleFonts.getFont(
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            'Poppins',
                                          ))));
                              setState(() {
                                name1 = "";
                                index1 = 1;
                                index2 = 1;
                                name2 = "";
                                link1 = "";
                                link2 = "";
                                text1!.text = "";
                                text2!.text = "";
                                text3!.text = "";
                                text4!.text = "";
                              });
                            }
                          }
                        } else {
                          if (!await canLaunchUrl(Uri.parse(link1)) ||
                              !await canLaunchUrl(Uri.parse(link2))) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text(
                                    'One of the links provided are not valid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            if (name1 == "" || name2 == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor:
                                          const Color.fromARGB(255, 43, 11, 11),
                                      content: Text(
                                          'One of the display names are blank.',
                                          style: GoogleFonts.getFont(
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            'Poppins',
                                          ))));
                            } else {
                              tiles.add({
                                'name1': name1,
                                'type': 'row',
                                'link1': link1,
                                'name2': name2,
                                'link2': link2,
                                'img1': index1.toString(),
                                'img2': index2.toString(),
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 1),
                                      backgroundColor:
                                          const Color.fromARGB(255, 11, 43, 31),
                                      content: Text('Tile Added!',
                                          style: GoogleFonts.getFont(
                                            fontSize: 16,
                                            color: const Color(0xFFe9e9e9),
                                            'Poppins',
                                          ))));
                              setState(() {
                                text1!.text = "";
                                text2!.text = "";
                                text3!.text = "";
                                text4!.text = "";
                                name1 = "";
                                index1 = 1;
                                index2 = 1;
                                name2 = "";
                                link1 = "";
                                link2 = "";
                              });
                            }
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0x00202225),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
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
                              const Icon(
                                Icons.add_circle,
                                color: Colors.black,
                                size: 28,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 15, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Add',
                                      style: GoogleFonts.getFont(
                                        'Poppins',
                                        color: Colors.black,
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Adjust Existing Tiles',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                          'A more accurate visual can be seen in the actual app on the bottom of the Home page.',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 3, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'The Conference Maps, and About this Conference tiles cannot be moved.',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                  padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 165.75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE5F9),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      'Building\nMaps',
                                      style: GoogleFonts.getFont(
                                        'Poppins',
                                        color: const Color(0xFF8A00DE),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF8A00DE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 165.75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEEFD),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  18, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      'About This\nConference',
                                      style: GoogleFonts.getFont(
                                        'Poppins',
                                        color: const Color(0xFF0081F4),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0081F4),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ])),
              for (Widget item in getTileWidgets()) (item),
              const SizedBox(height: 100),
            ],
          ),
        ));
  }

  List<Widget> getTileWidgets() {
    List<Widget> items = [];
    for (int i = 0; i < tiles.length; i++) {
      Map<String, String> tile = tiles[i];
      if (tile['type'] == 'row') {
        Color c;
        Color c2;
        Color c3;
        Color c4;
        switch (int.parse(tile['img1']!)) {
          case 1:
            c = const Color(0xFF89345D);
            c2 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c = const Color(0xFF07946A);
            c2 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c = const Color(0xFFFF5959);
            c2 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c = const Color(0xFFFB8700);
            c2 = const Color(0xFFFCECD9);
            break;
          case 5:
            c = const Color(0xFFCD7C02);
            c2 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c = const Color(0xFF8A00DE);
            c2 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c = const Color(0xFF0081F4);
            c2 = const Color(0xFFDDEEFD);
            break;
          default:
            c = const Color(0xFF000000);
            c2 = const Color(0xFFFFFFFF);
        }

        switch (int.parse(tile['img2']!)) {
          case 1:
            c3 = const Color(0xFF89345D);
            c4 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c3 = const Color(0xFF07946A);
            c4 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c3 = const Color(0xFFFF5959);
            c4 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c3 = const Color(0xFFFB8700);
            c4 = const Color(0xFFFCECD9);
            break;
          case 5:
            c3 = const Color(0xFFCD7C02);
            c4 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c3 = const Color(0xFF8A00DE);
            c4 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c3 = const Color(0xFF0081F4);
            c4 = const Color(0xFFDDEEFD);
            break;
          default:
            c3 = const Color(0xFF000000);
            c4 = const Color(0xFFFFFFFF);
        }

        items.add(
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(tile['link1']!))) {
                      await launchUrl(Uri.parse(tile['link1']!),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Container(
                    width: 165.75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: c2,
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              18, 0, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  tile['name1']!,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: c,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                  child: InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(tile['link2']!))) {
                        await launchUrl(Uri.parse(tile['link2']!),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      width: 165.75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: c4,
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                18, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    tile['name2']!,
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: c3,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: c3,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                      size: 24,
                                    ),
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      if (i == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                const Color.fromARGB(255, 43, 11, 11),
                            content: Text('Cannot move the top tile up.',
                                style: GoogleFonts.getFont(
                                  fontSize: 16,
                                  color: const Color(0xFFe9e9e9),
                                  'Poppins',
                                ))));
                      } else {
                        Map<String, String> temp = tiles[i - 1];
                        tiles[i - 1] = tiles[i];
                        tiles[i] = temp;
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF011B31),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      if (i == tiles.length - 1) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                const Color.fromARGB(255, 43, 11, 11),
                            content: Text('Cannot move the bottom tile down.',
                                style: GoogleFonts.getFont(
                                  fontSize: 16,
                                  color: const Color(0xFFe9e9e9),
                                  'Poppins',
                                ))));
                      } else {
                        Map<String, String> temp = tiles[i + 1];
                        tiles[i + 1] = tiles[i];
                        tiles[i] = temp;
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF011B31),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      tiles.removeAt(i);
                      setState(() {});
                    },
                    child: Container(
                      width: 36,
                      height: 36,
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
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        Color c;
        Color c2;
        switch (int.parse(tile['img']!)) {
          case 1:
            c = const Color(0xFF89345D);
            c2 = const Color(0xFFE9C3D5);
            break;
          case 2:
            c = const Color(0xFF07946A);
            c2 = const Color(0xFFC4E6C6);
            break;
          case 3:
            c = const Color(0xFFFF5959);
            c2 = const Color(0xFFFFD8D8);
            break;
          case 4:
            c = const Color(0xFFFB8700);
            c2 = const Color(0xFFFCECD9);
            break;
          case 5:
            c = const Color(0xFFCD7C02);
            c2 = const Color(0xFFF8E4C6);
            break;
          case 6:
            c = const Color(0xFF8A00DE);
            c2 = const Color(0xFFEFE5F9);
            break;
          case 7:
            c = const Color(0xFF0081F4);
            c2 = const Color(0xFFDDEEFD);
            break;
          default:
            c = const Color(0xFF000000);
            c2 = const Color(0xFFFFFFFF);
        }

        items.add(Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              InkWell(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(tile['link']!))) {
                    await launchUrl(Uri.parse(tile['link1']!),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: 344.37,
                  height: 90,
                  decoration: BoxDecoration(
                    color: c2,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(18, 0, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                tile['name']!,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: c,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                child: InkWell(
                  onTap: () {
                    if (i == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                          backgroundColor:
                              const Color.fromARGB(255, 43, 11, 11),
                          content: Text('Cannot move the top tile up.',
                              style: GoogleFonts.getFont(
                                fontSize: 16,
                                color: const Color(0xFFe9e9e9),
                                'Poppins',
                              ))));
                    } else {
                      Map<String, String> temp = tiles[i - 1];
                      tiles[i - 1] = tiles[i];
                      tiles[i] = temp;
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF011B31),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                child: InkWell(
                  onTap: () {
                    if (i == tiles.length - 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                          backgroundColor:
                              const Color.fromARGB(255, 43, 11, 11),
                          content: Text('Cannot move the bottom tile down.',
                              style: GoogleFonts.getFont(
                                fontSize: 16,
                                color: const Color(0xFFe9e9e9),
                                'Poppins',
                              ))));
                    } else {
                      Map<String, String> temp = tiles[i + 1];
                      tiles[i + 1] = tiles[i];
                      tiles[i] = temp;
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF011B31),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                child: InkWell(
                  onTap: () {
                    tiles.removeAt(i);
                    setState(() {});
                  },
                  child: Container(
                    width: 36,
                    height: 36,
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
                      size: 22,
                    ),
                  ),
                ),
              ),
            ])));
      }
    }
    return items;
  }

  Widget getPreviewWidget() {
    if (type == "Long Single Item") {
      Color c;
      Color c2;

      switch (index1) {
        case 1:
          c = const Color(0xFF89345D);
          c2 = const Color(0xFFE9C3D5);
          break;
        case 2:
          c = const Color(0xFF07946A);
          c2 = const Color(0xFFC4E6C6);
          break;
        case 3:
          c = const Color(0xFFFF5959);
          c2 = const Color(0xFFFFD8D8);
          break;
        case 4:
          c = const Color(0xFFFB8700);
          c2 = const Color(0xFFFCECD9);
          break;
        case 5:
          c = const Color(0xFFCD7C02);
          c2 = const Color(0xFFF8E4C6);
          break;
        case 6:
          c = const Color(0xFF8A00DE);
          c2 = const Color(0xFFEFE5F9);
          break;
        case 7:
          c = const Color(0xFF0081F4);
          c2 = const Color(0xFFDDEEFD);
          break;
        default:
          c = const Color(0xFF000000);
          c2 = const Color(0xFFFFFFFF);
      }

      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(link1))) {
                  await launchUrl(Uri.parse(link1),
                      mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: 344.37,
                height: 90,
                decoration: BoxDecoration(
                  color: c2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              maxLines: 2,
                              name1 == "" ? '[Name]' : name1,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: c,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 0.95,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Color c;
      Color c2;
      Color c3;
      Color c4;
      switch (index1) {
        case 1:
          c = const Color(0xFF89345D);
          c2 = const Color(0xFFE9C3D5);
          break;
        case 2:
          c = const Color(0xFF07946A);
          c2 = const Color(0xFFC4E6C6);
          break;
        case 3:
          c = const Color(0xFFFF5959);
          c2 = const Color(0xFFFFD8D8);
          break;
        case 4:
          c = const Color(0xFFFB8700);
          c2 = const Color(0xFFFCECD9);
          break;
        case 5:
          c = const Color(0xFFCD7C02);
          c2 = const Color(0xFFF8E4C6);
          break;
        case 6:
          c = const Color(0xFF8A00DE);
          c2 = const Color(0xFFEFE5F9);
          break;
        case 7:
          c = const Color(0xFF0081F4);
          c2 = const Color(0xFFDDEEFD);
          break;
        default:
          c = const Color(0xFF000000);
          c2 = const Color(0xFFFFFFFF);
      }

      switch (index2) {
        case 1:
          c3 = const Color(0xFF89345D);
          c4 = const Color(0xFFE9C3D5);
          break;
        case 2:
          c3 = const Color(0xFF07946A);
          c4 = const Color(0xFFC4E6C6);
          break;
        case 3:
          c3 = const Color(0xFFFF5959);
          c4 = const Color(0xFFFFD8D8);
          break;
        case 4:
          c3 = const Color(0xFFFB8700);
          c4 = const Color(0xFFFCECD9);
          break;
        case 5:
          c3 = const Color(0xFFCD7C02);
          c4 = const Color(0xFFF8E4C6);
          break;
        case 6:
          c3 = const Color(0xFF8A00DE);
          c4 = const Color(0xFFEFE5F9);
          break;
        case 7:
          c3 = const Color(0xFF0081F4);
          c4 = const Color(0xFFDDEEFD);
          break;
        default:
          c3 = const Color(0xFF000000);
          c4 = const Color(0xFFFFFFFF);
      }

      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(link1))) {
                  await launchUrl(Uri.parse(link1),
                      mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: 165.75,
                height: 75,
                decoration: BoxDecoration(
                  color: c2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 0, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              maxLines: 2,
                              name1 == "" ? "[Name]" : name1,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: c,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 0.95,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
              child: InkWell(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(link2))) {
                    await launchUrl(Uri.parse(link2),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: 165.75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: c4,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(18, 0, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                maxLines: 2,
                                name2 == "" ? "[Name]" : name2,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  color: c3,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 0.95,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: c3,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 24,
                                ),
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
      );
    }
  }
}
