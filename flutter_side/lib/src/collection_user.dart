import 'model_user.dart';

import 'collection_base.dart';

abstract class UserCollectionInterface {
  Future<User> getByKey(String yourUniqueKey);
  Future<User> getById(String id);
  Future<User> putById(String id, {Map<String, dynamic> data});
  Future<List<User>> getByKeys(List<String> yourListUniqueKey);
  Future<List<User>> getByGroupId(List<String> groupOfId);
  Future<List<User>> getBySearchKey(String searchKey);
  Future<List<User>> getAll();
}

class UserCollection extends Collection implements UserCollectionInterface {
  @override
  Future<List<User>> getByGroupId(List<String> groupOfId) {
    return cGet<List<User>>(
      api: "/users/" + groupOfId.join(","),
      converter: (body) => body.readAsListUser,
    );
  }

  @override
  Future<User> getById(String id) {
    return cGet<User>(
      api: "/users/id/",
      converter: (body) => body.readAsUser,
    );
  }

  @override
  Future<User> getByKey(String yourUniqueKey, [Map<String, dynamic> body]) {
    return cPost<User>(
      api: "/user/key/",
      body: {"key": yourUniqueKey, "body": body},
      converter: (body) => body.readAsUser,
    );
  }

  @override
  Future<List<User>> getBySearchKey(String searchKey) {
    return cPost<List<User>>(
      api: "/users/search/",
      converter: (body) => body.readAsListUser,
      body: <String, dynamic>{"your_id": yourUserId, "key": searchKey},
    );
  }

  @override
  Future<User> putById(String id, {Map<String, dynamic> data}) {
    return cPut<User>(
      api: "/user/id/" + id,
      converter: (body) => body.readAsUser,
      body: data,
    );
  }

  @override
  Future<List<User>> getAll() {
    return cGet<List<User>>(
      api: "/users/",
      converter: (body) => body.readAsListUser,
    );
  }

  @override
  Future<List<User>> getByKeys(List<String> yourListUniqueKey, [List<Map<String, dynamic>> bodys]) {
    return cPost<List<User>>(
      api: "/user/keys/",
      body: {"keys": yourListUniqueKey, "bodys": bodys},
      converter: (body) => body.readAsListUser,
    );
  }
}
