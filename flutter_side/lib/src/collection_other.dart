import 'package:nodechat/src/conversation_holder.dart';

import 'collection_base.dart';

abstract class OtherCollectionInterface {
  Future<ConversationHolder> getConvHolderWith(String andId);
}

class OtherCollection extends Collection implements OtherCollectionInterface {
  @override
  Future<ConversationHolder> getConvHolderWith(String andId) {
    return cPost<ConversationHolder>(
      api: "/other/get_holder_by_member/",
      converter: (body) => body.readAsConversationHolder,
      body: <String, dynamic>{
        "yourId": yourUserId,
        "andId": andId,
        "ids": [
          [yourUserId, andId],
          [andId, yourUserId],
        ],
      },
    );
  }
}
