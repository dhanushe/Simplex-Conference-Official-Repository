// ignore_for_file: use_build_context_synchronously

import 'conf_map.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/app_info.dart';
import '../../api/logic/API.dart';
import '../navigation/navigation.dart';
import 'package:flutter/material.dart';

class AboutConferencePage extends StatefulWidget {
  const AboutConferencePage({super.key});

  @override
  State<AboutConferencePage> createState() => _AboutConferencePageState();
}

class _AboutConferencePageState extends State<AboutConferencePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    API.setLight();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> socialIcons = [];
    if (AppInfo.conference.social.containsKey('facebook')) {
      socialIcons.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
          child: InkWell(
            onTap: () async {
              _confirmOpenLinkDialog(
                  context, AppInfo.conference.social['facebook']!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: ColorFiltered(
                colorFilter:
                    // ignore: prefer_const_constructors
                    ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/fbicon.png',
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (AppInfo.conference.social.containsKey('instagram')) {
      socialIcons.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
          child: InkWell(
            onTap: () async {
              _confirmOpenLinkDialog(
                  context, AppInfo.conference.social['instagram']!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/igicon.png',
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (AppInfo.conference.social.containsKey('linkedin')) {
      socialIcons.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
          child: InkWell(
            onTap: () async {
              _confirmOpenLinkDialog(
                  context, AppInfo.conference.social['linkedin']!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/linkedicon.png',
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (AppInfo.conference.social.containsKey('twitter')) {
      socialIcons.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
          child: InkWell(
            onTap: () async {
              _confirmOpenLinkDialog(
                  context, AppInfo.conference.social['twitter']!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/xicon.png',
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (AppInfo.conference.social.containsKey('website')) {
      socialIcons.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
          child: InkWell(
            onTap: () async {
              _confirmOpenLinkDialog(
                  context, AppInfo.conference.social['website']!);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/webicon.png',
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFFBFBFB),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (b, d) {
            // Handle back button press here
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                reverseTransitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Navigation(
                  pIndex: 0,
                  reNav: false,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
              (route) => false, // This condition removes all previous routes
            );

            // Return true to allow the back navigation, or false to block it
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height * 1,
            ),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 186,
                    child: Stack(
                      alignment: const AlignmentDirectional(0, -1),
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 186,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                        Opacity(
                          opacity: 0.2,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 186,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset(
                                  'assets/images/homebg.png',
                                ).image,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 65, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            25, 8, 25, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            reverseTransitionDuration:
                                                const Duration(
                                                    milliseconds: 200),
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                Navigation(
                                              pIndex: 0,
                                              reNav: false,
                                            ),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(-1.0, 0.0);
                                              const end = Offset.zero;
                                              final tween =
                                                  Tween(begin: begin, end: end);
                                              final offsetAnimation =
                                                  animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                          (route) =>
                                              false, // This condition removes all previous routes
                                        );
                                      },
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Color(0xC7FFFFFF),
                                            size: 17,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    6, 0, 0, 0),
                                            child: Text(
                                              'Home',
                                              style: TextStyle(
                                                fontFamily: 'RedHatDisplay',
                                                color: Color(0xC5FFFFFF),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        25, 12, 25, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'About this Conference',
                                          style: TextStyle(
                                            fontFamily: 'RedHatDisplay',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 60),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                    fontFamily: 'RedHatDisplay',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 9, 25, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  AppInfo.conference.longDesc,
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppInfo.conference.specificLoc != ""
                            ? const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    25, 15, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Specific Location',
                                        style: TextStyle(
                                          fontFamily: 'RedHatDisplay',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 26,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        // AppInfo.conference.specificLoc != ""
                        //     ? Padding(
                        //         padding: const EdgeInsetsDirectional.fromSTEB(
                        //             25, 9, 25, 0),
                        //         child: SizedBox(
                        //             width:
                        //                 MediaQuery.sizeOf(context).width * 0.88,
                        //             height: 200,
                        //             child: const MapScreen()),
                        //       )
                        //     : const SizedBox(),
                        AppInfo.conference.specificLoc != ""
                            ? Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    25, 3, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        AppInfo.conference.specificLoc,
                                        style: const TextStyle(
                                          fontFamily: 'DM Sans',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        // const Padding(
                        //   padding:
                        //       EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Flexible(
                        //         child: Text(
                        //           'SielifyAR',
                        //           style: TextStyle(
                        //             fontFamily: 'RedHatDisplay',
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 26,
                        //             height: 1.1,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // Platform.isIOS
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         mainAxisSize: MainAxisSize.max,
                        //         children: [
                        //             InkWell(
                        //               onTap: () async {
                        //                 await LaunchApp.openApp(
                        //                   iosUrlScheme: 'SelifyARExperience://',
                        //                 );
                        //               },
                        //               child: Container(
                        //                   width: 300,
                        //                   height: 48,
                        //                   decoration: BoxDecoration(
                        //                       border: Border.all(
                        //                         color: Colors.black,
                        //                         width: 2.0,
                        //                       ),
                        //                       borderRadius:
                        //                           BorderRadius.circular(40)),
                        //                   child: Align(
                        //                       alignment: Alignment.center,
                        //                       child: Text('Open SielifyAR',
                        //                           style: TextStyle(
                        //                               fontFamily: 
                        //                               color: Colors.black)))),
                        //             ),
                        //           ])
                        //     : SizedBox(),
                        const Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(25, 20, 25, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Follow Us',
                                  style: TextStyle(
                                    fontFamily: 'RedHatDisplay',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              25, 12, 25, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: socialIcons,
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _confirmOpenLinkDialog(BuildContext context, String s) async {
    bool okPressed = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFBFBFB),
            title: const Text(
              'Hey!',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0),
                fontFamily: 'RedHatDisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You are being directed to an external third-party application by opening this link. Simplex bears no responsibility for any violations on third-party platforms.\n\nLink: $s',
                      style: TextStyle(fontFamily: 'DM Sans',
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 2,
                      backgroundColor: const Color.fromARGB(255, 186, 186, 186),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(fontFamily: 'DM Sans',
                            color: Colors.black, )),
                    onPressed: () {
                      setState(() {
                        okPressed = true;
                        Navigator.pop(context);
                      });
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 2,
                      backgroundColor: const Color.fromARGB(255, 164, 151, 255),
                    ),
                    child: Text('Open',
                        style: TextStyle(fontFamily: 'DM Sans',
                            color: Colors.black, )),
                    onPressed: () async {
                      var uri = Uri.parse(s);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        }).then((val) async {
      if (!okPressed) {
        return;
      }

      setState(() {});
    });
  }
}
