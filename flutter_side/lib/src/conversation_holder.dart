import 'dart:async';
import 'dart:convert';
import 'package:nodechat/nodechat.dart';
import 'model_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

extension ConversationHolderConverter on String {
  ConversationHolder get readAsConversationHolder => ConversationHolder.fromJson(jsonDecode(this));
}

const String kSelfUpdateEvent = "update_conversation_holder";
const String kMessageReceiverEvent = "receive_message";
const String kMessageSendEvent = "message_send";

class ConversationHolder {
  String _conversationId;
  String _userId;
  String _userName;
  String _userOffTime;
  String _lassMessContent;
  String _lassMessType;
  int _unseenCount;

  io.Socket socket;

  List<StreamSubscription> _subList = [];
  StreamController<MyMessage> _msc = StreamController<MyMessage>.broadcast();
  StreamSubscription<MyMessage> registerMessageReceiver(Function(MyMessage) onMessageReceiver) {
    final sub = _msc?.stream?.listen(onMessageReceiver);
    _subList.add(sub);
    return sub;
  }

  String get conversationId => _conversationId;
  String get userId => _userId;
  String get userName => _userName;
  String get userOffTime => _userOffTime;
  String get lassMessContent {
    if (_lassMessType == "text") return _lassMessContent;
    if (_lassMessType == "media") return "[Media]";
    if (_lassMessType == "quote") return "[Quote] $_lassMessContent";
    return null;
  }

  String get lassMessType => _lassMessType;
  int get unseenCount => _unseenCount;

  ConversationHolder.fromJson(jsonData) {
    this._conversationId = jsonData['conversation_id'];
    this._userId = jsonData['user_id'];
    this._userName = jsonData['user_name'];
    this._userOffTime = jsonData['off_time'];
    this._unseenCount = jsonData['unseen_count'];
    this._lassMessContent = jsonData['last_message_content'];
    this._lassMessType = jsonData['last_message_type'];
  }

  void connect({Future<ConversationHolder> Function() getData, Function refresh}) {
    final url = NodeChat.instance.serverUrl + "/?convID=$_conversationId&userID=" + NodeChat.instance.yourUserId;
    socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on(kSelfUpdateEvent, (_) => _selfUpdateHandler(getData, refresh));
    socket.on(kMessageReceiverEvent, (_) => _onMessageReceiverHandler(_));
    socket.connect();
  }

  void sendMessage(MyMessage message) => socket.emit(kMessageSendEvent, message.toMap);

  void _onMessageReceiverHandler(data) {
    final message = MyMessage.fromJson(data);
    print("conversation $_conversationId was receiver message ${message.toMap}");
    _msc.add(message);
  }

  void _selfUpdateHandler(Future<ConversationHolder> Function() getData, Function refresh) {
    if (getData != null && refresh != null) {
      print("selfUpdate[$_conversationId]");
      getData().then((newHolder) {
        this._userName = newHolder.userName;
        this._userOffTime = newHolder.userOffTime;
        this._unseenCount = newHolder.unseenCount;
        this._lassMessContent = newHolder.lassMessContent;
        this._lassMessType = newHolder.lassMessType;
        refresh();
      });
    }
  }

  Future<void> disconnect() async {
    print('disconnect');
    _subList.forEach((sub) => sub.cancel());
    await _msc?.close();
    socket?.close?.call();
    socket?.clearListeners?.call();
    socket?.destroy?.call();
  }
}
