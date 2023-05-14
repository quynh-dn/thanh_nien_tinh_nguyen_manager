import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextBoxCustom extends StatefulWidget {
  TextEditingController? controller;
  double? width;
  double? height;
  String? lableText;
  String? hint;
  int? minLines;
  int? maxLines;
  Function? validator;
  bool? enabled;
  TextBoxCustom({super.key, this.controller, this.lableText, this.width, this.height, this.hint, this.maxLines, this.minLines, this.validator,this.enabled});

  @override
  State<TextBoxCustom> createState() => _TextBoxCustomState();
}

class _TextBoxCustomState extends State<TextBoxCustom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: widget.enabled??true,
                controller: widget.controller,
                minLines: widget.minLines ?? 1,
                maxLines: widget.maxLines ?? 1,
                decoration: InputDecoration(
                  labelText: widget.lableText,
                  border: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black45)),
                  contentPadding: EdgeInsets.symmetric(vertical: widget.maxLines == 1 || widget.maxLines == null ? 0 : 20, horizontal: 10),
                  hintText: widget.hint,
                ),
                validator: (String? value) => widget.validator!(value),
              ),
            ),
          ],
        ));
  }
}
