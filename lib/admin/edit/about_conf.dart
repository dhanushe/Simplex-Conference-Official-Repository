// ignore_for_file: must_be_immutable, use_build_context_synchronously, no_logic_in_create_state

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/logic/API.dart';
import '../../api/app_info.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutConfPage extends StatefulWidget {
  const AboutConfPage({
    super.key,
  });

  @override
  State<AboutConfPage> createState() => _AboutConfPageState();
}

class _AboutConfPageState extends State<AboutConfPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _AboutConfPageState();
  String bpLink = "";
  String longDesc = AppInfo.conference.longDesc;
  Map<String, String> socialItems = AppInfo.conference.social;
  String aboutLink = AppInfo.conference.aboutLink;
  String ig = AppInfo.conference.social.containsKey('instagram')
      ? AppInfo.conference.social['instagram']!
      : "";
  String fb = AppInfo.conference.social.containsKey('facebook')
      ? AppInfo.conference.social['facebook']!
      : "";
  String web = AppInfo.conference.social.containsKey('website')
      ? AppInfo.conference.social['website']!
      : "";
  String ln = AppInfo.conference.social.containsKey('linkedin')
      ? AppInfo.conference.social['linkedin']!
      : "";
  String twt = AppInfo.conference.social.containsKey('twitter')
      ? AppInfo.conference.social['twitter']!
      : "";
  TextEditingController? text1;
  TextEditingController? text2;
  TextEditingController? text3;
  TextEditingController? text4;
  TextEditingController? text5;
  TextEditingController? text6;
  TextEditingController? text7;

  bool uploading = false;
  bool saving = false;

  @override
  void initState() {
    bpLink = AppInfo.conference.bpLink;
    text1 = TextEditingController(text: AppInfo.conference.longDesc);
    text2 = TextEditingController(text: AppInfo.conference.aboutLink);
    text3 = TextEditingController(text: ig);
    text4 = TextEditingController(text: fb);
    text5 = TextEditingController(text: ln);
    text6 = TextEditingController(text: twt);

    text7 = TextEditingController(text: web);

    super.initState();
  }

  save() async {
    if (!saving) {
      setState(() {
        saving = true;
      });
      if (aboutLink != "" && !await canLaunchUrl(Uri.parse(aboutLink))) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: const Color.fromARGB(255, 43, 11, 11),
            content: Text('About link is invalid.',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {
          saving = false;
        });
      } else {
        await API().updateAboutConference(
          AppInfo.conference.id,
          longDesc,
          bpLink,
          aboutLink,
          socialItems,
        );
        AppInfo.conference = await API().getConference(AppInfo.conference.id);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text(
                'Changes Saved! Refresh the app and look at the \'About this Conference\' Page to view changes.',
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
  }

  discard() {
    setState(() {
      text1!.text = AppInfo.conference.longDesc;
      text2!.text = AppInfo.conference.aboutLink;
      text3!.text = ig;
      text4!.text = fb;
      text5!.text = ln;
      text6!.text = twt;
      text7!.text = web;
    });
  }

  @override
  void dispose() {
    text1!.dispose();
    text2!.dispose();
    text3!.dispose();
    text4!.dispose();
    text5!.dispose();
    text6!.dispose();
    text7!.dispose();
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
        child: // Generated code for this Column Widget...
            // Generated code for this Column Widget...
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
                                'More Settings',
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300)),
                                )),
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Edit Conference About Section',
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Long Description (Shown on the About This Conference page)',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.635,
                        child: TextFormField(
                          onChanged: (val) {
                            longDesc = val;
                          },
                          controller: text1,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 5, 10),
                              border:
                                  MaterialStateOutlineInputBorder.resolveWith(
                                      (states) {
                                return OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey.shade300));
                              }),
                              hintText: 'Enter a Description',
                              helperMaxLines: 10,
                              helperStyle: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15),
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w200)),
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 20, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Blue Pandas PDF (shown in Competitive Events)',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                            ),
                            bpLink != ""
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 15, 0),
                                    child: InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(bpLink))) {
                                          await launchUrl(Uri.parse(bpLink),
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
                                            style: GoogleFonts.getFont(
                                              'DM Sans',
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
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
                                          style: GoogleFonts.getFont(
                                            'DM Sans',
                                            color: Colors.white,
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
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Social Media Links (links MUST be saved using the small save icon before being added)',
                          style: GoogleFonts.getFont(
                            color: Colors.black,
                            'DM Sans',
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
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ColorFiltered(
                          colorFilter:
                              // ignore: prefer_const_constructors
                              ColorFilter.mode(
                                  const Color(0xFF000000), BlendMode.srcIn),
                          child: Image.asset(
                            'assets/images/igicon.png',
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        child: TextFormField(
                          onChanged: (val) {
                            ig = val;
                          },
                          controller: text3,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 5, 10),
                              border:
                                  MaterialStateOutlineInputBorder.resolveWith(
                                      (states) {
                                return OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey.shade300));
                              }),
                              hintText: 'Enter a Link',
                              helperMaxLines: 10,
                              helperStyle: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15),
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w200)),
                          style: GoogleFonts.getFont(
                            'Poppins',
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(ig))) {
                            socialItems['instagram'] = ig;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 43, 31),
                                content: Text('Instagram link saved!',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text('The Instagram link is invalid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          if (socialItems.containsKey('instagram')) {
                            socialItems.remove('instagram');
                          }
                          setState(() {
                            ig = "";
                            text3!.text = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content: Text('Instagram link removed.',
                                  style: GoogleFonts.getFont(
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    'Poppins',
                                  ))));
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF310801),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ColorFiltered(
                          colorFilter:
                              // ignore: prefer_const_constructors
                              ColorFilter.mode(
                                  const Color(0xFF000000), BlendMode.srcIn),
                          child: Image.asset(
                            'assets/images/fbicon.png',
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: TextFormField(
                        onChanged: (val) {
                          fb = val;
                        },
                        controller: text4,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 5, 10),
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                (states) {
                              return OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade300));
                            }),
                            hintText: 'Enter a Link',
                            helperMaxLines: 10,
                            helperStyle: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w200)),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(fb))) {
                            socialItems['facebook'] = fb;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 43, 31),
                                content: Text('Facebook link saved!',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text('The Facebook link is invalid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          if (socialItems.containsKey('facebook')) {
                            socialItems.remove('facebook');
                          }
                          setState(() {
                            fb = "";
                            text4!.text = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content: Text('Facebook link removed.',
                                  style: GoogleFonts.getFont(
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    'Poppins',
                                  ))));
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF310801),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ColorFiltered(
                          colorFilter:
                              // ignore: prefer_const_constructors
                              ColorFilter.mode(
                                  const Color(0xFF000000), BlendMode.srcIn),
                          child: Image.asset(
                            'assets/images/linkedicon.png',
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: TextFormField(
                        onChanged: (val) {
                          ln = val;
                        },
                        controller: text5,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 5, 10),
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                (states) {
                              return OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade300));
                            }),
                            hintText: 'Enter a Link',
                            helperMaxLines: 10,
                            helperStyle: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w200)),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(ln))) {
                            socialItems['linkedin'] = ln;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 43, 31),
                                content: Text('LinkedIn link saved!',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text('The LinkedIn link is invalid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          if (socialItems.containsKey('linkedin')) {
                            socialItems.remove('linkedin');
                          }
                          setState(() {
                            ln = "";
                            text5!.text = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content: Text('LinkedIn link removed.',
                                  style: GoogleFonts.getFont(
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    'Poppins',
                                  ))));
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF310801),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ColorFiltered(
                          colorFilter:
                              // ignore: prefer_const_constructors
                              ColorFilter.mode(
                                  const Color(0xFF000000), BlendMode.srcIn),
                          child: Image.asset(
                            'assets/images/xicon.png',
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: TextFormField(
                        onChanged: (val) {
                          twt = val;
                        },
                        controller: text6,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 5, 10),
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                (states) {
                              return OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade300));
                            }),
                            hintText: 'Enter a Link',
                            helperMaxLines: 10,
                            helperStyle: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w200)),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(twt))) {
                            socialItems['twitter'] = twt;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 43, 31),
                                content:
                                    Text('X (formerly Twitter) link saved!',
                                        style: GoogleFonts.getFont(
                                          fontSize: 16,
                                          color: const Color(0xFFe9e9e9),
                                          'Poppins',
                                        ))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text(
                                    'The X (formerly Twitter) link is invalid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          if (socialItems.containsKey('twitter')) {
                            socialItems.remove('twitter');
                          }
                          setState(() {
                            twt = "";
                            text6!.text = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content:
                                  Text('X (formerly Twitter) link removed.',
                                      style: GoogleFonts.getFont(
                                        fontSize: 16,
                                        color: const Color(0xFFe9e9e9),
                                        'Poppins',
                                      ))));
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF310801),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(50, 10, 50, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ColorFiltered(
                          colorFilter:
                              // ignore: prefer_const_constructors
                              ColorFilter.mode(
                                  const Color(0xFF000000), BlendMode.srcIn),
                          child: Image.asset(
                            'assets/images/webicon.png',
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: TextFormField(
                        onChanged: (val) {
                          web = val;
                        },
                        controller: text7,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 5, 10),
                            border: MaterialStateOutlineInputBorder.resolveWith(
                                (states) {
                              return OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey.shade300));
                            }),
                            hintText: 'Enter a Link',
                            helperMaxLines: 10,
                            helperStyle: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w200)),
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(web))) {
                            socialItems['website'] = web;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 43, 31),
                                content: Text('Website link saved!',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 11, 11),
                                content: Text('The Website link is invalid.',
                                    style: GoogleFonts.getFont(
                                      fontSize: 16,
                                      color: const Color(0xFFe9e9e9),
                                      'Poppins',
                                    ))));
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF011B31),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          if (socialItems.containsKey('website')) {
                            socialItems.remove('website');
                          }
                          setState(() {
                            web = "";
                            text7!.text = "";
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 11, 11),
                              content: Text('Web link removed.',
                                  style: GoogleFonts.getFont(
                                    fontSize: 16,
                                    color: const Color(0xFFe9e9e9),
                                    'Poppins',
                                  ))));
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFF310801),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
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
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      if (kIsWeb) {
        Uint8List bytes = result.files.first.bytes!;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        fileName += ".pdf";

        firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName');
        firebase_storage.UploadTask uploadTask = storageRef.putData(bytes);
        firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrl += ".pdf";

        bpLink = imageUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('File Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
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
        bpLink = imageUrl;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 11, 43, 31),
            content: Text('File Uploaded!',
                style: GoogleFonts.getFont(
                  fontSize: 16,
                  color: const Color(0xFFe9e9e9),
                  'Poppins',
                ))));

        setState(() {});
      }
    }
  }
}
