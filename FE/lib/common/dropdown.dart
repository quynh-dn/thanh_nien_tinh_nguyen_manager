import 'package:flutter/material.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: must_be_immutable
class DropdownBtn extends StatefulWidget {
  List<dynamic>? listItem;
  dynamic selectedValue;
  String? hintText;
  double? width;
  Function function;
  BoxDecoration? decoration;
  DropdownBtn(
      {super.key,
      this.listItem,
      required this.function,
      this.selectedValue,
      this.width,
      this.hintText,
      this.decoration});

  @override
  State<DropdownBtn> createState() => _DropdownBtnState();
}

class _DropdownBtnState extends State<DropdownBtn> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            widget.hintText ?? 'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          searchInnerWidget: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 40,
              child: TextFormField(
                controller: search,
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ), // icon is 48px widget.
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Colors.black45)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Colors.black45)),
                  isDense: true,
                  hintText: 'Tìm kiếm',
                ),
              ),
            ),
          ),
          searchController: search,
          searchMatchFn: (item, searchValue) {
            String itemValue =
                TiengViet.parse(item.key.toString().toLowerCase())
                    .substring(3, item.key.toString().length - 3);
            String searchText = TiengViet.parse(searchValue.toLowerCase());
            return itemValue.contains(searchText);
          },
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              search.clear();
            }
          },
          buttonPadding: const EdgeInsets.all(10),
          items: [
            for (var row in widget.listItem!)
              DropdownMenuItem(
                key: Key(row['name']),
                value: row['value'],
                child: Text(
                  row['name'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              )
          ],
          buttonDecoration: widget.decoration,
          value: widget.selectedValue,
          onChanged: (value) {
            setState(() {
              widget.selectedValue = value;
            });
            widget.function(value);
          },
          buttonHeight: 40,
          itemHeight: 40,
          buttonElevation: 0,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownElevation: 5,
          focusColor: Colors.white,
          dropdownMaxHeight: 300,
        ),
      ),
    );
  }
}
