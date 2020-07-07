import 'dart:convert';

import 'model_base.dart';

extension UserConvertExtensions on String {
  User get readAsUser => User.fromJson(jsonDecode(this));
  List<User> get readAsListUser => (jsonDecode(this) as List).map((c) => User.fromJson(c)).toList();
}

class User extends MongooModel {
  String _uniqueKey;
  Map _body;
  String _offTime;

  String get uniqueKey => _uniqueKey;
  Map get body => _body;
  String get offtime => _offTime;

  User.create(this._uniqueKey, [Map body]) {
    this._offTime = DateTime.now().toString();
    this._body = body;
  }

  User.fromJson(jsonData) : super.fromJson(jsonData) {
    this._uniqueKey = jsonData['key'];
    this._body = jsonData['body'];
    this._offTime = jsonData['off_time'];
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "key": _uniqueKey,
      "body": _body,
      "off_time": _offTime,
    };
  }
}
