class WorkshopData {
  late String _id;

  late String _name;
  late String _startTime;
  late String _endTime;
  late String _location;
  late String _date;
  late String _desc;
  late String _tag;
  late String _type;
  late List<Map<String, String>> _sessions;
  late String _sessionId;

  WorkshopData(
      {required String id,
      required String name,
      required String startTime,
      required String endTime,
      required String location,
      required String date,
      required String desc,
      required String tag,
      required String type,
      required List<Map<String, String>> sessions,
      required String sessionId}) {
    _id = id;
    _sessionId = sessionId;
    _sessions = sessions;
    _type = type;
    _name = name;
    _tag = tag;
    _desc = desc;
    _location = location;
    _startTime = startTime;
    _endTime = endTime;
    _date = date;
  }

  String get type {
    return _type;
  }

  List<Map<String, String>> get sessions {
    return _sessions;
  }

  String get sessionId {
    return _sessionId;
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  String get tag {
    return _tag;
  }

  String get desc {
    return _desc;
  }

  String get startTime {
    return _startTime;
  }

  String get endTime {
    return _endTime;
  }

  String get date {
    return _date;
  }

  String get location {
    return _location;
  }
}
