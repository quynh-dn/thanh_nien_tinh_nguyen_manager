// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';

import '../../../../api.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/style.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/status.dart';

class CapNhatChucVu extends StatefulWidget {
  ChucVu data;
  final Function callBack;
  CapNhatChucVu({Key? key, required this.data, required this.callBack}) : super(key: key);
  @override
  State<CapNhatChucVu> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<CapNhatChucVu> {
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  ChucVu data = ChucVu();
  TextEditingController name = TextEditingController();
  TextEditingController level = TextEditingController();

  Future<List<Status>> callStatus() async {
    var object = [
      {"id": 1, "name": "Hoạt động"},
      {"id": 0, "name": "Khoá"},
    ];

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
    name.text = data.name ?? "";
    level.text = data.level.toString();
    if (data.status == 1) {
      selectStatus = Status(id: 1, name: "Hoạt động");
    } else {
      selectStatus = Status(id: 0, name: "Khoá");
    }
  }

  @override
  void dispose() {
    name.dispose();
    level.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 300,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Thêm chức năng', style: textTitleAlertDialog),
              IconButton(onPressed: () => {Navigator.pop(context)}, icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Tên chức năng ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: name,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Cấp độ ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      TextBoxCustom(
                        controller: level,
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Trạng thái ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: DropdownSearch<Status>(
                    selectedItem: selectStatus,
                    asyncItems: (String? filter) => callStatus(),
                    itemAsString: (Status? u) => u!.name.toString(),
                    // items: widget.listStatus ?? [],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        constraints: BoxConstraints.tightFor(
                          width: 300,
                          height: 40,
                        ),
                        contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                        ),
                        // hintText: hintText ?? '--Trạng thái--',
                        hintMaxLines: 1,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                        ),
                      ),
                    ),
                    popupProps: const PopupPropsMultiSelection.menu(
                      constraints: BoxConstraints.expand(
                        width: 300,
                        height: 300,
                      ),
                      showSearchBox: false,
                    ),
                    onChanged: (value) {
                      selectStatus = value!;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (name.text == "" || level.text == "") {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
                      data.name = name.text;
                      data.level = int.tryParse(level.text);
                      data.status = selectStatus.id;
                      if (data.level == null) {
                        showToast(
                          context: context,
                          msg: "Cấp độ không đúng dịnh dạng số",
                          color: Colors.orange,
                          icon: const Icon(Icons.warning),
                        );
                      } else if (data.level! < 0 || data.level! > 3) {
                        showToast(
                          context: context,
                          msg: "Cấp độ từ 0-3. 0 là cao nhất. 3 là thấp nhất",
                          color: Colors.orange,
                          icon: const Icon(Icons.warning),
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  content: Container(
                                    height: 300,
                                    width: 460,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Text('Xác nhận cập nhật chức vụ', style: textTitleAlertDialog),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => {Navigator.pop(context)},
                                                icon: Icon(Icons.close),
                                              ),
                                            ]),
                                            const SizedBox(height: 10),
                                            const Divider(thickness: 1, color: Colors.black),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                        Flexible(
                                          child: Text("Cập nhật chức vụ: ${data.name}", style: textNormal),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            const Divider(thickness: 1, color: Colors.black),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await httpPut("/api/chuc-vu/put/${data.id}", data.toJson(), context);
                                                    showToast(
                                                      context: context,
                                                      msg: "Cập nhật danh mục thành công",
                                                      color: Color.fromARGB(136, 72, 238, 67),
                                                      icon: const Icon(Icons.done),
                                                    );
                                                    widget.callBack(data);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Xác nhận'),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color.fromARGB(255, 100, 181, 248),
                                                    onPrimary: Colors.white,
                                                    minimumSize: Size(100, 40),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text('Hủy', style: textBtnWhite),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color.fromARGB(255, 255, 132, 124),
                                                    onPrimary: Colors.white,
                                                    elevation: 3,
                                                    minimumSize: Size(100, 40),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      }
                    }
                  },
                  child: Text(
                    'Lưu',
                    style: textBtnWhite,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff6C92D0),
                    onPrimary: Colors.white,
                    elevation: 3,
                    minimumSize: Size(100, 40),
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    widget.callBack(data);
                    Navigator.pop(context);
                  },
                  child: Text('Hủy', style: textBtnWhite),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 132, 124),
                    onPrimary: Colors.white,
                    elevation: 3,
                    minimumSize: Size(100, 40),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
