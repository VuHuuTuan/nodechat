# nodechat
dự án chat module trên flutter sử dụng nodejs làm server và mongodb.
## Chuẩn bị
Chuẩn bị phần mềm VSCode.
### flutter
Mở `pubspec.yaml` ở dự án flutter của bạn, thêm vào dòng sau ở `dependencies`:
```
dependencies:
  nodechat: 
    git:
      url: git://github.com/VuHuuTuan/nodechat.git
      path: flutter_side
```
Và nhập lệnh `flutter pub get` trong terminal.
### nodejs
Clone git về máy, mở thư mục git `../nodechat/nodejs_side`, mở terminal mà và nhập lần lượt  những lệnh sau.
```
npm install --save express
npm install --save socket.io
npm install --save mongodb
npm install --save body-parser
npm install --save nodemon
```
## Sử dụng
### Phương thức
#### Flutter
|Lệnh|Giải thích|
|---|---|
|.serverAdress|Lấy địa chỉ server|
|.port|Lấy port server|
|.yourUserId|Lấy `id` hiện tại của bạn|
|.serverUrl|Lấy địa chỉ server kết hợp với port|
|.initial|Đặt địa chỉ và port cho server|
|.loginAsId(id)|Đặt id hiện tại|
|.logout|Bỏ id hiện tại|
|.collection.user.getByKey(yourUniqueKey)|Lấy/Tạo một user với key(duy nhất với mỗi user)|
|.collection.user.getById(id)|Lấy một user với id, trả về null nếu không tồn tại|
|.collection.user.putById(id)|Cập nhật user, trả về user đã được cập nhật|
|.collection.user.getByKeys(yourListUniqueKey)|Tương tự `getByKey` nhưng tương tác với nhiều `key`|
|.collection.user.getByGroupId(groupOfId)|Tương tự `getById` nhưng tương tác với nhiều `id`|
|.collection.user.getBySearchKey(searchKey)|Lấy tất cả user có `name` tương tự với `searchKey`|
|.collection.user.getAll()|Lấy tất cả user|
|.collection.conversation.getById(id)|Lấy `conversation` với id, trả `null` nếu không tồn tại|
|.collection.conversation.getByMember(yourId,andId)|Lấy/Tạo `conversation` với `members` là `yourId` và `andId`|
|.collection.message.getById(id)|Lấy `message` với id, trả `null` nếu không tồn tại|
|.collection.message.getByConversation(id)|Lấy danh sách `message` với id của  `conversation`|
|.collection.other.getConvHolderWith(andId)|Lấy `convHolder` với id của đối tượng còn lại|
#### Nodejs
Mở terminal ở thư mục `nodejs_side`
* chạy server: `npm start`
* tắt server: `npm stop`
### Ví dụ
mình sử dụng `provider` để quản lí state
#### Đăng nhập/Tạo client
```
final user = await NodeChat.instance.collection.user.getByKey(yourUniqueKey);
NodeChat.instance.loginAsId(user.documentId);
```
#### Lấy danh sách các cuộc trò chuyện(ConvHolder)
```
...
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<NodeChatConvNotifier>(context, listen: false).init();
  });
}
...
Consumer<NodeChatConvNotifier>(
  builder: (_, notifier, __) {
    if (notifier.holders == null) return Center(child: CircularProgressIndicator());
    if (notifier.holders.isEmpty) return Center(child: Text("Empty"));
    return bList(notifier.holders);
  },
)
...
Widget bList(List<ConversationHolder> holders) {
  return RefreshIndicator(
    onRefresh: () => Provider.of<NodeChatConvNotifier>(context, listen: false).init(),
    child: ListView.builder(
      itemCount: holders.length,
      itemBuilder: (_, i) => bItem(holders[i]),
    ),
  );
}

Widget bItem(ConversationHolder holder) {
  final subTitle = holder.lassMessContent != null
      ? Text(holder.lassMessContent)
      : null;
  final trailing = holder.unseenCount != 0 
      ? Text("${holder.unseenCount}") 
      : null;
  return ListTile(
    onTap: () => onGoToChat(holder), // Mở màn hình Chat
    title: Text(holder.userName),
    subtitle: subTitle,
    trailing: trailing,
  );
}
...
```
#### Lấy tổng số tin nhắn chưa đọc
```
...
Consumer<NodeChatConvNotifier>(builder: (_, notifier, __) {
  if (notifier.totalUnreadCount == 0) return Container();
  return Center(child: Text("${notifier.totalUnreadCount}"));
})
...
```
## Thư viện sử dụng
* [socket_io_client](https://pub.dev/packages?q=socket_io_client) - SocketIo
* [http](https://pub.dev/packages/http) - Http
## Tác giả
* **VuHuuTuan** - *Initial work* - [VuHuuTuan](https://github.com/VuHuuTuan)
