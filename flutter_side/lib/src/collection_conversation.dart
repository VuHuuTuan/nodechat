import 'model_conversation.dart';

import 'collection_base.dart';

abstract class ConvCollectionInterface {
  Future<PrivateConversation> getById(String id);
  Future<PrivateConversation> getByMember(String yourId, String andId);
}

class ConvCollection extends Collection implements ConvCollectionInterface {
  @override
  Future<PrivateConversation> getById(String id) {
    return cGet<PrivateConversation>(
      api: "/conv/id/" + id,
      converter: (body) => body.readAsConversation,
    );
  }

  @override
  Future<PrivateConversation> getByMember(String yourId, String andId) {
    return cPost<PrivateConversation>(
      api: "/users/search/",
      converter: (body) => body.readAsConversation,
      body: <String, dynamic>{
        "ids": [
          [yourId, andId],
          [andId, yourId]
        ]
      },
    );
  }
}
