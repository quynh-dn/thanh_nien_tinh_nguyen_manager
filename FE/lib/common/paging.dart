import 'package:flutter/material.dart';
import 'package:haivn/common/style.dart';

import 'dropdown.dart';

var listItemsRpp = [
  {'value': 2, 'name': '2'},
  {'value': 5, 'name': '5'},
  {'value': 10, 'name': '10'},
  {'value': 20, 'name': '20'},
  {'value': 50, 'name': '50'},
];

// ignore: must_be_immutable
class PagingTable extends StatefulWidget {
  PagingTable(
      {super.key,
      required this.page,
      required this.curentPage,
      required this.rowCount,
      required this.setCurentPage});
  int page;
  int curentPage;
  int rowCount;
  Function setCurentPage;
  @override
  State<PagingTable> createState() => _PagingTableState();
}

class _PagingTableState extends State<PagingTable> {
  late int startPage;
  late int endPage;

  @override
  Widget build(BuildContext context) {
    if (widget.curentPage == 1) {
      startPage = 1;
      endPage = 4;
    } else if (widget.curentPage == widget.page - 1 ||
        widget.curentPage == widget.page) {
      startPage = widget.page - 3;
      endPage = widget.page;
    } else {
      startPage = widget.curentPage - 1;
      endPage = widget.curentPage + 2;
    }

    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              'Tổng: ${widget.rowCount} bản ghi',
              style: textDropdownTitle,
            )),
        widget.rowCount != 0
            ? Expanded(
                flex: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            //<-- SEE HERE
                            side: const BorderSide(
                                width: 0.2, color: Color(0xff023E74)),
                          ),
                          onPressed: widget.curentPage != 1
                              ? () {
                                  widget.curentPage--;
                                  widget.setCurentPage(widget.curentPage);

                                  // setState(() {});
                                }
                              : null,
                          child: const Icon(Icons.chevron_left_outlined)),
                    ),
                    widget.page <= 5
                        ? Row(children: [
                            for (int i = 1; i <= widget.page; i++)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      //<-- SEE HERE
                                      side: const BorderSide(
                                          width: 0.2, color: Color(0xff023E74)),
                                      backgroundColor: i == widget.curentPage
                                          ? const Color(0xff023E74)
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      widget.curentPage = i;
                                      widget.setCurentPage(widget.curentPage);

                                      // setState(() {});
                                    },
                                    child: Text(
                                      '$i',
                                      style: TextStyle(
                                          color: i == widget.curentPage
                                              ? Colors.white
                                              : null),
                                    )),
                              ),
                          ])
                        : Row(children: [
                            for (int i = startPage; i < endPage; i++)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      //<-- SEE HERE
                                      side: const BorderSide(
                                          width: 0.2, color: Color(0xff023E74)),
                                      backgroundColor: i == widget.curentPage
                                          ? const Color(0xff023E74)
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      widget.curentPage = i;
                                      widget.setCurentPage(widget.curentPage);
                                      // setState(() {});
                                    },
                                    child: Text(
                                      '$i',
                                      style: TextStyle(
                                          color: i == widget.curentPage
                                              ? Colors.white
                                              : null),
                                    )),
                              ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    //<-- SEE HERE
                                    side: const BorderSide(
                                        width: 0.2, color: Color(0xff023E74)),
                                    // backgroundColor: i == curentPage
                                    //     ? const Color(0xff023E74)
                                    //     : Colors.white,
                                  ),
                                  onPressed: null,
                                  child: const Text(
                                    '...',
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    //<-- SEE HERE
                                    side: const BorderSide(
                                        width: 0.2, color: Color(0xff023E74)),
                                    backgroundColor:
                                        widget.page == widget.curentPage
                                            ? const Color(0xff023E74)
                                            : Colors.white,
                                  ),
                                  onPressed: () {
                                    widget.curentPage = widget.page;
                                    widget.setCurentPage(widget.curentPage);
                                    // setState(() {});
                                  },
                                  child: Text(
                                    '${widget.page}',
                                    style: TextStyle(
                                        color: widget.page == widget.curentPage
                                            ? Colors.white
                                            : null),
                                  )),
                            ),
                          ]),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            //<-- SEE HERE
                            side: const BorderSide(
                                width: 0.2, color: Color(0xff023E74)),
                          ),
                          onPressed: widget.curentPage != widget.page
                              ? () {
                                  widget.curentPage++;
                                  widget.setCurentPage(widget.curentPage);

                                  // setState(() {});
                                }
                              : null,
                          child: const Icon(Icons.chevron_right_outlined)),
                    ),
                  ],
                ))
            : Container()
      ],
    );
  }
}


