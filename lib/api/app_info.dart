import 'package:intl/intl.dart';

import 'objects/conference_data.dart';
import 'objects/event_data.dart';

import 'objects/conference_user_data.dart';
import 'objects/user_data.dart';
import 'objects/workshop_data.dart';

class AppInfo {
  static late UserData currentUser;
  static late ConferenceUserData currentConferenceUser;
  static late ConferenceData conference;

  static List<EventData> currentEvents = [];
  static List<WorkshopData> currentWorkshops = [];
  static List<EventData> allEvents = [];
  static int userCount = 0;
  static bool fromNotif = false;
  static bool showMySchedule = false;

  static String selectedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

  static bool isAdmin = false;
}
