library nodechat;

export 'src/node_server_exception.dart';

export 'src/model_base.dart';
export 'src/model_user.dart';
export 'src/model_message.dart';
export 'src/model_conversation.dart';

export 'src/collection_base.dart';
export 'src/collection_user.dart';
export 'src/collection_conversation.dart';
export 'src/collection_message.dart';
export 'src/collection_other.dart';

export 'src/conversation_holder.dart';
export 'src/conversation_notifier.dart';

import 'src/api.dart';

class NodeChat {
  static NodeChat _instance;
  static NodeChat get instance {
    _instance ??= NodeChat._init();
    return _instance;
  }

  NodeChat._init() {
    _collection = NodeApi();
  }

  NodeApi _collection;
  NodeApi get collection => _collection;

  String _serverAdress;
  String get serverAdress => _serverAdress;

  int _port;
  int get port => _port;

  String _yourUserId;
  String get yourUserId => _yourUserId;

  String get serverUrl => "$_serverAdress:$_port";
  bool get isLogingIn => _yourUserId != null;

  void initial(String serverUrl, int port) {
    this._serverAdress = serverUrl;
    this._port = port;
  }

  void loginAsId(String id) => _yourUserId = id;

  void logout() => _yourUserId = null;
}
