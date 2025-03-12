// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:intl/intl.dart';

import '../../api/app_info.dart';
import '../../api/logic/dates.dart';

class DashboardPage extends StatefulWidget {
  void Function(int) updateIndex;
  DashboardPage({super.key, required this.updateIndex});

  @override
  State<DashboardPage> createState() => _DashboardPageState(updateIndex);
}

class _DashboardPageState extends State<DashboardPage> {
  late void Function(int) updateIndex;
  _DashboardPageState(this.updateIndex);
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool hoveringAnnouncements = false;
  bool hoveringEvents = false;
  bool hoveringEdit = false;
  bool hoveringTickets = false;

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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 50, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Upcoming Event',
                    style: TextStyle(fontFamily: 'DM Sans',
                      color: Colors.black,
                      
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
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
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Container(
                                height: 115,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: Image.asset(
                                      'assets/images/dashboardbg.png',
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                color: const Color(0x00FEE4E4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    30, 0, 30, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        AppInfo.conference.startDate !=
                                                AppInfo.conference.endDate
                                            ? RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${Dates.getMonth(AppInfo.conference.startDate)}\n',
                                                      style:
                                                          TextStyle(fontFamily: 'DM Sans',
                                                        
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: Dates.getDay(AppInfo
                                                          .conference
                                                          .startDate),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
                                                      ),
                                                    )
                                                  ],
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : const SizedBox(),
                                        AppInfo.conference.startDate !=
                                                AppInfo.conference.endDate
                                            ? const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 12, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                      child: Divider(
                                                        thickness: 2,
                                                        color:
                                                            Color(0x44FFFFFF),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 20, 0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${Dates.getMonth(AppInfo.conference.endDate)}\n',
                                                  style: TextStyle(fontFamily: 'DM Sans',
                                                    
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: Dates.getDay(AppInfo
                                                      .conference.endDate),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                )
                                              ],
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                
                                                color: Colors.white,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 70,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: Color(0x24FFFFFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              AppInfo.conference.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontFamily: 'DM Sans',
                                                color: Colors.white,
                                                
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 70,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: Color(0x2EFFFFFF),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 10),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 4, 0),
                                                      child: Icon(
                                                        Icons.location_pin,
                                                        color: Colors.white,
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppInfo
                                                          .conference.location,
                                                      style:
                                                          TextStyle(fontFamily: 'DM Sans',
                                                        
                                                        color: const Color(
                                                            0xD0FFFFFF),
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${getUserCount()} ',
                                                          style: TextStyle(fontFamily: 'DM Sans',
                                                            
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const TextSpan(
                                                          text: 'Attendees',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        )
                                                      ],
                                                      style:
                                                          TextStyle(fontFamily: 'DM Sans',
                                                        
                                                        color: const Color(
                                                            0xD1FFFFFF),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ],
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MouseRegion(
                    onEnter: (val) {
                      setState(() {
                        hoveringAnnouncements = true;
                      });
                    },
                    onHover: (val) {
                      setState(() {
                        hoveringAnnouncements = true;
                      });
                    },
                    onExit: (val) {
                      setState(() {
                        hoveringAnnouncements = false;
                      });
                    },
                    child: Container(
                      width: hoveringAnnouncements
                          ? MediaQuery.sizeOf(context).width * 0.25
                          : MediaQuery.sizeOf(context).width * 0.23,
                      height: hoveringAnnouncements ? 175 : 150,
                      decoration: BoxDecoration(
                        color: hoveringAnnouncements
                            ? const Color(0xFF3a00af)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                35, 25, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Announcements',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    color: hoveringAnnouncements
                                        ? Colors.white
                                        : Colors.black,
                                    
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          hoveringAnnouncements
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      35, 18, 60, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            updateIndex(4);
                                          },
                                          child: Container(
                                            height: 65,
                                            decoration: BoxDecoration(
                                              color: const Color(0x581C0054),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 0, 20, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 6, 0),
                                                    child: Icon(
                                                      Icons.campaign_outlined,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Create Announcement',
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      color: Colors.white,
                                                      
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                    child: MouseRegion(
                      onEnter: (val) {
                        setState(() {
                          hoveringEdit = true;
                        });
                      },
                      onHover: (val) {
                        setState(() {
                          hoveringEdit = true;
                        });
                      },
                      onExit: (val) {
                        setState(() {
                          hoveringEdit = false;
                        });
                      },
                      child: Container(
                        width: hoveringEdit
                            ? MediaQuery.sizeOf(context).width * 0.25
                            : MediaQuery.sizeOf(context).width * 0.23,
                        height: hoveringEdit ? 175 : 150,
                        decoration: BoxDecoration(
                          color: hoveringEdit
                              ? const Color(0xFF3a00af)
                              : const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  35, 25, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Edit Conference',
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      color: hoveringEdit
                                          ? Colors.white
                                          : Colors.black,
                                      
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            hoveringEdit
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            35, 18, 60, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateIndex(1);
                                            },
                                            child: Container(
                                              height: 65,
                                              decoration: BoxDecoration(
                                                color: const Color(0x581C0054),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20, 0, 20, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 6, 0),
                                                      child: Icon(
                                                        Icons.edit_outlined,
                                                        color: Colors.white,
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Edit Details',
                                                      style:
                                                          TextStyle(fontFamily: 'DM Sans',
                                                        color: Colors.white,
                                                        
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MouseRegion(
                    onEnter: (val) {
                      setState(() {
                        hoveringEvents = true;
                      });
                    },
                    onHover: (val) {
                      setState(() {
                        hoveringEvents = true;
                      });
                    },
                    onExit: (val) {
                      setState(() {
                        hoveringEvents = false;
                      });
                    },
                    child: Container(
                      width: hoveringEvents
                          ? MediaQuery.sizeOf(context).width * 0.25
                          : MediaQuery.sizeOf(context).width * 0.23,
                      height: hoveringEvents ? 175 : 150,
                      decoration: BoxDecoration(
                        color: hoveringEvents
                            ? const Color(0xFF3a00af)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                35, 25, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Edit Events',
                                  style: TextStyle(fontFamily: 'DM Sans',
                                    
                                    color: hoveringEvents
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          hoveringEvents
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      35, 18, 60, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            updateIndex(6);
                                          },
                                          child: Container(
                                            height: 65,
                                            decoration: BoxDecoration(
                                              color: const Color(0x581C0054),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 0, 20, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 6, 0),
                                                    child: Icon(
                                                      Icons
                                                          .file_upload_outlined,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Upload a Spreadsheet',
                                                    style: TextStyle(fontFamily: 'DM Sans',
                                                      color: Colors.white,
                                                      
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                    child: MouseRegion(
                      onEnter: (val) {
                        setState(() {
                          hoveringTickets = true;
                        });
                      },
                      onHover: (val) {
                        setState(() {
                          hoveringTickets = true;
                        });
                      },
                      onExit: (val) {
                        setState(() {
                          hoveringTickets = false;
                        });
                      },
                      child: Container(
                        width: hoveringTickets
                            ? MediaQuery.sizeOf(context).width * 0.25
                            : MediaQuery.sizeOf(context).width * 0.23,
                        height: hoveringTickets ? 175 : 150,
                        decoration: BoxDecoration(
                          color: hoveringTickets
                              ? const Color(0xFF3a00af)
                              : const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  35, 25, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Agenda Items',
                                    style: TextStyle(fontFamily: 'DM Sans',
                                      
                                      color: hoveringTickets
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            hoveringTickets
                                ? Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            35, 18, 60, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateIndex(7);
                                            },
                                            child: Container(
                                              height: 65,
                                              decoration: BoxDecoration(
                                                color: const Color(0x581C0054),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(20, 0, 20, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 6, 0),
                                                      child: Icon(
                                                        Icons.event,
                                                        color: Colors.white,
                                                        size: 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Upload Agenda Items',
                                                      style:
                                                          TextStyle(fontFamily: 'DM Sans',
                                                        color: Colors.white,
                                                        
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String getUserCount() {
    return formatNumber(AppInfo.userCount);
  }

  String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      double result = number / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K';
    } else {
      double result = number / 1000000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
    }
  }
}
