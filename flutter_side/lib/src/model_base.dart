abstract class MongooModel {
  String _id;
  int __v;
  String get documentId => _id;
  int get dataVersion => __v;

  bool get isLocalModel => _id == null;

  MongooModel();
  MongooModel.fromJson(jsonData) {
    this._id = jsonData['_id'];
    this.__v = jsonData['__v'];
  }

  Map<String, dynamic> get toMap;
}
