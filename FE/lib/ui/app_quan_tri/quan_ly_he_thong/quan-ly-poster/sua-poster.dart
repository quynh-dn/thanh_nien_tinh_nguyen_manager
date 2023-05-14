// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:haivn/model/model_qltvn/lop_hoc.dart';

import '../../../../api.dart';
import '../../../../common/style.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/poster.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../web_config.dart';

class SuaPoster extends StatefulWidget {
  final Poster data;
  final Function callBack;
  const SuaPoster({Key? key, required this.callBack, required this.data}) : super(key: key);
  @override
  State<SuaPoster> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<SuaPoster> {
  Poster data = Poster();
  TextEditingController name = TextEditingController();
  TextEditingController stt = TextEditingController();
  String fileName = "";
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

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
    stt.text = data.stt.toString();
    fileName = data.fileName ?? "";

    if (data.status == 1) {
      selectStatus = Status(id: 1, name: "Hoạt động");
    } else {
      selectStatus = Status(id: 0, name: "Khoá");
    }
  }

  @override
  void dispose() {
    name.dispose();
    stt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 560,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Cập nhật poster', style: textTitleAlertDialog),
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
                        'Tiêu đề ',
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
                        'Thứ tự hiển thị ',
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
                        controller: stt,
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
                        'Poster ',
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
                      OutlinedButton(
                        child: Text("Tải ảnh"),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['png', 'JPEG', 'JPG', 'TIFF', 'GIF'],
                            withReadStream: true,
                            allowMultiple: false,
                          );
                          if (result != null) {
                            var avatarImage = await uploadFile(result, context: context);
                            setState(() {
                              fileName = avatarImage;
                            });
                          } else {
                            return showToast(
                              context: context,
                              msg: "Chọn lại file",
                              color: Color.fromRGBO(245, 117, 29, 1),
                              icon: const Icon(Icons.info),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            if (fileName != "")
              Image.network(
                "$baseUrl/api/files/$fileName",
                height: 210,
                width: 430,
                fit: BoxFit.fill,
              ),
            const SizedBox(height: 10),
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
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (name.text == "" || stt.text == "" || fileName == "") {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
                      data.name = name.text;
                      data.stt = int.tryParse(stt.text);
                      data.fileName = fileName;
                      data.status = selectStatus.id;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Container(
                                  height: 400,
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
                                                  Text('Xác nhận cập nhật poster', style: textTitleAlertDialog),
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
                                        child: Text("Cập nhật poster: ${data.name}", style: textNormal),
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
                                                  var abc = await httpPut("/api/poster/put/${data.id}", data.toJson(), context);
                                                  print(abc);
                                                  showToast(
                                                    context: context,
                                                    msg: "Cập nhật poster thành công",
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
                    widget.callBack(widget.data);
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
