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

import 'package:bflutter/libs/pair.dart';
import 'package:flutter/material.dart';

import '../utils/app_asset.dart';
import 'divider_line.dart';
import 'empty_icon.dart';
import 'widget_util.dart';

class BaseAppBar extends StatelessWidget {
  final Widget left;
  final Widget center;
  final Widget right;

  BaseAppBar({Key key, this.left, this.center, this.right}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Container(
        padding: EdgeInsets.only(top: WidgetUtil.resizeByWidth(context, 20)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                left ?? Container(),
                Spacer(),
                center ?? Container(),
                Spacer(),
                right ?? Container()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DividerLine()
          ],
        ),
      ),
    );
  }
}

class SnSAppBar extends StatelessWidget {
  final Widget left;
  final String center;
  final Widget right;

  const SnSAppBar({Key key, this.left, this.center, this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      left: Navigator.canPop(context)
          ? IconButton(
              icon: Image.asset(AppImages.icBack),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : left ?? EmptyIcon(),
      center: Text(center ?? '',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: AppFonts.AvenirNextLTProBold,
            fontWeight: FontWeight.w700,
          )),
      right: right ?? EmptyIcon(),
    );
  }
}

class SnSIconAppBar extends StatelessWidget {
  final Pair left; // img path, function
  final String center; // title
  final Pair right; // img path, function

  const SnSIconAppBar({Key key, this.left, this.center, this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      left: left != null
          ? IconButton(
              icon: Image.asset(left.left),
              onPressed: left.right,
            )
          : EmptyIcon(),
      center: Text(center ?? '',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: AppFonts.AvenirNextLTProBold,
            fontWeight: FontWeight.w700,
          )),
      right: right != null
          ? IconButton(
              icon: Image.asset(right.left),
              onPressed: right.right,
            )
          : EmptyIcon(),
    );
  }
}

class SnSTitleAppBar extends StatelessWidget {
  final Pair left; // title, function
  final String center; // title
  final Pair right; // title, function

  const SnSTitleAppBar({Key key, this.left, this.center, this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      left: left != null
          ? FlatButton(
              child: Text(
                left.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: AppFonts.AvenirNextLTProBold,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: left.right,
            )
          : EmptyIcon(),
      center: Text(center ?? '',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: AppFonts.AvenirNextLTProBold,
            fontWeight: FontWeight.w700,
          )),
      right: right != null
          ? FlatButton(
              child: Text(
                right.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: AppFonts.AvenirNextLTProBold,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: right.right,
            )
          : EmptyIcon(),
    );
  }
}
