import 'package:flutter/material.dart';

import '../nodechat.dart';

class NodeChatConvNotifier extends ChangeNotifier {
  List<ConversationHolder> _holders;
  List<ConversationHolder> get holders => _holders;

  int get totalUnreadCount => holders?.fold(0, (value, conv) => conv.unseenCount + value) ?? 0;

  Future<void> init() async {
    await clearData();
    _holders = await _getConvHolders();
    _holders?.forEach((holder) {
      holder.connect(
        getData: () => _getConvHolder(holder.userId),
        refresh: () => notifyListeners(),
      );
    });
    notifyListeners();
  }

  Future<void> clearData() async {
    if (_holders != null) {
      await Future.wait(_holders?.map((holder) => holder.disconnect()));
      _holders = null;
    }
  }

  Future<ConversationHolder> _getConvHolder(String id) {
    return NodeChat.instance.collection.other.getConvHolderWith(id);
  }

  Future<List<ConversationHolder>> _getConvHolders() async {
    try {
      final otherUsers = await NodeChat.instance.collection.user.getAllExceptId("");
      return await Future.wait(otherUsers.map((user) => _getConvHolder(user.documentId)).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}
