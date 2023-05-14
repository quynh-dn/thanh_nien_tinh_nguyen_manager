// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/lich_phong_van.dart';
import '../../../../model/model_qltvn/lop_hoc.dart';
import '../../../../model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';

class ThemMoiLPVSceen extends StatelessWidget {
  const ThemMoiLPVSceen({super.key});
  @override
  Widget build(BuildContext context) {
    return Header(content: const Body());
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //Load
  Future<void> processing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController diaDiem = TextEditingController();
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  DateTime? chonNgay;
  String? chonGio;

  List<SinhVienDangKy> listSinhVien = [SinhVienDangKy(id: 0, fullName: "--Chọn sinh viên-", maSV: "")];
  List<int> listCheckSV = [0];

  List<TinhNguyenVien> listTNV = [TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: "")];
  List<int> listCheckTNV = [0];
  //call api sinh vien dang ky status = 0
  Future<List<SinhVienDangKy>> callSinhVienDangKy(List<int> khac) async {
    String searchKhac = "";
    for (var element in khac) {
      searchKhac += "and id!$element ";
    }
    List<SinhVienDangKy> listDepartment = [];
    try {
      var response = await httpGet("/api/sinh-vien-dang-ky/get/page?filter=status:0 $searchKhac", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return SinhVienDangKy.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  Future<List<TinhNguyenVien>> callTNV(List<int> khac) async {
    String searchKhac = "";
    for (var element in khac) {
      searchKhac += "and id!$element ";
    }
    List<TinhNguyenVien> listDepartment = [];
    try {
      var response = await httpGet("/api/nguoi-dung/get/page?filter=status:1 and role:1 $searchKhac", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return TinhNguyenVien.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  LichPhongVan data = LichPhongVan(listSinhVienPv: [], listThanhPhanThamDu: []);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    diaDiem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollControllerHideMenu,
      children: [
        const BreadCrumb(
          listPreTitle: [
            {'url': "/trang-chu", 'title': 'Trang chủ'},
            {'url': "/lich-phong-van", 'title': 'lịch phỏng vấn'},
          ],
          content: "Tạo lịch phỏng vấn",
        ),
        Container(
          padding: paddingPage,
          child: Column(
            children: [
              renderSearch(context),
            ],
          ),
        ),
        CommonApp().footerApp(),
      ],
    );
  }

  renderSearch(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhập thông tin',
            style: titleContainerBox,
          ),
          CommonApp().sizeBoxWidget(height: 25),
          Wrap(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tiêu đề ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextBoxCustom(
                              height: 40,
                              controller: title,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Nội dung ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextBoxCustom(
                              controller: content,
                              minLines: 5,
                              maxLines: 30,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Thời gian ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          DatePickerBox(
                            isHourl: true,
                            selectedDate: chonNgay,
                            width: 300,
                            decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                            callBack: (value) {
                              chonNgay = value;
                            },
                            callBackHuor: (value) {
                              chonGio = value;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Địa điểm ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextBoxCustom(
                              controller: diaDiem,
                              minLines: 5,
                              maxLines: 30,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ứng viên phỏng vấn ',
                          style: textDropdownTitle,
                        ),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    for (var i = 0; i < listSinhVien.length; i++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownSearch<SinhVienDangKy>(
                              asyncItems: (String? filter) => callSinhVienDangKy(listCheckSV),
                              itemAsString: (SinhVienDangKy? u) => "${u!.fullName} - ${u.maSV}",
                              selectedItem: listSinhVien[i],
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  constraints: BoxConstraints.tightFor(
                                    width: 260,
                                    height: 40,
                                  ),
                                  contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                                  ),
                                  hintText: "--Chọn sinh viên--",
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
                                  width: 260,
                                  height: 300,
                                ),
                                showSearchBox: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  listSinhVien[i] = value!;
                                  listCheckSV[i] = value.id!;
                                });
                              },
                            ),
                            (i == listSinhVien.length - 1)
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listSinhVien.removeAt(i);
                                                listCheckSV.removeAt(i);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: 15,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listSinhVien.add(SinhVienDangKy(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                                listCheckSV.add(0);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 15,
                                            )),
                                      )
                                    ],
                                  )
                                : (listSinhVien.length == 1)
                                    ? SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listSinhVien.add(SinhVienDangKy(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                                listCheckSV.add(0);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 15,
                                            )),
                                      )
                                    : SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listSinhVien.removeAt(i);
                                                listCheckSV.removeAt(i);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: 15,
                                            )),
                                      ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Người phỏng vấn ',
                          style: textDropdownTitle,
                        ),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    for (var i = 0; i < listTNV.length; i++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownSearch<TinhNguyenVien>(
                              asyncItems: (String? filter) => callTNV(listCheckTNV),
                              itemAsString: (TinhNguyenVien? u) => "${u!.fullName} - ${u.maSV}",
                              selectedItem: listTNV[i],
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  constraints: BoxConstraints.tightFor(
                                    width: 260,
                                    height: 40,
                                  ),
                                  contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                                  ),
                                  hintText: "--Chọn sinh viên--",
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
                                  width: 260,
                                  height: 300,
                                ),
                                showSearchBox: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  listTNV[i] = value!;
                                  listCheckTNV[i] = value.id!;
                                });
                              },
                            ),
                            (i == listTNV.length - 1)
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listTNV.removeAt(i);
                                                listCheckTNV.removeAt(i);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: 15,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listTNV.add(TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                                listCheckTNV.add(0);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 15,
                                            )),
                                      )
                                    ],
                                  )
                                : (listTNV.length == 1)
                                    ? SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listTNV.add(TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                                listCheckTNV.add(0);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 15,
                                            )),
                                      )
                                    : SizedBox(
                                        width: 20,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listTNV.removeAt(i);
                                                listCheckTNV.removeAt(i);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: 15,
                                            )),
                                      ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  processing();
                  bool statusData = true;
                  for (var element in listSinhVien) {
                    if (element.id == 0) statusData = false;
                  }
                  for (var element in listTNV) {
                    if (element.id == 0) statusData = false;
                  }
                  if (title.text == "" || chonNgay == null || chonGio == null || diaDiem.text == "" || statusData == false) {
                    showToast(
                      context: context,
                      msg: "Cần nhập đủ thông tin",
                      color: Colors.orange,
                      icon: const Icon(Icons.warning),
                    );
                    Navigator.pop(context);
                  } else {
                    data.title = title.text;
                    data.diaDiem = diaDiem.text;
                    data.content = content.text;
                    data.thoiGian = "${DateFormat('yyyy-MM-dd').format(chonNgay!)}T$chonGio:00";
                    data.sinhVienPv = listCheckSV.toString();
                    data.thanhPhanThamDu = listCheckTNV.toString();
                    data.status = 0;
                    for (var element in listCheckSV) {
                      httpGet("/api/sinh-vien-dang-ky/pv/$element", context);
                    }
                    await httpPost("/api/lich-phong-van/post", data.toJson(), context);
                    showToast(
                      context: context,
                      msg: "Thêm mới thành công",
                      color: Color.fromARGB(136, 72, 238, 67),
                      icon: const Icon(Icons.done),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu', style: textBtnWhite),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff6C92D0),
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy', style: textBtnWhite),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 255, 132, 124),
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  renderStatus(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 0, "name": "Chưa phỏng vấn"},
        {"id": 1, "name": "Đã phỏng vấn"},
        {"id": 2, "name": "Huỷ"},
      ],
      selectedItemStatus: selectStatus,
      removeSelection: "removeSelection",
      selectStatus: 2,
      onChangedCallback: (value) {
        selectStatus = value;
      },
      indexTypeDropdow: 5,
      labelDropdow: Row(
        children: [
          Text(
            "Trạng thái",
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: marginRightForm, bottom: 25),
    );
  }
}
