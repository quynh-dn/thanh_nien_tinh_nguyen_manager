// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
import 'dart:convert';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haivn/model/model_qltvn/lop_hoc.dart';
import 'package:haivn/model/model_qltvn/tinh-nguyen-vien.dart';

import '../../../../api.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/style.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/chuc_vu.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../web_config.dart';
import 'package:intl/intl.dart';

class ThemMoiTNV extends StatefulWidget {
  final Function callBack;
  const ThemMoiTNV({Key? key, required this.callBack}) : super(key: key);
  @override
  State<ThemMoiTNV> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<ThemMoiTNV> {
  TinhNguyenVien data = TinhNguyenVien();
  TextEditingController name = TextEditingController();
  TextEditingController maSV = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController address = TextEditingController();
  LopHoc selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
  ChucVu selectedChucVu = ChucVu(id: null, name: "--Chọn chức vụ--");
  Status selectGender = Status(id: null, name: "--Chọn giới tính--");
  DateTime? ngaySinh;
  DateTime? ngayVao;
  Future<List<ChucVu>> callChucVu() async {
    List<ChucVu> listDepartment = [];
    try {
      var response = await httpGet("/api/chuc-vu/get/page?filter=status:1&sort=level", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return ChucVu.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  Future<List<LopHoc>> callLopHoc() async {
    List<LopHoc> listDepartment = [];
    try {
      var response = await httpGet("/api/lop-hoc/get/page?filter=status:1", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return LopHoc.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  Future<List<Status>> callGender() async {
    var object = [
      {"id": 0, "name": "Nam"},
      {"id": 1, "name": "Nữ"},
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
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 460,
        height: 850,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Thêm tình nguyện viên', style: textTitleAlertDialog),
              IconButton(onPressed: () => {Navigator.pop(context)}, icon: Icon(Icons.close)),
            ]),
            const Divider(thickness: 1, color: Colors.black),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              height: 120,
              child: (data.avatar == "" || data.avatar == null) ? Image.asset("/images/noavatar.png") : Image.network("$baseUrl/api/files/${data.avatar}"),
            ),
            SizedBox(height: 10),
            Center(
              child: OutlinedButton(
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
                      data.avatar = avatarImage;
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
            ),
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
                        'Họ và tên ',
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
                        'Mã sinh viên ',
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
                        controller: maSV,
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
                        'Chức vụ ',
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
                  child: DropdownSearch<ChucVu>(
                    asyncItems: (String? filter) => callChucVu(),
                    itemAsString: (ChucVu? u) => u!.name.toString(),
                    selectedItem: selectedChucVu,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        constraints: const BoxConstraints.tightFor(
                          width: 300,
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                        ),
                        hintMaxLines: 1,
                        enabledBorder: const OutlineInputBorder(
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
                      showSearchBox: true,
                    ),
                    onChanged: (value) {
                      selectedChucVu = value!;
                    },
                    // selectedItems: ["Brazil"],
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
                        'Lớp ',
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
                  child: DropdownSearch<LopHoc>(
                    asyncItems: (String? filter) => callLopHoc(),
                    itemAsString: (LopHoc? u) => u!.name.toString(),
                    selectedItem: selectedLopHoc,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        constraints: const BoxConstraints.tightFor(
                          width: 300,
                          height: 40,
                        ),
                        contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                        ),
                        hintMaxLines: 1,
                        enabledBorder: const OutlineInputBorder(
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
                      showSearchBox: true,
                    ),
                    onChanged: (value) {
                      selectedLopHoc = value!;
                    },
                    // selectedItems: ["Brazil"],
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
                        'Ngày vào ',
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
                  child: DatePickerBox(
                    selectedDate: ngayVao,
                    width: 300,
                    decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                    callBack: (value) {
                      ngayVao = value;
                    },
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
                        'Email ',
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
                        controller: email,
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
                        'SĐT ',
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
                        controller: sdt,
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
                        'Địa chỉ ',
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
                        controller: address,
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
                        'Ngày sinh ',
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
                  child: DatePickerBox(
                    selectedDate: ngaySinh,
                    width: 300,
                    decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                    callBack: (value) {
                      ngaySinh = value;
                    },
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
                        'Giới tính ',
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
                      selectedItem: selectGender,
                      asyncItems: (String? filter) => callGender(),
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
                        selectGender = value!;
                      },
                    ))
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
                    if (name.text == "" || maSV.text == "" || email.text == "" || sdt.text == "" || address.text == "" || ngayVao == null || ngaySinh == null || selectedLopHoc.id == null || selectedChucVu.id == null || selectGender.id == null) {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                    } else {
                      data.role = 1;
                      data.fullName = name.text;
                      data.email = email.text;
                      data.sdt = sdt.text;
                      data.diaChi = address.text;
                      data.maSV=maSV.text;
                      data.idChucVu = selectedChucVu.id;
                      data.idLop = selectedLopHoc.id;
                      data.ngayVao = DateFormat('yyyy-MM-dd').format(ngayVao!);
                      data.ngaySinh = DateFormat('yyyy-MM-dd').format(ngaySinh!);
                      if (selectGender.id == 0) {
                        data.gioiTinh = false;
                      } else {
                        data.gioiTinh = true;
                      }
                      data.status = 1;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Container(
                                  height: 150,
                                  width: 400,
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
                                                  Text('Xác nhận thêm mới', style: textTitleAlertDialog),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => {Navigator.pop(context)},
                                              icon: Icon(Icons.close),
                                            ),
                                          ]),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await httpPost("/api/nguoi-dung/create", data.toJson(), context);
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
