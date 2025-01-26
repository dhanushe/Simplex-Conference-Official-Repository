// ignore_for_file: no_logic_in_create_state, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:simplex_conference_redo_repo/admin/announcements/announcements_page.dart';
import 'package:simplex_conference_redo_repo/admin/edit/about_conf.dart';
import 'package:simplex_conference_redo_repo/admin/edit/conf_map.dart';
import 'package:simplex_conference_redo_repo/admin/edit/edit_conf.dart';
import 'package:simplex_conference_redo_repo/admin/edit/tile_edit.dart';
import 'package:simplex_conference_redo_repo/admin/events/add_events.dart';
import 'package:simplex_conference_redo_repo/admin/events/add_workshops.dart';
import 'package:simplex_conference_redo_repo/admin/login/login_page.dart';
import 'package:simplex_conference_redo_repo/api/logic/authentication.dart';

import '../../api/app_info.dart';

import 'dashboard.dart';

class HomePageAdmin extends StatefulWidget {
  int pIndex;
  HomePageAdmin({super.key, required this.pIndex});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState(pIndex);
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int pIndex = 0;
  _HomePageAdminState(this.pIndex);
  bool refreshing = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = getPages();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF3F3F4),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width / 8,
          height: MediaQuery.of(context).size.height / 10,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            // mainAxisSize: MainAxisSize.max,
            alignment: Alignment.topLeft,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width * 0.2),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      child: SingleChildScrollView(
                          primary: false,
                          child: Column(children: [pages[pIndex]])))),
              Material(
                elevation: 1,
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/appicondisplay.png',
                                  height: 24),
                              const SizedBox(width: 7),
                              const Text(
                                'Sielify Admin',
                                style: TextStyle(fontSize: 24),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Material(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          color: const Color.fromARGB(255, 30, 7, 95),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: SizedBox(
                              width: 800,
                              // height: 100,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'CONFERENCE DASHBOARD',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          AppInfo.conference.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: TextButton(
                                            style: const ButtonStyle(
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)))),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Color.fromARGB(255, 115,
                                                            57, 237))),
                                            child: const Text('Log Out',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () async {
                                              await Authentication.signOut(
                                                  context: context);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                  (route) => false);
                                            }),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ]),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                            pIndex: pIndex,
                            updateIndex: updateIndex,
                            myIndex: 0,
                            icon: const Icon(Icons.home, size: 30),
                            label: 'Home',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 1,
                              icon: const Icon(Icons.settings, size: 30),
                              label: 'Conference Settings'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 2,
                              icon: const Icon(Icons.edit, size: 30),
                              label: 'More Settings'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              icon: const Icon(Icons.map, size: 30),
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 3,
                              label: 'Maps'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              icon: const Icon(Icons.notifications, size: 30),
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 4,
                              label: 'Announcements'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              icon: const Icon(Icons.grid_view_outlined,
                                  size: 30),
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 5,
                              label: 'Tiles'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              icon: const Icon(Icons.star_border, size: 30),
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 6,
                              label: 'Competitive Events'),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PageButton(
                              icon: const Icon(Icons.event, size: 30),
                              pIndex: pIndex,
                              updateIndex: updateIndex,
                              myIndex: 7,
                              label: 'Agenda Items'),
                        ),
                        const SizedBox(height: 10),
                        const Divider()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getPages() {
    return [
      DashboardPage(updateIndex: updateIndex), // 0

      ConferenceSettingsPage(updateIndex: updateIndex), // 1
      const AboutConfPage(), //2
      const ConfMapPage(), // 3
      const AdminAnnouncements(), // 4
      const TileEditPage(), // 5
      const AddEventsAdmin(), // 6
      const AddWorkshopsAdmin(), // 7
    ];
  }

  void updateMainPage() {
    setState(() {});
  }

  void updateIndex(int index) {
    setState(() {
      pIndex = index;
    });
  }
}

class PageButton extends StatelessWidget {
  int pIndex;
  void Function(int index) updateIndex;
  int myIndex;
  Icon icon;
  String label;
  PageButton(
      {super.key,
      required this.pIndex,
      required this.updateIndex,
      required this.myIndex,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.selected) ||
                pIndex == myIndex) {
              return const Color.fromARGB(255, 115, 57, 237);
            } else {
              return Colors.grey;
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.selected) ||
                pIndex == myIndex) {
              return const TextStyle(
                  color: Color.fromARGB(255, 115, 57, 237),
                  fontWeight: FontWeight.bold,
                  fontSize: 20);
            } else {
              return const TextStyle(color: Colors.grey, fontSize: 20);
            }
          })),
      onPressed: () => updateIndex(myIndex),
      icon: icon,
      label: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
    );
  }
}
