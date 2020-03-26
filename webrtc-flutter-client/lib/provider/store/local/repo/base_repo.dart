/*
 * Developed by Nhan Cao on 12/24/19 11:29 AM.
 * Last modified 12/24/19 11:29 AM.
 */

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqlite_api.dart';

import '../local_provider.dart';

abstract class IWrite<T> {
  Future<bool> create(Batch batch);

  Future<int> insert(T item);

  Future<List<dynamic>> insertAll(List<T> items);

  Future<int> update(T item);

  Future<int> delete(String id);
}

abstract class IRead<T> {
  Future<List<T>> find({String where, List whereArgs});

  Future<T> findOne(String id);
}

abstract class BaseRepo<T> implements IWrite<T>, IRead<T> {
  Database database = LocalProvider.instance.database;

  String getRepoName();

  Map toMap(T item);

  T fromMap(Map<String, dynamic> map);

  @override
  Future<int> insert(T item) async {
    return await database.insert(getRepoName(), toMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<dynamic>> insertAll(List<T> items) async {
    final Batch batch = database.batch();

    for (var item in items) {
      batch.insert(getRepoName(), toMap(item),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    List res = (await batch.commit(continueOnError: true)).map((d) {
      if (d is DatabaseException) {
        debugPrint(d.toString());
        return -1;
      }
      return d;
    }).toList();
    return res;
  }

  @override
  Future<int> update(T item) async {
    return await database.update(getRepoName(), toMap(item));
  }

  @override
  Future<int> delete(String id) async {
    return await database
        .delete(getRepoName(), where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<T>> find({where, whereArgs}) async {
    List<Map> results =
        await database.query(getRepoName(), where: where, whereArgs: whereArgs);
    // Convert the List<Map<String, dynamic> into a List<T>.
    return List.generate(results.length, (i) => fromMap(results[i]));
  }

  @override
  Future<T> findOne(String id) async {
    List<Map> results =
        await database.query(getRepoName(), where: "id = ?", whereArgs: [id]);
    if (results.length == 0) return null;
    List<T> data = List.generate(results.length, (i) => fromMap(results[i]));
    return data[0];
  }
}
