import 'dart:convert';

import 'model_base.dart';

extension MessageConverter on String {
  MyMessage get readAsMessage => MyMessage.fromJson(jsonDecode(this));
  List<MyMessage> get readAsListMessage =>
      jsonDecode(this).map((c) => MyMessage.fromJson(c)).toList().cast<MyMessage>();
}

const String kTextMessage = 'text';
const String kMediaMessage = 'media';
const String kQuoteMessage = 'quote';

class MyMessage extends MongooModel {
  String _conversationId;
  String _senderId;
  String _sendedTime;
  String _type;
  String content;
  String _data;
  bool _isDeleted;
  List<String> _seeners;

  String get conversationId => _conversationId;
  String get senderId => _senderId;
  String get sendedTimeInText => _sendedTime;
  DateTime get sendedTime => DateTime.parse(_sendedTime);
  bool get isDeleted => _isDeleted;
  String get type => _type;
  String get data => _data;
  List<String> get seeners => _seeners;

  bool get isTextMessage => type == kTextMessage;
  bool get isMediaMessage => type == kMediaMessage;
  bool get isQuoteMessage => type == kQuoteMessage;

  bool isSeenBy(String userId) => seeners?.contains(userId) ?? false;

  MyMessage.text(String content, String conversationId, String senderId) {
    _create(content, null, conversationId, senderId, kTextMessage);
  }

  MyMessage.media(String content, String data, String conversationId, String senderId) {
    _create(content, data, conversationId, senderId, kMediaMessage);
  }

  MyMessage.quote(String content, String quoteId, String conversationId, String senderId) {
    _create(content, quoteId, conversationId, senderId, kQuoteMessage);
  }

  void _create(String content, String data, String conversationId, String senderId, String type) {
    this.content = content;
    this._data = data;
    this._type = type;
    this._conversationId = conversationId;
    this._senderId = senderId;
    this._isDeleted = false;
    this._sendedTime = DateTime.now().toString();
    this._seeners = <String>[senderId];
  }

  MyMessage.fromJson(jsonData) : super.fromJson(jsonData) {
    this._conversationId = jsonData['conversation_id'];
    this._senderId = jsonData['sender_id'];
    this._sendedTime = jsonData['sender_time'];
    this._isDeleted = jsonData['is_deleted'];
    this._type = jsonData['type'];
    this.content = jsonData['content'];
    this._data = jsonData['data'];
    this._seeners = jsonData['seeners'].cast<String>();
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "conversation_id": _conversationId,
      "sender_id": _senderId,
      "sender_time": _sendedTime,
      "is_deleted": _isDeleted,
      "type": _type,
      "content": content,
      "data": _data,
      "seeners": _seeners,
    };
  }
}
