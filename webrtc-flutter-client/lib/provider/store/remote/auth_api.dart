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

import 'package:nft/provider/store/remote/api.dart';
import 'package:dio/dio.dart';

class AuthApi extends Api {
  /// @nhancv 10/24/2019: Login
  Future<Response> signIn() async {
    final header = await getHeader();
    return wrapE(() => dio.post("https://nhancv.free.beeceptor.com/login",
        options: Options(headers: header),
        data: json.encode({
          "username": "username",
          "password": "password",
        })));
  }

  /// @nhancv 10/24/2019: Login
  Future<Response> signInWithError() async {
    final header = await getHeader();
    return wrapE(() => dio.post("https://nhancv.free.beeceptor.com/login-err",
        options: Options(headers: header),
        data: json.encode({
          "username": "username",
          "password": "password",
        })));
  }
}
