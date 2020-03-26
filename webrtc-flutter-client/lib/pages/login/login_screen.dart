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

import 'package:bflutter/bflutter.dart';
import 'package:bflutter/widgets/app_network.dart';
import 'package:nft/pages/login/login_bloc.dart';
import 'package:nft/provider/i18n/app_localizations.dart';
import 'package:nft/widgets/bapp_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final mainBloc = MainBloc.instance;
  final bloc = LoginBloc();
  final FocusNode _focusPasswordSignIn = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BAppBar(
        text: AppLocalizations.of(context).translate('title'),
      ),
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            AppNetwork(),
            Container(
              // @nhancv 10/25/2019: Request color to get gesture tab
              color: Colors.transparent,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: 384.0,
                  margin: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 10,
                        offset: Offset(0, 9),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      buildTextLabel("Please enter username"),
                      buildUserNameField(context),
                      buildTextLabel("Please enter password"),
                      buildPasswordField(context),
                      buildLoginButton(context),
                      FlatButton(
                        child: Text('lang'),
                        onPressed: () {
                          final currentLocale =
                              AppLocalizations.of(context).locale;
                          if (currentLocale == Locale('en')) {
                            mainBloc.localeBloc.push(Locale('vi'));
                          } else {
                            mainBloc.localeBloc.push(Locale('en'));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          closeKeyboard(context);
        },
      ),
    );
  }

  /// @hieu.nguyen 10/24/2019: build text label.
  Widget buildTextLabel(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 0, 0),
      child: Container(
        width: 184.0,
        height: 24.0,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.grey[900],
              fontSize: 16.0,
              fontFamily: 'SF-Pro-Text-Bold'),
        ),
      ),
    );
  }

  /// @hieu.nguyen 10/24/2019: build block user name.
  Widget buildUserNameField(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 16.0, 0),
      child: Container(
        width: 344.0,
        height: 44.0,
        child: TextField(
          onChanged: bloc.usernameInput.push,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none,
            ),
            hintText: "username",
            fillColor: Colors.grey[50],
          ),
          onSubmitted: (text) {
            FocusScope.of(context).requestFocus(_focusPasswordSignIn);
          },
        ),
      ),
    );
  }

  /// @hieu.nguyen 10/24/2019: build block password.
  Widget buildPasswordField(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 16.0, 32),
      child: Container(
        width: 344.0,
        height: 44.0,
        child: TextField(
          onChanged: bloc.passwordInput.push,
          focusNode: _focusPasswordSignIn,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide.none),
            hintText: "password",
            fillColor: Colors.grey[50],
          ),
          obscureText: true,
          onSubmitted: (text) {
            closeKeyboard(context);
            bloc.loginTrigger.push(true);
          },
        ),
      ),
    );
  }

  /// @hieu.nguyen 10/24/2019: build login button.
  Widget buildLoginButton(context) {
    return Center(
      child: Container(
        width: 144.0,
        height: 40.0,
        margin: EdgeInsets.only(bottom: 32),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: StreamBuilder(
            stream: bloc.validInput.stream,
            builder: (context, snapshot) {
              return RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                color: Color.fromRGBO(42, 194, 208, 1),
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'SF-Pro-Text-Bold'),
                ),
                onPressed: (snapshot.hasData && snapshot.data)
                    ? () {
                        closeKeyboard(context);
                        bloc.loginTrigger.push(true);
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  // @nhancv 2019-10-28: Close keyboard
  void closeKeyboard(context) {
    FocusScope.of(context).unfocus();
  }
}
