// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haivn/model/model_qltvn/lop_hoc.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../api.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/style.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/status.dart';
import 'package:intl/intl.dart';

class FormDangKy extends StatefulWidget {
  const FormDangKy({Key? key}) : super(key: key);
  @override
  State<FormDangKy> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<FormDangKy> {
  SinhVienDangKy data = SinhVienDangKy();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sdt = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController maSV = TextEditingController();
  LopHoc selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
  Status selectGender = Status(id: null, name: "--Chọn giới tính--");
  DateTime? ngaySinh;

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
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [containerShadow],
          image: DecorationImage(
            image: const AssetImage(
              "images/background-login.jpeg",
            ),
            opacity: 0.8,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),

            // colorFilter: ColorFilter.mode(
            //   Colors.black.withOpacity(0.3),
            //   BlendMode.overlay,
            // ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(15),
            width: 500,
            height: 590,
            child: ListView(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Đăng ký phỏng vấn', style: textTitleAlertDialog),
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
                        if (name.text == "" || email.text == "" || sdt.text == "" || maSV.text == "" || address.text == "" || ngaySinh == null || selectedLopHoc.id == null || selectGender.id == null) {
                          showToast(
                            context: context,
                            msg: "Cần nhập đủ thông tin",
                            color: Colors.orange,
                            icon: const Icon(Icons.warning),
                          );
                        } else {
                          data.fullName = name.text;
                          data.email = email.text;
                          data.sdt = sdt.text;
                          data.diaChi = address.text;
                          data.idLop = selectedLopHoc.id;
                          data.maSV = maSV.text;
                          data.ngaySinh = DateFormat('yyyy-MM-dd').format(ngaySinh!);
                          if (selectGender.id == 0) {
                            data.gioiTinh = false;
                          } else {
                            data.gioiTinh = true;
                          }
                          data.status = 0;
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
                                                      Text('Xác nhận đăng ký', style: textTitleAlertDialog),
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
                                                      await httpPost("/api/sinh-vien-dang-ky/post", data.toJson(), context);
                                                      showToast(
                                                        context: context,
                                                        msg: "Đăng ký thành công",
                                                        color: Color.fromARGB(136, 72, 238, 67),
                                                        icon: const Icon(Icons.done),
                                                      );
                                                      setState(() {
                                                        name.text = "";
                                                        maSV.text = "";
                                                        email.text = "";
                                                        address.text = "";
                                                        sdt.text = "";
                                                        ngaySinh = null;
                                                        selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
                                                        selectGender = Status(id: null, name: "--Chọn giới tính--");
                                                      });
                                                      Navigator.pop(context);
                                                      // Navigator.pop(context);
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
                        'Đăng ký',
                        style: textBtnWhite,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 25, 187, 79),
                        onPrimary: Colors.white,
                        elevation: 3,
                        minimumSize: Size(100, 40),
                      ),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/login-page');
                      },
                      child: Text('Đăng nhập', style: textBtnWhite),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff6C92D0),
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
        ),
      ),
    );
  }
}
