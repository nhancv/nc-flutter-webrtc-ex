/*
 * Developed by Nhan Cao on 12/26/19 4:03 PM.
 * Last modified 12/26/19 3:43 PM.
 */

import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

import 'base_model.dart';
import 'base_repo.dart';

class TaskModel extends BaseModel<TaskModel> {
  String id = Uuid().v1();
  String lot = "default";
  String body;
  int created = DateTime.now().microsecondsSinceEpoch;

  TaskModel({String id, String lot, String body}) {
    if (id != null) this.id = id;
    if (lot != null) this.lot = lot;
    if (body != null) this.body = body;
  }

  @override
  String toString() {
    return 'QueueModel{id: $id, lot: $lot, body: $body, created: $created';
  }

  @override
  TaskModel fromMap(Map<String, dynamic> map) {
    id = map['id'];
    lot = map['lot'];
    body = map['body'];
    created = map['created'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'lot': lot, 'body': body, 'created': created};
    return map;
  }
}

class QueueRepo extends BaseRepo<TaskModel> {
  static final String repoName = "queue_repo";

  @override
  Future<bool> create(Batch batch) async {
    batch.execute('''CREATE TABLE $repoName (
                                id TEXT PRIMARY KEY, 
                                lot TEXT,
                                body TEXT,
                                created INTEGER
                                )''');

    return true;
  }

  @override
  String getRepoName() {
    return repoName;
  }

  @override
  Map toMap(TaskModel item) {
    return item.toMap();
  }

  @override
  TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel().fromMap(map);
  }
}
