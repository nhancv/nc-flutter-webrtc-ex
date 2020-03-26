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

import 'package:nft/models/remote/user.dart';
import 'package:nft/pages/detail/detail_bloc.dart';
import 'package:nft/widgets/bapp_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Detail screen
/// Get user id from search screen
/// Get user info via github public api
class DetailScreen extends StatelessWidget {
  final User userBase;

  final bloc = DetailBloc();

  DetailScreen({Key key, @required this.userBase}) : super(key: key) {
    if (userBase?.login?.isNotEmpty ?? false) {
      bloc.getUserInfo.push(userBase.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: "Detail Screen"),
      body: userBase?.login?.isEmpty == null
          ? Container(child: Text('user empty'))
          : Column(
              children: <Widget>[
                Container(
                  child: StreamBuilder(
                    stream: bloc.loading.stream,
                    builder: (context, loading) {
                      if (loading.hasData && loading.data) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: bloc.getUserInfo.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data.avatarUrl),
                            radius: 50.0,
                          ),
                          Text(json.encode(snapshot.data))
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
