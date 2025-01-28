// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:simplex_conference_redo_repo/api/objects/conference_data.dart';
import 'package:simplex_conference_redo_repo/main.dart';
import '../../main_default.dart';
import '../app_info.dart';

import '../objects/conference_user_data.dart';
import '../objects/event_data.dart';
import '../objects/user_data.dart';
import '../objects/workshop_data.dart';

class API {
  late FirebaseFirestore database;

  API() {
    database = FirebaseFirestore.instance;
  }

  Future<void> copyEventsToAnotherConference() async {
    // Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Conference IDs
    final String sourceConferenceId = 'ABMIjsLrs92MU71Nu2nF';
    final String destinationConferenceId = 'ohGXOCkuUMsTYCV4JETN';

    // Source and destination collections
    final CollectionReference sourceEventsCollection = firestore
        .collection('conferences')
        .doc(sourceConferenceId)
        .collection('events');
    final CollectionReference destinationEventsCollection = firestore
        .collection('conferences')
        .doc(destinationConferenceId)
        .collection('events');

    // Fetch all events from the source conference
    QuerySnapshot sourceEventsSnapshot = await sourceEventsCollection.get();

    // Loop through each event and copy it to the destination conference
    for (QueryDocumentSnapshot eventDoc in sourceEventsSnapshot.docs) {
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;

      // Change the date field to '2024-06-29'
      eventData['date'] = '2024-06-29';

      // Add the event to the destination conference
      await destinationEventsCollection.add(eventData);
    }
  }

  /*
    USER METHODS
  */

  Future<bool> loginConference(String password, String name) async {
    QuerySnapshot c = await FirebaseFirestore.instance
        .collection('conferences')
        .where('password', isEqualTo: password)
        .where('name', isEqualTo: name)
        .get();
    return c.docs.isNotEmpty;
  }

