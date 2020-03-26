/*
 * MIT License
 *
 * Copyright (c) 2020 Nhan Cao
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nft/provider/store/store.dart';

import 'local/repo/queue_repo.dart';

class BullMQ {
  BullMQ._private();
  static final BullMQ instance = BullMQ._private();

  /// @nhancv 12/26/2019: If this flag = true, the next schedule run in 0 second delay
  bool pushHasChanged = false;

  /// @nhancv 12/26/2019: Auto to start queue with delay 5 seconds later
  void start({delayInSecond = 0}) async {
    await Future.delayed(Duration(seconds: delayInSecond));
    await _queueProcessing();
    start(delayInSecond: this.pushHasChanged ? 0 : 5);
  }

  // @nhancv 12/26/2019: Processing
  Future<void> _queueProcessing() async {
    Store store = DefaultStore.instance;
    if (store == null) return;
    List<TaskModel> queue = await store.getAllTaskInQueue();
    if (queue.length > 0) {
      debugPrint('Total task in queue: ${queue.length}');
      for (TaskModel task in queue) {
        debugPrint('Task is processing: ${task.id}');
        await store.removeTaskModel(task.id);
        debugPrint('Task has completed: ${task.id}');
      }
    }
  }
}
