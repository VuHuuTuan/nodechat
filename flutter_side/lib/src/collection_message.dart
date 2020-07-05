import 'model_message.dart';

import 'collection_base.dart';

abstract class MessCollectionInterface {
  Future<MyMessage> getById(String id);
  Future<List<MyMessage>> getByConversation(String convId);
}

class MessCollection extends Collection implements MessCollectionInterface {
  @override
  Future<MyMessage> getById(String id) {
    return cGet<MyMessage>(
      api: "/message/" + id,
      converter: (body) => body.readAsMessage,
    );
  }

  @override
  Future<List<MyMessage>> getByConversation(String convId) {
    return cGet<List<MyMessage>>(
      api: "/messages/" + convId,
      converter: (body) => body.readAsListMessage,
    );
  }
}
