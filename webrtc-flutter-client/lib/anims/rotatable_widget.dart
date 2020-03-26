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

class RotatableWidget extends StatefulWidget {
  final Widget child;
  final bool rotate;

  RotatableWidget({this.rotate = false, this.child});

  @override
  _RotatableWidgetState createState() => _RotatableWidgetState();
}

class _RotatableWidgetState extends State<RotatableWidget>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  Animation<double> animation;
  Animation<double> turns;

  @override
  void initState() {
    super.initState();
    initAnimations();
    handleAnimations();
  }

  @override
  void didUpdateWidget(RotatableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleAnimations();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: turns, child: widget.child);
  }

  /// @cuongtlv on Feb/11/2020: Setting animations up
  void initAnimations() {
    rotationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    animation = CurvedAnimation(
      parent: rotationController,
      curve: Curves.easeInOutBack,
    );
    turns = Tween(begin: 0.0, end: 0.25).animate(animation);
  }

  /// @cuongtlv on Feb/11/2020: Handling expand status of the widget
  void handleAnimations() {
    if (widget.rotate) {
      rotationController.forward();
    } else {
      rotationController.reverse();
    }
  }
}
