import 'dart:convert';

import 'model_base.dart';

extension UserConvertExtensions on String {
  User get readAsUser => User.fromJson(jsonDecode(this));
  List<User> get readAsListUser => (jsonDecode(this) as List).map((c) => User.fromJson(c)).toList();
}

class User extends MongooModel {
  String _uniqueKey;
  String _name;
  String _avatar;
  String _offTime;
  // List<String> _friendIds;
  // List<String> _requestIds;

  String get uniqueKey => _uniqueKey;
  String get name => _name;
  String get avatar => _avatar;
  String get offtime => _offTime;
  // List<String> get friendIds => _friendIds;
  // List<String> get requestIds => _requestIds;

  User(this._name, [this._offTime]);

  User.create(this._uniqueKey) {
    this._name = _uniqueKey;
    this._offTime = DateTime.now().toString();
    // this._friendIds = [];
    // this._requestIds = [];
  }

  User.fromJson(jsonData) : super.fromJson(jsonData) {
    this._uniqueKey = jsonData['key'];
    this._name = jsonData['name'];
    this._avatar = jsonData['avatar'];
    this._offTime = jsonData['off_time'];
    // this._friendIds = jsonData['friend_ids'].cast<String>();
    // this._requestIds = jsonData['request_ids'].cast<String>();
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "key": _uniqueKey,
      "name": _name,
      "off_time": _offTime,
      "avatar": _avatar,
      // "friend_ids": _friendIds,
      // "request_ids": _requestIds,
    };
  }
}
