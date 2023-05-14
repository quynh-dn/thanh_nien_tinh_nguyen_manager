
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckBoxWidget extends StatefulWidget {
  final List<Widget>? widgetTitle;
  Function? functionCheckBox;
  Widget? lable;
  final bool? isChecked;
  CheckBoxWidget({
    Key? key,
    this.widgetTitle,
    this.functionCheckBox,
    this.isChecked,
    this.lable,
  }) : super(key: key);
  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool isChecked = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: widget.isChecked,
          onChanged: (bool? value) {
            setState(() {
              widget.functionCheckBox!(value);
              // isChecked = value!;
            });
          },
        ),
        const SizedBox(
          width: 3,
        ),
        Expanded(child: widget.lable!),
        // Row(
        //   children: widget.widgetTitle!,
        // )
      ],
    );
  }
}
