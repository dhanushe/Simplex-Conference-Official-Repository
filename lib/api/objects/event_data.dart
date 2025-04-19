import 'dart:ui';

class EventData {
  late String _id;
  late String _name;
  late String _color;
  late Map<String, List<String>> _competitors;
  late String _date;
  late String _times;

  late String _round;
  late String _type;
  late bool _isLate;
  late bool _isOpen;

  EventData({
    required String id,
    required String name,
    required String color,
    required Map<String, List<String>> competitors,
    required String date,
    required String times,
    required String type,
    required String round,
    required bool isLate,
    required bool isOpen,
  }) {
    _id = id;
    _name = name;
    _date = date;
    _competitors = competitors;
    _color = color;
    _type = type;
    _times = times;
    _round = round;
    _isLate = isLate;
    _isOpen = isOpen;
  }

  String get type {
    return _type;
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  String get round {
    return _round;
  }

  String get times {
    return _times;
  }

  Map<String, List<String>> get competitors {
    return _competitors;
  }

  Color get color {
    return Color(int.parse(_color.substring(2), radix: 16));
  }

  String get date {
    return _date;
  }

  bool get isLate {
    return _isLate;
  }

  bool get isOpen {
    return _isOpen;
  }

  set isLate(bool value) {
    _isLate = value;
  }

  set times(String value) {
    _times = value;
  }
  set name(String value) {
    _name = value;
  }

  set isOpen(bool value) {
    _isOpen = value;
  }

  set date (String value) {
    _date = value;
  }
}

