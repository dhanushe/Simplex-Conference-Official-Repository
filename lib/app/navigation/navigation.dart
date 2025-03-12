// ignore_for_file: must_be_immutable, unused_element

import 'dart:async';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../api/app_info.dart';

import '../../api/objects/event_data.dart';
import '../../api/objects/workshop_data.dart';
import '../announcements/messages_page.dart';

import 'package:flutter/foundation.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:flutter/material.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../home/home_page.dart';
import '../browse/browse_page.dart';
import '../workshops/conf_agenda.dart';

class Navigation extends StatefulWidget {
  final int pIndex;
  bool reNav;

  Navigation({super.key, required this.pIndex, required this.reNav});

  @override
  // ignore: no_logic_in_create_state
  State<Navigation> createState() => _NavigationState(pIndex, reNav);
}

class _NavigationState extends State<Navigation> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _eventSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _workshopSubscription;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int pI;
  late bool reNav;
  late PageController pageController;

  _NavigationState(
    int pIndex,
    bool reNav2,
  ) {
    pI = pIndex;
    reNav = reNav2;
    pageController = PageController(initialPage: pI);

    // _setupEventListener();
    // _setupUserListener();
    // _setupWorkshopListener();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _userSubscription?.cancel();
    _workshopSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = 70.0;
    if (!kIsWeb && (!kIsWeb && Platform.isIOS)) {
      height += 15.0;
    }

    List<SalomonBottomBarItem> items = [
      SalomonBottomBarItem(
        selectedColor: const Color.fromARGB(255, 154, 172, 255),
        icon: pI != 0
            ? const Icon(
                Symbols.home,
                size: 24,
                color: Color(0xFF000000),
              )
            : const Icon(
                Symbols.home,
                fill: 1.0,
                size: 24,
                color: Color(0xFF000000),
              ),
        title: Text("Home",
            style: TextStyle(fontFamily: 'DM Sans',
              color: pI != 0 ? Colors.transparent : const Color(0xFF000000),
              
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      ),
      SalomonBottomBarItem(
        selectedColor: const Color.fromARGB(255, 154, 172, 255),
        icon: pI != 1
            ? const Icon(
                Symbols.notifications,
                size: 24,
                color: Color(0xFF000000),
              )
            : const Icon(
                Symbols.notifications,
                color: Color(0xFF000000),
                fill: 1.0,
                size: 24,
              ),
        title: Text("Announcements",
            style: TextStyle(fontFamily: 'DM Sans',
              color: pI != 1 ? Colors.transparent : const Color(0xFF000000),
              
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      ),
      SalomonBottomBarItem(
        selectedColor: const Color.fromARGB(255, 154, 172, 255),
        icon: pI != 2
            ? const Icon(
                Symbols.trophy,
                size: 24,
                color: Color(0xFF000000),
              )
            : const Icon(
                Symbols.trophy,
                color: Color(0xFF000000),
                fill: 1.0,
                size: 24,
              ),
        title: Text("Events",
            style: TextStyle(fontFamily: 'DM Sans',
              color: pI != 2 ? Colors.transparent : const Color(0xFF000000),
              
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      ),
      SalomonBottomBarItem(
        selectedColor: const Color.fromARGB(255, 154, 172, 255),
        icon: pI != 3
            ? const Icon(
                Symbols.calendar_month,
                size: 24,
                color: Color(0xFF000000),
              )
            : const Icon(
                Symbols.calendar_month,
                color: Color(0xFF000000),
                fill: 1.0,
                size: 24,
              ),
        title: Text("Agenda",
            style: TextStyle(fontFamily: 'DM Sans',
              color: pI != 3 ? Colors.transparent : const Color(0xFF000000),
              
              fontWeight: FontWeight.w400,
              fontSize: 13,
            )),
      ),
    ];

    // if (AppInfo.currentConferenceUser.isAdmin) {
    //   items.add(
    //     SalomonBottomBarItem(
    //       selectedColor: const Color.fromARGB(255, 154, 172, 255),
    //       icon: pI != 4
    //           ? const Icon(
    //               Symbols.add_circle,
    //               color: Color(0xFFf6f6f6),
    //               size: 24,
    //             )
    //           : const Icon(
    //               Symbols.add_circle,
    //               color: Color(0xFFf6f6f6),
    //               fill: 1.0,
    //               size: 24,
    //             ),
    //       title: Text("Create",
    //           style: TextStyle(
    //               color: pI != 4 ? Colors.transparent : const Color(0xFFf6f6f6),
    //               fontFamily: 'SFPro',
    //               fontWeight: FontWeight.w400)),
    //     ),
    //   );
    // }

    List<Widget> pages = [
      const HomePage(),
      const MessagesPage(),
      const BrowsePage(),
      const ConfAgendaPage(),
    ];

    // if (AppInfo.currentConferenceUser.isAdmin) {
    //   pages.add(
    //     CreateItemPage(type: 'Announcement'),
    //   );
    // }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          for (Widget item in pages) (item),
        ],
      ),
      bottomNavigationBar: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Color(0xFFffffff),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Color(0x06000000),
                offset: Offset(0, -4),
                spreadRadius: 2,
                blurRadius: 4),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: SalomonBottomBar(
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            currentIndex: pI,
            onTap: (i) {
              pI = i;
              pageController.jumpToPage(i);
              setState(() {});
            },
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: const Color.fromARGB(255, 159, 159, 159),
            items: items,
          ),
        ),
      ),
    );
  }

  void setPageIndex(int i) {
    pI = i;
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        pageController.jumpToPage(i);
        setState(() {});
      },
    );
  }

  void _setupEventListener() {
    _eventSubscription = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('events')
        .snapshots()
        .listen((documentSnapshot) {
      List<EventData> currentEvents = [];
      for (QueryDocumentSnapshot d in documentSnapshot.docs) {
        Map<String, dynamic> firestoreMap =
            d['competitors'] as Map<String, dynamic>;

        // Convert the dynamic values to List<String> and create a Map<String, List<String>>
        Map<String, List<String>> flutterMap = firestoreMap.map((key, value) {
          return MapEntry(key,
              (value as List<dynamic>).map((item) => item.toString()).toList());
        });
        currentEvents.add(EventData(
            id: d.id,
            type: d.get('type') as String,
            name: d.get('name') as String,
            color: d.get('color') as String,
            competitors: flutterMap,
            date: d.get('date') as String,
            times: d.get('times') as String,
            round: d.get('round') as String));
      }
      AppInfo.allEvents = currentEvents;
      if (reNav) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation(
                    pIndex: pI,
                    reNav: false,
                  )),
          (route) => false, // This condition removes all previous routes
        );

        Fluttertoast.showToast(
          msg: "Event data updated - refreshed current page!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {});
      }
    });
  }

  void _setupWorkshopListener() {
    _workshopSubscription = FirebaseFirestore.instance
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('workshops')
        .snapshots()
        .listen((documentSnapshot) {
      List<WorkshopData> currentEvents = [];
      for (QueryDocumentSnapshot d in documentSnapshot.docs) {
        List<Map<String, String>> tileList = [];
        // Because of Firebase's API with typing, the List of maps must be cast
        // to a dynamic typing.
        List<dynamic> tileList2 = (d.get('sessions') as List).cast<dynamic>();
        // By iterating through each key, the dynamic type is converted to a
        // map of String keys and values
        for (int i = 0; i < tileList2.length; i++) {
          dynamic item = tileList2[i];
          Map<String, String> a = {};
          Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
          map.forEach((key, value) {
            a[key.toString()] = value.toString();
          });

          tileList.add(a);
        }
        currentEvents.add(WorkshopData(
          sessions: tileList,
          id: d.id,
          sessionId: d.get('sessionId') as String,
          type: d.get('type') as String,
          tag: d.get('tag') as String,
          name: d.get('name') as String,
          location: d.get('location') as String,
          desc: d.get('desc') as String,
          date: d.get('date') as String,
          startTime: d.get('startTime') as String,
          endTime: d.get('endTime') as String,
        ));
      }
      AppInfo.currentWorkshops = currentEvents;
      if (reNav) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation(
                    pIndex: pI,
                    reNav: false,
                  )),
          (route) => false, // This condition removes all previous routes
        );

        Fluttertoast.showToast(
          msg: "Agenda data updated - refreshed current page!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {});
      }
    });
  }

  // void _setupUserListener() {
  //   _userSubscription = FirebaseFirestore.instance
  //       .collection('conferences')
  //       .doc(AppInfo.conference.id)
  //       .collection('users')
  //       .doc(AppInfo.currentConferenceUser.id)
  //       .snapshots()
  //       .listen((documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       User? user = FirebaseAuth.instance.currentUser;
  //       AppInfo.currentConferenceUser = ConferenceUserData(
  //         email: user!.email!,
  //         name: documentSnapshot.get('name') as String,
  //         isAdmin: documentSnapshot.get('isAdmin') as bool,
  //         id: user.uid,
  //         events: (documentSnapshot.get('events') as List).cast<String>(),
  //       );
  //       if (reNav) {
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Navigation(
  //                     pIndex: pI,
  //                     reNav: false,
  //                   )),
  //           (route) => false, // This condition removes all previous routes
  //         );

  //         Fluttertoast.showToast(
  //           msg: "User data updated - refreshed current page!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //         setState(() {});
  //       }
  //     }
  //   });
  // }
}