  Future<ConferenceData> findConference(String password, String name) async {
    QuerySnapshot c = await FirebaseFirestore.instance
        .collection('conferences')
        .where('password', isEqualTo: password)
        .where('name', isEqualTo: name)
        .get();
    DocumentSnapshot eventInfo = c.docs.first;

    List<Map<String, String>> announcementsList = [];

    List<dynamic> announcementList =
        (eventInfo.get('announcements') as List).cast<dynamic>();

    for (int i = 0; i < announcementList.length; i++) {
      dynamic item = announcementList[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      announcementsList.add(a);
    }
    announcementsList.sort((a, b) {
      DateTime timestampA = DateTime.parse(a['timestamp']!);
      DateTime timestampB = DateTime.parse(b['timestamp']!);
      return timestampA.compareTo(timestampB);
    });

    List<Map<String, String>> attachlist = [];

    List<dynamic> attachmentlist =
        (eventInfo.get('attachments') as List).cast<dynamic>();

    for (int i = 0; i < attachmentlist.length; i++) {
      dynamic item = attachmentlist[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      attachlist.add(a);
    }

    List<Map<String, String>> tileList = [];

    List<dynamic> tileList2 = (eventInfo.get('tiles') as List).cast<dynamic>();

    for (int i = 0; i < tileList2.length; i++) {
      dynamic item = tileList2[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      tileList.add(a);
    }

    Map<dynamic, dynamic> firestoreData =
        (eventInfo.get('social') as Map).cast<dynamic, dynamic>();
    Map<String, String> convertedData = firestoreData.map((key, value) {
      return MapEntry(key.toString(), value.toString());
    });
    QuerySnapshot c2 = await FirebaseFirestore.instance
        .collection('conferences')
        .doc(eventInfo.id)
        .collection('users')
        .get();
    AppInfo.userCount = c2.docs.length;
    String specificLoc = "";

    try {
      specificLoc = eventInfo.get('specificLoc') as String;
    } catch (e) {
      specificLoc = "";
    }

    return ConferenceData(
      tiles: tileList,
      helpLink: eventInfo.get('helpLink') as String,
      aboutLink: eventInfo.get('aboutLink') as String,
      map: (eventInfo.get('map') as List).cast<String>(),
      announcements: announcementsList,
      location: eventInfo.get('location') as String,
      id: eventInfo.id,
      desc: eventInfo.get('desc') as String,
      logo: eventInfo.get('logo') as String,
      startDate: eventInfo.get('startDate') as String,
      name: eventInfo.get('name') as String,
      endDate: eventInfo.get('endDate') as String,
      bpLink: eventInfo.get('bpLink') as String,
      attachments: attachlist,
      social: convertedData,
      longDesc: eventInfo.get('longDesc') as String,
      password: eventInfo.get('password') as String,
      specificLoc: specificLoc,
      code: eventInfo.get('code') as String,
      homeBg: eventInfo.get('homeBg') as String,
    );
  }

  Future<void> deleteEvent(String cId, String eId) async {
    await FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('events')
        .doc(eId)
        .delete();
    QuerySnapshot usersSnapshot = await database
        .collection('conferences')
        .doc(cId)
        .collection('users')
        .get();
    CollectionReference usersCollection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('users');

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Get reference to the user document
      DocumentReference userRef = usersCollection.doc(userDoc.id);

      // Get the current agendaItems map

      DocumentSnapshot u = await userRef.get();

      List<String> currentAgendaItems = (u['events'] as List).cast<String>();

      // Check if the document ID exists in the agendaItems map
      if (currentAgendaItems.contains(eId)) {
        // Remove the entry with the document ID
        currentAgendaItems.remove(eId);

        // Update the "agendaItems" field with the modified map
        await userRef.update({'events': currentAgendaItems});
      }
    }
  }

  Future<void> deleteWorkshop(String cId, String eId) async {
    await FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('workshops')
        .doc(eId)
        .delete();

    QuerySnapshot usersSnapshot = await database
        .collection('conferences')
        .doc(cId)
        .collection('users')
        .get();
    CollectionReference usersCollection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('users');

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Get reference to the user document
      DocumentReference userRef = usersCollection.doc(userDoc.id);

      DocumentSnapshot u = await userRef.get();
      Map<String, dynamic> currentAgendaItems =
          u['agendaItems'] as Map<String, dynamic>;

      // Check if the document ID exists in the agendaItems map
      if (currentAgendaItems.containsKey(eId)) {
        // Remove the entry with the document ID
        currentAgendaItems.remove(eId);

        // Update the "agendaItems" field with the modified map
        await userRef.update({'agendaItems': currentAgendaItems});
      }
    }
  }

  Future<void> deleteSession(String cId, String eId, int i) async {
    await FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('workshops')
        .doc(eId)
        .update({
      'sessions': FieldValue.arrayRemove([i])
    });
    QuerySnapshot usersSnapshot = await database
        .collection('conferences')
        .doc(cId)
        .collection('users')
        .get();
    CollectionReference usersCollection = FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('users');

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Get reference to the user document
      DocumentReference userRef = usersCollection.doc(userDoc.id);

      // Get the current agendaItems map

      DocumentSnapshot u = await userRef.get();
      Map<String, dynamic> currentAgendaItems =
          u['agendaItems'] as Map<String, dynamic>;

      // Check if the document ID exists in the agendaItems map
      if (currentAgendaItems.containsKey(eId)) {
        // Remove the entry with the document ID
        currentAgendaItems.remove(eId);

        // Update the "agendaItems" field with the modified map
        await userRef.update({'agendaItems': currentAgendaItems});
      }
    }
  }

