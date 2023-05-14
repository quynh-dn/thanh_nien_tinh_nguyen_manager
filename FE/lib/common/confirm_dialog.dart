import 'package:flutter/material.dart';
import 'package:haivn/common/style.dart';

Future<void> showConfirmDialog(
    {String? title, String? content, function, context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Container(
              width: 75,
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset('images/logo.png'),
            ),
            Text(
              title!,
              style: titlePage,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  content ?? '',
                  style: textNormal,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Hủy'),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              function();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      );
    },
  );
}
