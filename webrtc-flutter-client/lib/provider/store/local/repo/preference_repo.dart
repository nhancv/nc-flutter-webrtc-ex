/*
 * Developed by Nhan Cao on 12/24/19 3:56 PM.
 * Last modified 12/24/19 3:56 PM.
 */

import 'package:sqflite/sqlite_api.dart';

import 'base_model.dart';
import 'base_repo.dart';

class PreferenceModel implements BaseModel<PreferenceModel> {
  String id;
  String data;

  PreferenceModel({this.id, this.data});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'data': data};
    return map;
  }

  PreferenceModel fromMap(Map<String, dynamic> map) {
    id = map['id'];
    data = map['data'];
    return this;
  }
}

class PreferenceRepo extends BaseRepo<PreferenceModel> {
  static final String repoName = "preference_repo";

  // Static pref key
  static final String authTokenId = "auth_token_id";

  @override
  Future<bool> create(Batch batch) async {
    batch.execute('''CREATE TABLE $repoName (
                                id TEXT PRIMARY KEY, 
                                data TEXT
                                )''');
    return true;
  }

  @override
  String getRepoName() {
    return repoName;
  }

  @override
  PreferenceModel fromMap(Map<String, dynamic> map) {
    return PreferenceModel().fromMap(map);
  }

  @override
  Map toMap(PreferenceModel item) {
    return item.toMap();
  }
}
