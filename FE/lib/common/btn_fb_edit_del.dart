import 'package:flutter/material.dart';

class RowBtnTable extends StatelessWidget {
  const RowBtnTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.red[100], borderRadius: BorderRadius.circular(5)),
            child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ))),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color(0xffFEE2B5),
                borderRadius: BorderRadius.circular(5)),
            child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.edit_calendar,
                  color: Color(0xffD97904),
                  size: 20,
                ))),
        Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color(0xffB3F1E2),
                borderRadius: BorderRadius.circular(5)),
            child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.edit_calendar,
                  color: Color(0xff007B57),
                  size: 20,
                )))
      ],
    );
  }
}
