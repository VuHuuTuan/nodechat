import 'collection_conversation.dart';
import 'collection_message.dart';
import 'collection_other.dart';
import 'collection_user.dart';

class NodeApi {
  UserCollection _user;
  UserCollection get user => _user;
  ConvCollection _conv;
  ConvCollection get conversation => _conv;
  MessCollection _mess;
  MessCollection get message => _mess;
  OtherCollection _other;
  OtherCollection get other => _other;
  NodeApi() {
    _user = UserCollection();
    _conv = ConvCollection();
    _mess = MessCollection();
    _other = OtherCollection();
  }
}
