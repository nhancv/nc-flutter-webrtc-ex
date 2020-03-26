/*
 * Developed by Nhan Cao on 10/28/19 12:19 AM.
 * Last modified 10/28/19 12:19 AM.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';

import 'bull_mq.dart';
import 'local/local_provider.dart';
import 'local/repo/preference_repo.dart';
import 'local/repo/queue_repo.dart';

abstract class Store {
  Future<void> init();

  // Table Preference
  Future<bool> savePref(String key, String value);

  Future<String> getPref(String key);

  Future<bool> removePref(String key);

  Future<bool> saveAuthToken(String token);

  Future<String> getAuthToken();

  // Table Queue
  Future<List<TaskModel>> getAllTaskInQueue();

  Future<bool> saveTaskModel(TaskModel item);

  Future<bool> removeTaskModel(String taskId);

  // Clear all database as logout function
  Future<void> clearAll();

  // Clear credentials
  Future<void> logout();
}

class DefaultStore implements Store {
  DefaultStore._private();

  static final DefaultStore instance = DefaultStore._private();

  Database database;

  @override
  Future<void> init({String databaseName = "database.db"}) async {
    database = await LocalProvider.instance.init(databaseName: databaseName);
    debugPrint('Database version ${await database.getVersion()}');
  }

  @override
  Future<void> clearAll() async {
    await database.delete(PreferenceRepo.repoName);
    await database.delete(QueueRepo.repoName);
  }

  @override
  Future<void> logout() async {
    await removePref(PreferenceRepo.authTokenId);
  }

  /// For test only
  Future<void> runTest() async {
    debugPrint('RUN TEST');

    // @nhancv 12/26/2019: Clear database
    await clearAll();

    // @nhancv 12/25/2019: test preference
    final fakeToken = 'fake_token';
    await saveAuthToken(fakeToken);
    assert(await getAuthToken() == fakeToken);

    // @nhancv 12/26/2019: test queue
    final fakeTask0 = TaskModel(
        body: jsonEncode({
      'url': 'beesightsoft.com',
      'header': null,
      'method': 'GET',
      'body': null
    }));
    final fakeTask1 = TaskModel();
    final fakeTask2 = TaskModel();
    await saveTaskModel(fakeTask0);
    final queue = await getAllTaskInQueue();
    print('List task: ${queue.length}');
    queue.forEach((d) {
      print(d.toMap());
    });
    assert(queue.length == 1);
    assert(queue[0].id == fakeTask0.id);

    debugPrint('TEST DONE');
    // @nhancv 12/26/2019: Add fake task in delay 5 second to test BullMQ
    debugPrint('START BULLMQ');
    BullMQ.instance.start();

    Timer(Duration(milliseconds: 5000), () async {
      await saveTaskModel(fakeTask0);
    });
    Timer(Duration(milliseconds: 5001), () async {
      await saveTaskModel(fakeTask1);
    });
    Timer(Duration(milliseconds: 6000), () async {
      await saveTaskModel(fakeTask2);
    });
  }

  @override
  Future<String> getPref(String key) async {
    final pref = await PreferenceRepo().findOne(key);
    if (pref != null) return pref.data;
    return null;
  }

  @override
  Future<bool> savePref(String key, String value) async {
    var pref = PreferenceRepo().fromMap({'id': key, 'data': value});
    return await PreferenceRepo().insert(pref) > 0;
  }

  @override
  Future<bool> removePref(String key) async {
    return await PreferenceRepo().delete(key) > 0;
  }

  @override
  Future<String> getAuthToken() async {
    return getPref(PreferenceRepo.authTokenId);
  }

  @override
  Future<bool> saveAuthToken(String token) async {
    return await savePref(PreferenceRepo.authTokenId, token);
  }

  @override
  Future<List<TaskModel>> getAllTaskInQueue() async {
    return await QueueRepo().find();
  }

  @override
  Future<bool> saveTaskModel(TaskModel item) async {
    int res = await QueueRepo().insert(item);
    return res > 0;
  }

  @override
  Future<bool> removeTaskModel(String taskId) async {
    int res = await QueueRepo().delete(taskId);
    return res > 0;
  }
}