  Future<List<EventData>> getAllEvents(String cId) async {
    List<EventData> currentEvents = [];
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('events')
        .get();
    for (QueryDocumentSnapshot d in docs.docs) {
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
    return currentEvents;
  }

  /*
  Given a String cId, which represents a conference ID, this method fetches
  all of the workshop objects from Firebase and returns a List of WorkshopData
  objects.
  */
  Future<List<WorkshopData>> getWorkshops(String cId) async {
    List<WorkshopData> currentEvents = [];

    // Fetches the workshops collection from the conference
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection('conferences')
        .doc(cId)
        .collection('workshops')
        .get();
    // Iterates through each document, which represents a workshop
    for (QueryDocumentSnapshot d in docs.docs) {
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
    return currentEvents;
  }

  Future<ConferenceUserData> getCurrentUserData(String conferenceId) async {
    User? user = FirebaseAuth.instance.currentUser;
    String id = user!.uid;
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('conferences')
        .doc(conferenceId)
        .collection('users')
        .doc(id)
        .get();

    Map<String, int> tileList = {};
    // Because of Firebase's API with typing, the List of maps must be cast
    // to a dynamic typing.

    try {
      Map<String, dynamic> firestoreMap =
          userDocument['agendaItems'] as Map<String, dynamic>;

      // Convert the dynamic values to List<String> and create a Map<String, List<String>>
      Map<String, int> flutterMap = firestoreMap.map((key, value) {
        return MapEntry(key, (value as int));
      });

      tileList = flutterMap;
    } catch (e) {
      await database
          .collection('conferences')
          .doc(conferenceId)
          .collection('users')
          .doc(id)
          .update({'agendaItems': {}});
    }

    return ConferenceUserData(
        email: user.email!,
        name: userDocument.get('name') as String,
        isAdmin: userDocument.get('isAdmin') as bool,
        id: user.uid,
        events: (userDocument.get('events') as List).cast<String>(),
        agendaItems: tileList);
  }

  Future<UserData> getUser(String id) async {
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    return UserData(
      email: userDocument.get('email') as String,
      name: userDocument.get('name') as String,
      conferences: (userDocument.get('conferences') as List).cast<String>(),
      id: id,
      lastOpened: userDocument.get('lastOpened') as String,
    );
  }

  /*
    CREATING/REMOVING DB DOCUMENTS
  */
  Future<void> addUser(String name, String uId, String email) async {
    Map<String, dynamic> userInfo = {};
    userInfo['name'] = name;
    userInfo['lastOpened'] = "";

    userInfo['email'] = email;
    userInfo['conferences'] = [];

    await database.collection('users').doc(uId).set(userInfo);
  }

  Future<void> addConferenceUser(String id, UserData u) async {
    Map<String, dynamic> userInfo = {};
    userInfo['name'] = u.name;

    userInfo['email'] = u.email;
    userInfo['events'] = [];
    userInfo['isAdmin'] = false;
    userInfo['agendaItems'] = [];

    await database
        .collection('conferences')
        .doc(id)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(userInfo);
  }

  Future<void> configureFirebaseMessaging(String id) async {
    if (kIsWeb) {
      return;
    }

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      FlutterAppBadgeControl.removeBadge();
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance.subscribeToTopic('announcements-$id');
    }
  }

  Future<void> updateAnnouncements(
      List<Map<String, String>> announcements, String conferenceId) async {
    await database
        .collection('conferences')
        .doc(conferenceId)
        .update({'announcements': announcements});
  }

  Future<void> updateConferenceBasic(
      String conferenceId, List<String> items) async {
    await database.collection('conferences').doc(conferenceId).update({
      'name': items[0],
      'desc': items[1],
      'location': items[2],
      'logo': items[3],
      'startDate': items[4],
      'endDate': items[5],
      'helpLink': items[6],
      'password': items[7],
      'specificLoc': items[8],
      'code': items[9],
      'homeBg': items[10],
    });
  }

  Future<void> updateConferenceAgenda(
      String conferenceId, List<Map<String, String>> items) async {
    await database.collection('conferences').doc(conferenceId).update({
      'attachments': items,
    });
  }

  Future<void> updateAgendaUser(ConferenceUserData u) async {
    await database
        .collection('conferences')
        .doc(AppInfo.conference.id)
        .collection('users')
        .doc(u.id)
        .update({
      'agendaItems': u.agendaItems,
    });
  }

  Future<void> updateConferenceTiles(
      String conferenceId, List<Map<String, String>> items) async {
    await database.collection('conferences').doc(conferenceId).update({
      'tiles': items,
    });
  }

  Future<void> updateConferenceMap(
      String conferenceId, List<String> images) async {
    await database.collection('conferences').doc(conferenceId).update({
      'map': images,
    });
  }

  Future<void> updateAboutConference(String conferenceId, String desc,
      String bpLink, String aboutLink, Map<String, String> social) async {
    await database.collection('conferences').doc(conferenceId).update({
      'social': social,
      'aboutLink': aboutLink,
      'bpLink': bpLink,
      'longDesc': desc,
    });
  }

  Future<void> updateUserConference(UserData u, String cId) async {
    await database.collection('users').doc(u.id).update({
      'conferences': u.conferences + [cId]
    });
  }

  Future<void> joinConference(UserData u, String cId) async {
    await database.collection('users').doc(u.id).update({
      'lastOpened': cId,
    });
  }

  Future<void> leaveConference(UserData u) async {
    await database.collection('users').doc(u.id).update({
      'lastOpened': "",
    });
  }

  Future<void> removeEventUser(ConferenceUserData u, String cId) async {
    await database
        .collection('conferences')
        .doc(cId)
        .collection('users')
        .doc(u.id)
        .update({'events': u.events});
  }

  Future<void> addEventUser(ConferenceUserData u, String cId) async {
    await database
        .collection('conferences')
        .doc(cId)
        .collection('users')
        .doc(u.id)
        .update({'events': u.events});
  }

  Future<List<Map<String, String>>> getAnnouncements(String id) async {
    List<Map<String, String>> announcementsList = [];

    DocumentSnapshot announcementDoc =
        await database.collection('conferences').doc(id).get();
    List<dynamic> announcementList =
        (announcementDoc.get('announcements') as List).cast<dynamic>();

    for (int i = 0; i < announcementList.length; i++) {
      dynamic item = announcementList[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      announcementsList.add(a);
    }
    announcementsList.sort((a, b) {
      DateTime timestampA = DateTime.parse(a['timestamp']!);
      DateTime timestampB = DateTime.parse(b['timestamp']!);
      return timestampA.compareTo(timestampB);
    });

    return announcementsList;
  }

  Future<List<EventData>> getEventsForUser(
      String conferenceid, List<String> workshops) async {
    List<EventData> currentEvents = [];
    List<DocumentReference> documentReferences = [];

    // Populate the list with DocumentReference objects based on the document IDs
    for (var docId in workshops) {
      documentReferences.add(FirebaseFirestore.instance
          .collection('conferences')
          .doc(conferenceid)
          .collection('events')
          .doc(docId));
    }

    List<DocumentSnapshot> documents = await Future.wait(
      documentReferences.map((docRef) => docRef.get()),
    );

    for (DocumentSnapshot d in documents) {
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

    return currentEvents;
  }

  Future<ConferenceData> getConference(String id) async {
    DocumentSnapshot eventInfo =
        await database.collection('conferences').doc(id).get();

    List<Map<String, String>> announcementsList = [];

    List<dynamic> announcementList =
        (eventInfo.get('announcements') as List).cast<dynamic>();

    for (int i = 0; i < announcementList.length; i++) {
      dynamic item = announcementList[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      announcementsList.add(a);
    }
    announcementsList.sort((a, b) {
      DateTime timestampA = DateTime.parse(a['timestamp']!);
      DateTime timestampB = DateTime.parse(b['timestamp']!);
      return timestampA.compareTo(timestampB);
    });

    List<Map<String, String>> attachlist = [];

    List<dynamic> attachmentlist =
        (eventInfo.get('attachments') as List).cast<dynamic>();

    for (int i = 0; i < attachmentlist.length; i++) {
      dynamic item = attachmentlist[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      attachlist.add(a);
    }

    Map<dynamic, dynamic> firestoreData =
        (eventInfo.get('social') as Map).cast<dynamic, dynamic>();
    Map<String, String> convertedData = firestoreData.map((key, value) {
      return MapEntry(key.toString(), value.toString());
    });

    List<Map<String, String>> tileList = [];

    List<dynamic> tileList2 = (eventInfo.get('tiles') as List).cast<dynamic>();

    for (int i = 0; i < tileList2.length; i++) {
      dynamic item = tileList2[i];
      Map<String, String> a = {};
      Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
      map.forEach((key, value) {
        a[key.toString()] = value.toString();
      });

      tileList.add(a);
    }
    String specificLoc = "";
    try {
      specificLoc = eventInfo.get('specificLoc') as String;
    } catch (e) {
      specificLoc = "";
    }

    return ConferenceData(
      tiles: tileList,
      aboutLink: eventInfo.get('aboutLink') as String,
      helpLink: eventInfo.get('helpLink') as String,
      map: (eventInfo.get('map') as List).cast<String>(),
      announcements: announcementsList,
      location: eventInfo.get('location') as String,
      id: eventInfo.id,
      desc: eventInfo.get('desc') as String,
      logo: eventInfo.get('logo') as String,
      startDate: eventInfo.get('startDate') as String,
      name: eventInfo.get('name') as String,
      endDate: eventInfo.get('endDate') as String,
      bpLink: eventInfo.get('bpLink') as String,
      attachments: attachlist,
      social: convertedData,
      longDesc: eventInfo.get('longDesc') as String,
      password: eventInfo.get('password') as String,
      specificLoc: specificLoc,
      code: eventInfo.get('code') as String,
      homeBg: eventInfo.get('homeBg') as String,
    );
  }

  Future<List<ConferenceData>> getConferences() async {
    QuerySnapshot e = await database.collection('conferences').get();
    List<ConferenceData> conferences = [];
    for (QueryDocumentSnapshot eventInfo in e.docs) {
      List<Map<String, String>> announcementsList = [];

      List<dynamic> announcementList =
          (eventInfo.get('announcements') as List).cast<dynamic>();

      for (int i = 0; i < announcementList.length; i++) {
        dynamic item = announcementList[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        announcementsList.add(a);
      }
      announcementsList.sort((a, b) {
        DateTime timestampA = DateTime.parse(a['timestamp']!);
        DateTime timestampB = DateTime.parse(b['timestamp']!);
        return timestampA.compareTo(timestampB);
      });

      List<Map<String, String>> attachlist = [];

      List<dynamic> attachmentlist =
          (eventInfo.get('attachments') as List).cast<dynamic>();

      for (int i = 0; i < attachmentlist.length; i++) {
        dynamic item = attachmentlist[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        attachlist.add(a);
      }

      Map<dynamic, dynamic> firestoreData =
          (eventInfo.get('social') as Map).cast<dynamic, dynamic>();
      Map<String, String> convertedData = firestoreData.map((key, value) {
        return MapEntry(key.toString(), value.toString());
      });
      List<Map<String, String>> tileList = [];

      List<dynamic> tileList2 =
          (eventInfo.get('tiles') as List).cast<dynamic>();

      for (int i = 0; i < tileList2.length; i++) {
        dynamic item = tileList2[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        tileList.add(a);
      }
      String specificLoc = "";

      try {
        specificLoc = eventInfo.get('specificLoc') as String;
      } catch (e) {
        specificLoc = "";
      }

      conferences.add(ConferenceData(
        tiles: tileList,
        aboutLink: eventInfo.get('aboutLink') as String,
        helpLink: eventInfo.get('helpLink') as String,
        map: (eventInfo.get('map') as List).cast<String>(),
        announcements: announcementsList,
        location: eventInfo.get('location') as String,
        id: eventInfo.id,
        desc: eventInfo.get('desc') as String,
        logo: eventInfo.get('logo') as String,
        startDate: eventInfo.get('startDate') as String,
        name: eventInfo.get('name') as String,
        endDate: eventInfo.get('endDate') as String,
        bpLink: eventInfo.get('bpLink') as String,
        attachments: attachlist,
        social: convertedData,
        longDesc: eventInfo.get('longDesc') as String,
        password: eventInfo.get('password') as String,
        specificLoc: specificLoc,
        code: eventInfo.get('code') as String,
        homeBg: eventInfo.get('homeBg') as String,
      ));
    }
    return conferences;
  }

  Future<List<ConferenceData>> getUserConferences(UserData u) async {
    QuerySnapshot e = await database
        .collection('conferences')
        .where(FieldPath.documentId, whereIn: u.conferences)
        .get();
    List<ConferenceData> conferences = [];
    for (QueryDocumentSnapshot eventInfo in e.docs) {
      List<Map<String, String>> announcementsList = [];

      List<dynamic> announcementList =
          (eventInfo.get('announcements') as List).cast<dynamic>();

      for (int i = 0; i < announcementList.length; i++) {
        dynamic item = announcementList[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        announcementsList.add(a);
      }
      announcementsList.sort((a, b) {
        DateTime timestampA = DateTime.parse(a['timestamp']!);
        DateTime timestampB = DateTime.parse(b['timestamp']!);
        return timestampA.compareTo(timestampB);
      });

      List<Map<String, String>> attachlist = [];

      List<dynamic> attachmentlist =
          (eventInfo.get('attachments') as List).cast<dynamic>();

      for (int i = 0; i < attachmentlist.length; i++) {
        dynamic item = attachmentlist[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        attachlist.add(a);
      }

      Map<dynamic, dynamic> firestoreData =
          (eventInfo.get('social') as Map).cast<dynamic, dynamic>();
      Map<String, String> convertedData = firestoreData.map((key, value) {
        return MapEntry(key.toString(), value.toString());
      });
      List<Map<String, String>> tileList = [];

      List<dynamic> tileList2 =
          (eventInfo.get('tiles') as List).cast<dynamic>();

      for (int i = 0; i < tileList2.length; i++) {
        dynamic item = tileList2[i];
        Map<String, String> a = {};
        Map<dynamic, dynamic> map = (item as Map).cast<dynamic, dynamic>();
        map.forEach((key, value) {
          a[key.toString()] = value.toString();
        });

        tileList.add(a);
      }
      String specificLoc = "";

      try {
        specificLoc = eventInfo.get('specificLoc') as String;
      } catch (e) {
        specificLoc = "";
      }

      conferences.add(ConferenceData(
        tiles: tileList,
        aboutLink: eventInfo.get('aboutLink') as String,
        helpLink: eventInfo.get('helpLink') as String,
        map: (eventInfo.get('map') as List).cast<String>(),
        announcements: announcementsList,
        location: eventInfo.get('location') as String,
        id: eventInfo.id,
        desc: eventInfo.get('desc') as String,
        logo: eventInfo.get('logo') as String,
        startDate: eventInfo.get('startDate') as String,
        name: eventInfo.get('name') as String,
        endDate: eventInfo.get('endDate') as String,
        bpLink: eventInfo.get('bpLink') as String,
        attachments: attachlist,
        social: convertedData,
        longDesc: eventInfo.get('longDesc') as String,
        password: eventInfo.get('password') as String,
        specificLoc: specificLoc,
        code: eventInfo.get('code') as String,
        homeBg: eventInfo.get('homeBg') as String,
      ));
    }
    return conferences;
  }

  /* 
    LOAD METHOD
  */
  Future<void> loadData(String id) async {
    await getConference(id).then(
      (value) {
        AppInfo.conference = value;
      },
    );
    await getCurrentUserData(AppInfo.conference.id).then(
      (value) {
        AppInfo.currentConferenceUser = value;
      },
    );
    await getEventsForUser(
            AppInfo.conference.id, AppInfo.currentConferenceUser.events)
        .then(
      (value) {
        AppInfo.currentEvents = value;
      },
    );

    await getAllEvents(AppInfo.conference.id).then(
      (value) {
        AppInfo.allEvents = value;
      },
    );

    await getWorkshops(id).then((value) {
      AppInfo.currentWorkshops = value;
    });
  }

  Future<void> loadUser(String id) async {
    await getUser(id).then((value) {
      AppInfo.currentUser = value;
    });
  }

  Future<void> updateAllUserConference(String id) async {
    QuerySnapshot docs = await database.collection('users').get();
    for (DocumentSnapshot d in docs.docs) {
      List<String> conferences = (d.get('conferences') as List).cast<String>();
      String lastOpened = d.get('lastOpened') as String;

      // Remove the given ID from conferences array
      if (conferences.contains(id)) {
        conferences.remove(id);
      }

      // Update the lastOpened field to empty string if it exists
      if (lastOpened == id) {
        await database.collection('users').doc(d.id).update({'lastOpened': ""});
      }

      // Update the conferences array in Firestore
      await database
          .collection('users')
          .doc(d.id)
          .update({'conferences': conferences});
    }
  }

  // makes the status bar WHITE
  static void setLight() {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // ios parameter
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Color(0x80000000),
        systemNavigationBarContrastEnforced: true,
      ));
    }
  }

  // makes the status bar DARK
  static void setDark() {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // ios parameter
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Color(0x80000000),
        systemNavigationBarContrastEnforced: true,
      ));
    }
  }
}
