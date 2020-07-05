import 'dart:convert';

import 'model_base.dart';

extension ListConversationExtensions on String {
  PrivateConversation get readAsConversation {
    return PrivateConversation.fromJson(jsonDecode(this));
  }

  List<PrivateConversation> get readAsListConversation {
    return jsonDecode(this).map((c) => PrivateConversation.fromJson(c)).toList();
  }
}

class PrivateConversation extends MongooModel {
  List<String> _members;

  List<String> get members => _members;

  PrivateConversation.between(String yourId, String andId) {
    this._members = <String>[yourId, andId];
  }

  PrivateConversation.fromJson(jsonData) : super.fromJson(jsonData) {
    this._members = jsonData['members'].cast<String>();
  }

  @override
  Map<String, dynamic> get toMap => {"members": _members};
}
