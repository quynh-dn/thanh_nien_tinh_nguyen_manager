import 'package:flutter/material.dart';
import 'package:haivn/common/common_app/common_app.dart';

import '../style.dart';

showdialogWidget(context, callback, title, content) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 280,
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 130,
                  color: Color(0xffF59A23),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$title",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                CommonApp().sizeBoxWidget(height: 10),
                Text(
                  "$content",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            CommonApp().sizeBoxWidget(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 175,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xffF9BCBF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    child: Text(
                      "Hủy bỏ",
                      style: textBtnWhite,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: 175,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xff6C92D0),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: TextButton(
                    child: Text(
                      "Xác nhận",
                      style: textBtnWhite,
                    ),
                    onPressed: callback,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
