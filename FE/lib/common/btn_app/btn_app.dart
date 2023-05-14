import 'package:flutter/material.dart';

import '../style.dart';

class BtnAppWidget extends StatefulWidget {
  final Function? onPressed;
  final Widget? iconBtn;
  final String? labelBtn;
  final Color? colorBtn;
  final int? selectBtn;
  const BtnAppWidget({super.key, required this.onPressed, this.iconBtn, this.labelBtn, this.colorBtn, this.selectBtn});
  @override
  State<BtnAppWidget> createState() => _BtnAppWidgetState();
}

class _BtnAppWidgetState extends State<BtnAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 25),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: widget.colorBtn ?? const Color(0xff6C92D0), borderRadius: BorderRadius.circular(8)),
        //Nếu selectBtn khác null thì sẽ render ra button không có icon
        child: (widget.selectBtn != null) ? renderBtnNoIcon(context) : renderBtnIcon(context));
  }

  renderBtnNoIcon(context) {
    return TextButton(
      child: Text(
        widget.labelBtn ?? "",
        style: textBtnWhite,
      ),
      onPressed: () {
        widget.onPressed!();
      },
    );
  }

  renderBtnIcon(context) {
    return TextButton.icon(
      onPressed: () {
        widget.onPressed!();
      },
      icon: widget.iconBtn!,
      label: Text(
        widget.labelBtn ?? "",
        style: textBtnWhite,
      ),
    );
  }
}
