// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:haivn/model/model_qltvn/lop_hoc.dart';
import 'package:haivn/model/model_qltvn/tinh-nguyen-vien.dart';

import '../../../../api.dart';
import '../../../../common/style.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/poster.dart';
import '../../../../web_config.dart';

class ThemMoiQTV extends StatefulWidget {
  final Function callBack;
  const ThemMoiQTV({Key? key, required this.callBack}) : super(key: key);
  @override
  State<ThemMoiQTV> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<ThemMoiQTV> {
  TinhNguyenVien data = TinhNguyenVien();
  TextEditingController name = TextEditingController();
  TextEditingController stt = TextEditingController();
  String fileName = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 200,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Thêm lớp quản trị viên', style: textTitleAlertDialog),
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
                        'Tên đăng nhập ',
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
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (name.text == "") {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
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
                                                  Text('Xác nhận thêm mới qtv', style: textTitleAlertDialog),
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
                                        child: Text("Thêm mới qtv: ${name.text}", style: textNormal),
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
                                                  var userLogin = {"username":name.text};
                                                  var abc = await httpPost("/api/nguoi-dung/createAdmin", userLogin, context);
                                                  print(abc);
                                                  showToast(
                                                    context: context,
                                                    msg: "Thêm mới thành công",
                                                    color: Color.fromARGB(136, 72, 238, 67),
                                                    icon: const Icon(Icons.done),
                                                  );
                                                  widget.callBack(true);
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
                    widget.callBack(false);
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
