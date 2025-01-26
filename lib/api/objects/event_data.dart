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

  EventData({
    required String id,
    required String name,
    required String color,
    required Map<String, List<String>> competitors,
    required String date,
    required String times,
    required String type,
    required String round,
  }) {
    _id = id;
    _name = name;
    _date = date;
    _competitors = competitors;
    _color = color;
    _type = type;
    _times = times;
    _round = round;
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
}
