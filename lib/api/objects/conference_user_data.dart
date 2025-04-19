class ConferenceUserData {
  late String _id;

  late String _name;
  late String _email;
  late Map<String, String> _events;
  late Map<String, int> _agendaItems;

  late bool _isAdmin;

  ConferenceUserData({
    required String id,
    required String name,
    required String email,
    required Map<String, String> events,
    required Map<String, int> agendaItems,
    required bool isAdmin,
  }) {
    _id = id;
    _events = events;
    _agendaItems = agendaItems;

    _name = name;
    _email = email;
    _isAdmin = isAdmin;
  }

  Map<String, int> get agendaItems {
    return _agendaItems;
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  Map<String, String> get events {
    return _events;
  }

  String get email {
    return _email;
  }

  bool get isAdmin {
    return _isAdmin;
  }
}
