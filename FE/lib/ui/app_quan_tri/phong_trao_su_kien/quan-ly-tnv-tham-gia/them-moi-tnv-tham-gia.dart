// ignore_for_file: prefer_const_constructors, sort_child_properties_last, deprecated_member_use, use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import 'package:haivn/model/model_qltvn/tnv-ptsk.dart';
import '../../../../api.dart';
import '../../../../common/style.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/phong_trao_su_kien.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';

class ThemMoiTNVThamGia extends StatefulWidget {
  Function? callBack;
  ThemMoiTNVThamGia({Key? key, this.callBack}) : super(key: key);
  @override
  State<ThemMoiTNVThamGia> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<ThemMoiTNVThamGia> {
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  TnvPtsk data = TnvPtsk();
  TinhNguyenVien selectedTNV = TinhNguyenVien(id: null, fullName: "--Chọn sinh viên--", chucVu: ChucVu(name: ""));
  PhongTraoSuKien selectedPTSK = PhongTraoSuKien(id: null, title: "--Chọn PTSK--", listNguoiPhuTrach: []);
  Future<List<TinhNguyenVien>> callTNV() async {
    List<TinhNguyenVien> listDepartment = [];
    try {
      var response = await httpGet("/api/nguoi-dung/get/page?filter=status:1 and role:1", context);
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

  Future<List<PhongTraoSuKien>> callPTSK() async {
    List<PhongTraoSuKien> listDepartment = [];
    try {
      var response = await httpGet("/api/phong-trao-su-kien/get/page", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return PhongTraoSuKien.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  Future<List<Status>> callStatus() async {
    var object = [
      {"id": 0, "name": "Đăng ký"},
      {"id": 1, "name": "Tham gia"},
      {"id": 2, "name": "Từ chối"},
    ];

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    Status all = Status(id: null, name: "--Chọn trạng thái--");
    listStatus.insert(0, all);

    return listStatus;
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
              Text('Thêm mới', style: textTitleAlertDialog),
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
                        'Tình nguyện viên ',
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
                      SizedBox(
                          width: 300,
                          child: DropdownSearch<TinhNguyenVien>(
                            asyncItems: (String? filter) => callTNV(),
                            itemAsString: (TinhNguyenVien? u) => "${u!.fullName} - ${u.chucVu!.name}",
                            selectedItem: selectedTNV,
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
                                width: 300,
                                height: 300,
                              ),
                              showSearchBox: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedTNV = value!;
                              });
                            },
                          )),
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
                        'Phong trào sự kiện ',
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
                      SizedBox(
                        width: 300,
                        child: DropdownSearch<PhongTraoSuKien>(
                          asyncItems: (String? filter) => callPTSK(),
                          itemAsString: (PhongTraoSuKien? u) => "${u!.title}",
                          selectedItem: selectedPTSK,
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
                              hintText: "--Chọn PTSK--",
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
                            showSearchBox: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedPTSK = value!;
                            });
                          },
                        ),
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
                  child: Row(
                    children: [
                      SizedBox(
                          width: 300,
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
                          )),
                    ],
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
                    if (selectedPTSK.id == null || selectedTNV.id == null || selectStatus.id == null) {
                      showToast(
                        context: context,
                        msg: "Cần nhập đủ thông tin",
                        color: Colors.orange,
                        icon: const Icon(Icons.warning),
                      );
                      // Navigator.pop(context);
                    } else {
                      data.idTnv = selectedTNV.id;
                      data.idPtsk = selectedPTSK.id;
                      data.status = selectStatus.id;
                      await httpPost("/api/tnv-ptsk/post", data.toJson(), context);
                      showToast(
                        context: context,
                        msg: "Thêm mới thành công",
                        color: Color.fromARGB(136, 72, 238, 67),
                        icon: const Icon(Icons.done),
                      );
                      widget.callBack!(true);
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                    widget.callBack!(false);
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
