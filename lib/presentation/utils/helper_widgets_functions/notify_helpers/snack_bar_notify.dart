import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SnackBarNotify {
  static final random = Random();

  getSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      content: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: message,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                icon: const Icon(CupertinoIcons.xmark_circle))
          ],
        ),
        SizedBox(
          height: 200,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset(
              'assets/gifs/gif_(${random.nextInt(6)}).gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ]),
    ));
  }
}
