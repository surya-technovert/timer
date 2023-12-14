import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDialog extends ConsumerStatefulWidget {
  final Exception exception;
  final StackTrace stackTrace;
  const ErrorDialog(this.exception, this.stackTrace, {super.key});

  @override
  ConsumerState<ErrorDialog> createState() => _ErrorDailogState();
}

class _ErrorDailogState extends ConsumerState<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Container(
                    width: 400.0,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(238, 238, 238, 1)
                            .withOpacity(0.5)),
                    child: Center(
                        child: ListView(children: [
                      Text(
                        widget.exception.toString(),
                      ),
                      Text(widget.stackTrace.toString())
                    ])),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
