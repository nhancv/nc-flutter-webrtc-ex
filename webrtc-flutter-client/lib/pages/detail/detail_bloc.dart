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

import 'package:bflutter/bflutter.dart';
import 'package:nft/models/remote/user_detail.dart';
import 'package:nft/provider/store/remote/detail_api.dart';
import 'package:rxdart/rxdart.dart';

/// Implement logic for Detail screen
class DetailBloc {
  final loading = BlocDefault<bool>();
  final getUserInfo = Bloc<String, UserDetail>();

  final detailApi = DetailApi();

  DetailBloc() {
    _initLogic();
  }

  // @nhancv 10/7/2019: Init logic
  void _initLogic() {
    getUserInfo.logic = (Observable<String> input) => input
        .map((input) {
          loading.push(true);
          return input;
        })
        .asyncMap(detailApi.getUserInfo)
        .asyncMap(
          (data) {
            return UserDetail.fromJson(data.data);
          },
        )
        .handleError((error) {
          loading.push(false);
          throw error;
        })
        .doOnData((data) {
          loading.push(false);
        });
  }

  void dispose() {
    loading.dispose();
    getUserInfo.dispose();
  }
}
