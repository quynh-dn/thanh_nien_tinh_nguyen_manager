import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/model.dart';
import 'style.dart';

class BreadCrumb extends StatelessWidget {
  final dynamic listPreTitle;
  final String content;
  final Widget? widgetBoxRight;

  const BreadCrumb({Key? key, this.listPreTitle, this.widgetBoxRight, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contentEnd = content.toUpperCase();
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (int i = 0; i < listPreTitle.length; i++)
                  Row(
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            context.go("${listPreTitle[i]['url']}");
                          },
                          child: Text(
                            listPreTitle[i]['title'],
                            style: const TextStyle(color: Color.fromARGB(255, 151, 151, 151)),
                          )),
                      i < listPreTitle.length - 1
                          ? const SizedBox(
                              child: Text(
                              '>>',
                              style: TextStyle(color: Color.fromARGB(255, 151, 151, 151)),
                            ))
                          : Container()
                    ],
                  ),
              ],
            ),
            content != null
                ? Container(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      contentEnd,
                      style: titleWidget,
                    ),
                  )
                : Container(),
          ],
        ),
        widgetBoxRight != null ? Container(margin: const EdgeInsets.only(right: 20), child: widgetBoxRight!) : Container(),
      ]),
    );
  }
}
