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

import 'dart:ui' as ui;

import 'package:bflutter/bflutter.dart';
import 'package:bflutter/libs/bcache.dart';
import 'package:bflutter/provider/main_bloc.dart';
import 'package:bflutter/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nft/pages/home/call_sample.dart';
import 'package:nft/pages/home/home_screen.dart';
import 'package:nft/provider/i18n/app_localizations.dart';
import 'package:nft/provider/store/store.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
Future<void> myMain() async {
  // @nhancv 2019-10-24: Start services later
  WidgetsFlutterBinding.ensureInitialized();

  // @nhancv 12/27/2019: Start store
  await DefaultStore.instance.init(databaseName: "flutter_webrtc.db");
//  await DefaultStore.instance.logout();
//  BullMQ.instance.start();

  // @nhancv 10/23/2019: Init bflutter caching
  await BCache.instance.init();
  // @nhancv 10/23/2019: Run Application
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final mainBloc = MainBloc.instance;

  @override
  Widget build(BuildContext context) {
    /**
     * App flow:
     * - First, login
     * - Second, navigate to Home with auto fetch github info
     * - Then, navigate Search screen
     * - Last, navigate to Detail screen
     */
    return StreamBuilder(
        stream: mainBloc.localeBloc.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            locale: (snapshot.hasData
                ? snapshot.data
                : Locale(ui.window.locale?.languageCode ?? ' en')),
            supportedLocales: [
              const Locale('en'),
              const Locale('vi'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AppContent(),
          );
        });
  }
}

class AppContent extends StatelessWidget {
  final mainBloc = MainBloc.instance;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
//          HomeScreen(),
          CallSample(ip: '192.168.1.247'),
          StreamBuilder(
            stream: mainBloc.appLoading.stream,
            builder: (context, snapshot) =>
                snapshot.hasData && snapshot.data ? AppLoading() : SizedBox(),
          ),
        ],
      ),
    );
  }

  // @nhancv 10/25/2019: After widget initialized.
  void onAfterBuild(BuildContext context) {
    mainBloc.initContext(context);
  }
}
