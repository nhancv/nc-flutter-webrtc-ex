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

/*
Error
{
    "error": true,
    "data": null,
    "errors": [
        {
            "code": 1029,
            "message": "User not found!."
        }
    ]
}

Successful
{
    "token_type": "Bearer",
    "expires_in": 1295998,
    "access_token": "nhancv_dep_trai",
    "refresh_token": "call_nhancv_dep_trai"
}
 */

import 'base_response.dart';

class LoginResponse extends BaseResponse {
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  LoginResponse(Map<String, dynamic> fullJson) : super(fullJson) {
    tokenType= fullJson["token_type"];
    expiresIn= fullJson["expires_in"];
    accessToken= fullJson["access_token"];
    refreshToken= fullJson["refresh_token"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "token_type": tokenType,
      "expires_in": expiresIn,
      "access_token": accessToken,
      "refresh_token": refreshToken,
      ... super.toJson()
    };
  }

  @override
  Map<String, dynamic> dataToJson(data) {
    return null;
  }

  @override
  jsonToData(Map<String, dynamic> fullJson) {
    return null;
  }
}
