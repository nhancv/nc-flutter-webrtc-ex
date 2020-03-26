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

import 'dart:async';
import 'dart:io';

/// @nhancv 10/24/2019:
/// Setup PATH point to: flutter\bin\cache\dart-sdk\bin
/// * Run:
/// * dart rename_file.dart

// @nhancv 10/24/2019: Get file in directory
Future<List<FileSystemEntity>> dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file),
      // should also register onError
      onDone: () => completer.complete(files));
  return completer.future;
}

// @nhancv 10/24/2019: Convert abcXyz.png = to abc_xyz.png
// From: addNew.png
// => add_new.png
void renameFile(List<FileSystemEntity> fileList) {
  fileList.forEach((f) {
    // @nhancv 10/24/2019: Parse with template abcXyz.png
    RegExp pattern = RegExp(r'[a-z]{0,}[A-Z].{0,}.png');
    String fileName = pattern.stringMatch(f.path);
    if (fileName != null) {
      String newName = fileName.splitMapJoin(RegExp(r'[A-Z]+'),
          onMatch: (m) => '_${m.group(0).toLowerCase()}', onNonMatch: (n) => n);
      String newFilePath = f.path.replaceAll(pattern, newName);
      f.renameSync(newFilePath);
    }
  });
}

void main() async {
  List<FileSystemEntity> fileList =
      await dirContents(Directory('../../assets/images/'));
  renameFile(fileList);
}
