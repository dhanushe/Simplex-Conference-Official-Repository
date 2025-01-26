class UserData {
  late String _id;
  late String _name;
  late String _email;
  late String _lastOpened;
  late List<String> _conferences;

  UserData({
    required String id,
    required String name,
    required String email,
    required String lastOpened,
    required List<String> conferences,
  }) {
    _id = id;

    _name = name;
    _email = email;
    _lastOpened = lastOpened;
    _conferences = conferences;
  }

  String get id {
    return _id;
  }

  String get name {
    return _name;
  }

  List<String> get conferences {
    return _conferences;
  }

  String get email {
    return _email;
  }

  String get lastOpened {
    return _lastOpened;
  }
}
