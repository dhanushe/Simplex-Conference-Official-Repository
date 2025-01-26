import 'package:intl/intl.dart';

class Dates {
  static DateTime parseTimeString(String timeString) {
    DateTime currentDate = DateTime.now().toLocal();
    DateTime targetTime = DateFormat('h:mm').parse(timeString);
    targetTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      targetTime.hour + (timeString.contains('pm') ? 12 : 0),
      targetTime.minute,
    );
    return targetTime;
  }

  static List<String> generateDateList(
      String startDateString, String endDateString) {
    DateTime startDate = DateTime.parse(startDateString);
    DateTime endDate = DateTime.parse(endDateString);
    bool todayInDateRange = isTodayInRange(startDate, endDate);
    List<String> datesList = [];
    if (!todayInDateRange) {
      datesList.add("Today");
    }
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (isToday(currentDate) && todayInDateRange) {
        datesList.add("Today");
      } else {
        datesList.add(currentDate.toString().substring(0, 10));
      }
    }
    return datesList;
  }

  static bool isTodayInRange(DateTime startDate, DateTime endDate) {
    DateTime today = DateTime.now();
    return today.isAfter(startDate) &&
        today.isBefore(endDate.add(const Duration(days: 1)));
  }

  static bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  static String formatDateString(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat('MMM. dd').format(date);
    return formattedDate;
  }

  static String formatDateRange(String startDate, String endDate) {
    DateTime startDateTime = DateFormat('yyyy-MM-dd').parse(startDate);
    DateTime endDateTime = DateFormat('yyyy-MM-dd').parse(endDate);

    // Check if the start and end dates are the same
    if (startDateTime.isAtSameMomentAs(endDateTime)) {
      // Format the date as "Month dayth, year"
      return '${DateFormat('MMMM d').format(startDateTime)}${addSuffix(startDateTime.day)}, ${DateFormat('y').format(startDateTime)}';
    } else {
      // Format the date range as "Month day-day, year"
      String formattedStartDate = DateFormat('MMMM d').format(startDateTime);
      String formattedEndDate = DateFormat('d, y').format(endDateTime);

      return '$formattedStartDate - $formattedEndDate';
    }
  }

  static String addSuffix(int day) {
    if (10 <= day % 100 && day % 100 <= 20) {
      return 'th';
    } else {
      String? suffix = {1: 'st', 2: 'nd', 3: 'rd'}.containsKey(day % 10)
          ? {1: 'st', 2: 'nd', 3: 'rd'}[day % 10]
          : 'th';
      return suffix!;
    }
  }

  static bool isBeforeCurrentTime(String timeString) {
    DateTime currentTime = DateTime.now().toLocal();
    DateTime targetTime = parseTimeString(timeString);
    return currentTime.isBefore(targetTime);
  }

  static bool isSameDateAsNow(String dateString) {
    DateTime dateToCheck = DateTime.parse(dateString);
    int yearToCheck = dateToCheck.year;
    int monthToCheck = dateToCheck.month;
    int dayToCheck = dateToCheck.day;
    DateTime now = DateTime.now().toLocal();
    int currentYear = now.year;
    int currentMonth = now.month;
    int currentDay = now.day;
    return (yearToCheck == currentYear) &&
        (monthToCheck == currentMonth) &&
        (dayToCheck == currentDay);
  }

  static String getCurrentDate() {
    DateTime dateTime = DateTime.now().toLocal();
    String dayOfWeek = DateFormat('EEEE').format(dateTime).toUpperCase();
    String month = DateFormat('MMMM').format(dateTime).toUpperCase();
    String dayOfMonth = DateFormat('d').format(dateTime);

    return '$dayOfWeek $month $dayOfMonth';
  }

  static String getCheckinTime(String inputTime) {
    DateTime parsedTime = parseTimeString(inputTime);
    DateTime resultTime = parsedTime.subtract(const Duration(minutes: 20));
    int hour12 = resultTime.hour > 12 ? resultTime.hour - 12 : resultTime.hour;
    if (hour12 == 0) {
      hour12 = 12;
    }
    String formattedResult =
        "$hour12.${resultTime.minute.toString().padLeft(2, '0')}";
    String amPm = resultTime.hour < 12 ? "am" : "pm";
    return "$formattedResult$amPm".toUpperCase();
  }

  static String formatDateToDay(String dateStr) {
    // ex: 2024-03-14 to March 14th, 2024 or Today
    dateStr = dateStr.replaceAll("/", "-");
    DateTime date = DateTime.parse(dateStr);
    DateFormat formatter = DateFormat("EEEE, MMMM d");
    String formattedDate = formatter.format(date);

    DateTime date2 = DateTime.now().toLocal();

    if (date.year == date2.year &&
        date.day == date2.day &&
        date.month == date2.month) {
      formattedDate = "Today";
    }

    return formattedDate;
  }

  static DateTime parseDateTime(String dateString, String timeString) {
    // Parse date
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);

    // Parse time
    DateTime time = parseTimeString(timeString);

    // Combine date and time
    DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    return dateTime;
  }

  static String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp).toLocal();

    String formattedTime = DateFormat.jm().format(dateTime);

    return formattedTime;
  }

  static String getMonth(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(dateString);

    // Format the date to get the three-letter month code
    String threeLetterMonth = DateFormat("MMM").format(dateTime);

    return threeLetterMonth.toUpperCase(); // Convert to uppercase if needed
  }

  static String getDay(String dateString) {
    // Parse the input date string
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(dateString);

    // Extract the day number
    int dayNumber = dateTime.day;

    return dayNumber.toString();
  }

  static String giveDateTimestamp(DateTime dateTime) {
    DateTime now = DateTime.now().toLocal();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Today
      Duration difference = now.difference(dateTime);
      if (difference.inMinutes <= 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else {
        int hoursAgo = difference.inHours;
        if (hoursAgo == 1) {
          return "1 hr ago";
        } else {
          return "$hoursAgo hrs ago";
        }
      }
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      // Yesterday
      final DateFormat formatter = DateFormat("h.mm a");
      return "Yesterday, ${formatter.format(dateTime)}";
    } else {
      // 2 days or more behind today
      final DateFormat formatter = DateFormat("MMM d, h.mm a");
      return formatter.format(dateTime);
    }
  }
}
