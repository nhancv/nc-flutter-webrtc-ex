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

import 'dart:convert';

import 'package:bflutter/bflutter.dart';
import 'package:bflutter/libs/bcache.dart';
import 'package:nft/models/remote/net_cache.dart';
import 'package:nft/models/remote/user.dart';
import 'package:nft/provider/store/remote/search_api.dart';
import 'package:rxdart/rxdart.dart';

/// Implement logic for Search screen
class SearchBloc {
  final loading = BlocDefault<bool>();
  final searchUser = Bloc<String, NetCache<List<User>>>();

  final searchApi = SearchApi();

  SearchBloc() {
    _initLogic();
  }

  void _initLogic() {
    searchUser.logic = (Observable<String> input) => input
            .distinct()
            .debounceTime(Duration(milliseconds: 500))
            .flatMap((input) {
          // @nhancv 10/7/2019: Show loading
          loading.push(true);
          if (input.isEmpty) return Observable.just(null);

          // @nhancv 10/7/2019: Combine with cache data
          return Observable<NetCache<List<User>>>.merge([
            // Get data from api
            Observable.fromFuture(searchApi.searchUsers(input))
                .asyncMap((data) async {
              print('From net: $data');
              if (data == null) {
                return NetCache(fromNet: true, data: <User>[]);
              }
              if (data.statusCode == 200) {
                final List<User> result = data.data['items']
                    .cast<Map<String, dynamic>>()
                    .map<User>((item) => User.fromJson(item))
                    .toList();
                // @nhancv 10/7/2019: Storage data from network to local
                await BCache.instance
                    .insert(Piece(id: input, body: jsonEncode(data.data)));

                // @nhancv 10/7/2019: Return latest data from network
                return NetCache(fromNet: true, data: result);
              } else {
                throw (data.data);
              }
            }).handleError((error) {}),
            // Get data from local storage
            Observable.fromFuture(BCache.instance.queryId(input)).map((data) {
              print('From cache: $data');
              if (data == null) {
                return NetCache(data: <User>[]);
              }
              List<User> result = json
                  .decode(data.body)['items']
                  .cast<Map<String, dynamic>>()
                  .map<User>((item) => User.fromJson(item))
                  .toList();
              return NetCache(data: result);
            })
          ]);
        }).handleError((error) {
          // @nhancv 10/7/2019: Hide loading
          loading.push(false);
          throw error;
        }).doOnData((data) {
          // @nhancv 10/7/2019: Hide loading
          loading.push(false);
        });
  }

  /// @nhancv 10/7/2019: Dispose bloc
  void dispose() {
    loading.dispose();
    searchUser.dispose();
  }
}
