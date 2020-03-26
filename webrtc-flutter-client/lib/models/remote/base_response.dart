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
 */
import 'dart:core';

abstract class BaseResponse<T> {
  bool error;
  T data;
  List<BaseError> errors;

  BaseResponse(Map<String, dynamic> fullJson) {
    parsing(fullJson);
  }

  /// @nhancv 12/6/2019: Abstract json to data
  T jsonToData(Map<String, dynamic> fullJson);
  /// @nhancv 12/6/2019: Abstract data to json
  dynamic dataToJson(T data);

  /// @nhancv 12/6/2019: Parsing data to object
  parsing(Map<String, dynamic> fullJson) {
    error = fullJson["error"] ?? false;
    data = jsonToData(fullJson);
    errors = parseErrorList(fullJson);
  }

  /// @nhancv 12/6/2019: Parse error list from server
  List<BaseError> parseErrorList(Map<String, dynamic> fullJson) {
    List errors = fullJson["errors"];
    return errors != null
        ? List<BaseError>.from(errors.map((x) => BaseError.fromJson(x)))
        : <BaseError>[];
  }

  /// @nhancv 12/6/2019: Data to json
  Map<String, dynamic> toJson() => {
    "error": error,
    "data": dataToJson(data),
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
  };
}

class BaseError {
  int code;
  String message;

  BaseError({
    this.code,
    this.message,
  });

  factory BaseError.fromJson(Map<String, dynamic> json) => BaseError(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
