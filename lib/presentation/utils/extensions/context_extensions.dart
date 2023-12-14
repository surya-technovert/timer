import 'dart:ui';

import 'package:flutter/material.dart';

extension ContextExtentions on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;

  Color get primartyColor => Theme.of(this).primaryColor;

  Color get inversePrimary => Theme.of(this).colorScheme.inversePrimary;

  Widget get displayLoading => Scaffold(
        body: Stack(
          children: <Widget>[
            ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.asset('assets/icon/icon.png'))),
            Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(238, 238, 238, 1)
                            .withOpacity(0.5)),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
