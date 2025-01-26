class ConferenceData {
  late String _id;

  late String _name;
  late String _desc;
  late String _logo;
  late String _startDate;
  late String _endDate;
  late String _location;
  late List<Map<String, String>> _announcements;
  late Map<String, String> _social;
  late List<Map<String, String>> _attachments;
  late List<Map<String, String>> _tiles;
  late String _longDesc;
  late List<String> _map;
  late String _aboutLink;
  late String _bpLink;
  late String _password;
  late String _helpLink;
  late String _specificLoc;
  late String _code;
  late String _homeBg;

  ConferenceData({
    required String id,
    required String name,
    required String desc,
    required String logo,
    required String startDate,
    required String endDate,
    required String location,
    required List<Map<String, String>> announcements,
    required Map<String, String> social,
    required List<Map<String, String>> attachments,
    required List<Map<String, String>> tiles,
    required String aboutLink,
    required String longDesc,
    required List<String> map,
    required String bpLink,
    required String password,
    required String helpLink,
    required String specificLoc,
    required String code,
    required String homeBg,
  }) {
    _id = id;
    _bpLink = bpLink;
    _name = name;
    _desc = desc;
    _logo = logo;
    _startDate = startDate;
    _endDate = endDate;
    _location = location;
    _announcements = announcements;
    _tiles = tiles;
    _attachments = attachments;
    _social = social;
    _longDesc = longDesc;
    _map = map;
    _aboutLink = aboutLink;
    _password = password;
    _specificLoc = specificLoc;
    _helpLink = helpLink;
    _code = code;
    _homeBg = homeBg;
  }

  String get homeBg {
    return _homeBg;
  }

  String get specificLoc {
    return _specificLoc;
  }

  String get code {
    return _code;
  }

  String get helpLink {
    return _helpLink;
  }

  List<Map<String, String>> get tiles {
    return _tiles;
  }

  String get aboutLink {
    return _aboutLink;
  }

  String get password {
    return _password;
  }

  String get bpLink {
    return _bpLink;
  }

  List<String> get map {
    return _map;
  }

  String get longDesc {
    return _longDesc;
  }

  List<Map<String, String>> get attachments {
    return _attachments;
  }

  Map<String, String> get social {
    return _social;
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  List<Map<String, String>> get announcements {
    return _announcements;
  }

  String get logo {
    return _logo;
  }

  String get location {
    return _location;
  }

  String get desc {
    return _desc;
  }

  String get startDate {
    return _startDate;
  }

  String get endDate {
    return _endDate;
  }
}
