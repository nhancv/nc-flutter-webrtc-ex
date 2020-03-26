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

import 'package:flutter/material.dart';

import '../utils/app_asset.dart';


class BAppBar extends AppBar {
  final String text;

  BAppBar({this.text})
      : super(
    backgroundColor: Color.fromARGB(255, 36, 55, 172),
    title: text != null
        ? Container(
        child: Text(text ?? "Flutter"), width: 123, height: 28)
        : Image.asset(AppImages.icAppIcon, width: 123, height: 28),
  );
}

class TwoLineAppBar extends AppBar {
  final String header;
  final String subTitle;

  TwoLineAppBar(this.header, this.subTitle)
      : super(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    automaticallyImplyLeading: false,
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          width: 40,
          height: 40,
          child: Navigator.canPop(context)
              ? RawMaterialButton(
            padding: EdgeInsets.zero,
            shape: CircleBorder(),
            child: new Container(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 24,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
              : null,
        );
      },
    ),
    title: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Text(header,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(118, 118, 118, 1.0),
                  fontFamily: AppFonts.AvenirNextLTProRegular,
                  fontWeight: FontWeight.w400,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(subTitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontFamily: AppFonts.AvenirNextLTProRegular,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 40,
          )
        ],
      )
    ],
  );
}
