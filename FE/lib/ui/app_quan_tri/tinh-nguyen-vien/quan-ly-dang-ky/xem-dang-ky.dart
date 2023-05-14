// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, must_be_immutable
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/common_app/common_app.dart';
import 'package:intl/intl.dart';

import '../../../../model/model_qltvn/lich_phong_van.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import '../lich-phong-van/xem-lpv.dart';

class XemDangKy extends StatefulWidget {
  SinhVienDangKy data;
  XemDangKy({
    super.key,
    required this.data,
  });

  @override
  State<XemDangKy> createState() => _BodyState();
}

class _BodyState extends State<XemDangKy> {
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

  SinhVienDangKy data = SinhVienDangKy();

  //Trạng thái
  Future<List<Status>> callStatus() async {
    var object = [
      {"id": 1, "name": "Chờ phỏng vấn"},
      {"id": 2, "name": "Đỗ"},
      {"id": 3, "name": "Trượt"},
    ];

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
  }

  List<LichPhongVan> listData = [];

  Future<List<LichPhongVan>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response = await httpGet("/api/lich-phong-van/get/page?filter=sinhVienPv~'*[${data.id}]*' or sinhVienPv~'*[${data.id},*' or sinhVienPv~'*, ${data.id},*' or sinhVienPv~'*, ${data.id}]*'", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listData = content.map((e) {
              return LichPhongVan.fromJson(e);
            }).toList();
          });
          for (var element in listData) {
            for (var elementSV in element.sinhVienPvConvert!) {
              var responseSV = await httpGet("/api/sinh-vien-dang-ky/get/$elementSV", context);
              var bodySV = jsonDecode(responseSV["body"]);

              SinhVienDangKy sv = SinhVienDangKy.fromJson(bodySV['result']);
              setState(() {
                element.listSinhVienPv.add(sv);
              });
            }
            for (var elementTNV in element.thanhPhanThamDuConvert!) {
              var responseTNV = await httpGet("/api/nguoi-dung/get/$elementTNV", context);
              var bodyTNV = jsonDecode(responseTNV["body"]);
              TinhNguyenVien tnv = TinhNguyenVien.fromJson(bodyTNV['result']);
              setState(() {
                element.listThanhPhanThamDu.add(tnv);
              });
            }
          }
        }
      }
    } catch (e) {
      return listData;
    }
    return listData;
  }

  bool statusData = false;
  void callApi() async {
    await callApiData();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    data = widget.data;
    callApi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      content: ListView(
        controller: scrollControllerHideMenu,
        children: [
          const BreadCrumb(
            listPreTitle: [
              {'url': "/trang-chu", 'title': 'Trang chủ'},
              {'url': "/sinh-vien-dang-ki", 'title': "Quản lý sinh viên đăng ký"},
            ],
            content: "Thông tin chi tiết",
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
      ),
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
            '${data.fullName} - ${data.maSV}',
            style: titleContainerBox,
          ),
          (data.status == 0)
              ? Text(
                  "Đăng ký",
                  style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 105, 253)),
                )
              : (data.status == 1)
                  ? Text(
                      "Chờ phỏng vấn",
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 253, 146, 7)),
                    )
                  : (data.status == 2)
                      ? Text(
                          'Đỗ',
                          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 13, 255, 66)),
                        )
                      : (data.status == 3)
                          ? Text(
                              'Trượt',
                              style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 76, 22)),
                            )
                          : Row(),
          CommonApp().sizeBoxWidget(height: 15),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Wrap(
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lớp:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.lopHoc!.name}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.email}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Số điện thoại:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.sdt}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày sinh:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.parse(data.ngaySinh!).toLocal()),
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giới tính:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        (data.gioiTinh == true) ? "Nữ" : "Nam",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Địa chỉ:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.diaChi}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lịch phỏng vấn:',
                style: textDropdownTitle,
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          (statusData)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(
                          color: Colors.black,
                          //style: BorderStyle.solid,
                          width: 0.1,
                        ),
                        columns: <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'STT',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Tiêu đề',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Thời gian',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Địa điểm',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Trạng thái',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Hành động',
                                style: textDataColumn,
                              ),
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          for (int i = 0; i < listData.length; i++)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  '${i + 1}',
                                  style: textDataRow,
                                )),
                                DataCell(SelectableText(listData[i].title ?? "", style: textDataRow)),
                                DataCell(SelectableText((listData[i].thoiGian != null) ? DateFormat("dd-MM-yyy").format(DateTime.parse(listData[i].thoiGian!)) : "", style: textDataRow)),
                                DataCell(SelectableText(listData[i].diaDiem ?? "", style: textDataRow)),
                                DataCell(SelectableText(
                                    (listData[i].status == 0)
                                        ? "Chưa phỏng vấn"
                                        : (listData[i].status == 1)
                                            ? "Đã phỏng vấn"
                                            : (listData[i].status == 2)
                                                ? "Huỷ"
                                                : "",
                                    style: textDataRow)),
                                DataCell(
                                  Row(
                                    children: [
                                      Tooltip(
                                        message: "Xem",
                                        child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(color: Color.fromARGB(255, 162, 210, 252), borderRadius: BorderRadius.circular(5)),
                                            child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => XemLPV(
                                                            data: listData[i],
                                                          ));
                                                },
                                                child: const Icon(
                                                  Icons.visibility,
                                                  color: Color(0xFF023E74),
                                                  size: 20,
                                                ))),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              : CommonApp().loadingCallAPi(),
          CommonApp().sizeBoxWidget(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('Trở về', style: textBtnWhite),
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
}
