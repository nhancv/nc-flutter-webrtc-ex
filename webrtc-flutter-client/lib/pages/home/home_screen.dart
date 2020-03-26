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

import 'package:nft/models/remote/user_detail.dart';
import 'package:nft/pages/home/home_bloc.dart';
import 'package:nft/pages/search/search_screen.dart';
import 'package:nft/widgets/bapp_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Home screen
/// Auto get github user info

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: "Home screen"),
      body: _HomeInfo(),
    );
  }
}

class _HomeInfo extends StatefulWidget {
  @override
  __HomeInfoState createState() => __HomeInfoState();
}

class __HomeInfoState extends State<_HomeInfo> {
  var bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _onResume();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: bloc.getUserInfo.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                UserDetail user = snapshot.data;
                return Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.avatarUrl),
                      radius: 50.0,
                    ),
                    Text(json.encode(snapshot.data))
                  ],
                );
              },
            ),
            RaisedButton(
              child: Text('Search Screen'),
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );

    // on Resume
    _onResume();
  }

  _onResume() {
    bloc.getHomeInfo();
  }
}
