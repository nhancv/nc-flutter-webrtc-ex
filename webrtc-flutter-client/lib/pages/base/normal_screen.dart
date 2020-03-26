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
import 'package:nft/pages/search/search_screen.dart';
import 'package:nft/utils/app_asset.dart';
import 'package:nft/widgets/screen_widget.dart';
import 'package:nft/widgets/sns_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NormalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: Column(children: <Widget>[
        SnSIconAppBar(
          left: Pair(AppImages.icSearch, () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SearchScreen()));
          }),
          center: 'Home',
          right: Pair(AppImages.icNoti, () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SearchScreen()));
          }),
        ),
        Expanded(
          child: _body(),
        ),
      ]),
    );
  }

  Widget _body() {
    return Container();
  }
}
