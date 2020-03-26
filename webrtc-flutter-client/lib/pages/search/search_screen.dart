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

import 'package:nft/models/remote/net_cache.dart';
import 'package:nft/models/remote/user.dart';
import 'package:nft/pages/detail/detail_screen.dart';
import 'package:nft/pages/search/search_bloc.dart';
import 'package:nft/widgets/bapp_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Search screen
/// Get input from user
/// Call api to get data list
/// Render it
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: "Search screen"),
      body: _SearchInfo(),
    );
  }
}

class _SearchInfo extends StatefulWidget {
  @override
  ___SearchInfoState createState() => ___SearchInfoState();
}

class ___SearchInfoState extends State<_SearchInfo> {
  final bloc = SearchBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Expanded(
                  child: TextField(
                    onChanged: bloc.searchUser.push,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter a search term',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Divider(
              color: Colors.black,
            ),
          ),
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
              stream: bloc.searchUser.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Text('No data');
                }
                // @nhancv 10/7/2019: Get data
                NetCache<List<User>> netCacheData = snapshot.data;
                if (!netCacheData.hasData ||
                    (netCacheData?.data)?.length == 0) {
                  return Text('No data');
                }
                List<User> users = netCacheData.data;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FlatButton(
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                users[index].avatarUrl),
                            radius: 20.0,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                '${users[index].login} (FromNet: ${netCacheData.fromNet})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(userBase: users[index])));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
