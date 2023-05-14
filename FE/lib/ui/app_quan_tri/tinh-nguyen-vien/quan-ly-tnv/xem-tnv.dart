// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, must_be_immutable
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/common_app/common_app.dart';
import 'package:intl/intl.dart';

import '../../../../model/model_qltvn/lich_phong_van.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import '../../../../model/model_qltvn/tnv-ptsk.dart';
import '../lich-phong-van/xem-lpv.dart';

class XemTNV extends StatefulWidget {
  TinhNguyenVien data;
  XemTNV({
    super.key,
    required this.data,
  });

  @override
  State<XemTNV> createState() => _BodyState();
}

class _BodyState extends State<XemTNV> {
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

  TinhNguyenVien data = TinhNguyenVien();

  List<TnvPtsk> listData = [];

  Future<List<TnvPtsk>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response = await httpGet("/api/tnv-ptsk/get/page?filter=idTnv:${data.id} and phongTraoSuKien.status!0&sort=phongTraoSuKien.status", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listData = content.map((e) {
              return TnvPtsk.fromJson(e);
            }).toList();
          });
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
              {'url': "/tinh-nguyen-vien", 'title': "Quản lý tình nguyện viên"},
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
            '${data.fullName} - ${data.chucVu!.name}',
            style: titleContainerBox,
          ),
          (data.status == 1)
              ? Text(
                  'Hoạt động',
                  style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 13, 255, 66)),
                )
              : (data.status == 0)
                  ? Text(
                      'Khoá',
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
                      'Ngày vào:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.parse(data.ngayVao!).toLocal()),
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
                      'Mã sinh viên:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.maSV}",
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
                'Phong trào sự kiện:',
                style: textDropdownTitle,
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          (statusData)
              ? Center(
                child: Container(
                  child: SingleChildScrollView(
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
                              'Thời gian bắt đầu',
                              style: textDataColumn,
                            ),
                          ),
                        ),
                          DataColumn(
                          label: Expanded(
                            child: Text(
                              'Thời gian kết thúc',
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
                      ],
                      rows: <DataRow>[
                        for (int i = 0; i < listData.length; i++)
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                '${i + 1}',
                                style: textDataRow,
                              )),
                              DataCell(SelectableText(listData[i].phongTraoSuKien!.title ?? "", style: textDataRow)),
                              DataCell(SelectableText((listData[i].phongTraoSuKien!.startDate != null) ? DateFormat("dd-MM-yyy").format(DateTime.parse(listData[i].phongTraoSuKien!.startDate!)) : "", style: textDataRow)),
                              DataCell(SelectableText((listData[i].phongTraoSuKien!.endDate != null) ? DateFormat("dd-MM-yyy").format(DateTime.parse(listData[i].phongTraoSuKien!.endDate!)) : "", style: textDataRow)),
                              DataCell(SelectableText(listData[i].phongTraoSuKien!.diaDiem ?? "", style: textDataRow)),
                              DataCell(
                                SelectableText(
                                    (listData[i].phongTraoSuKien!.status == 0)
                                        ? "Huỷ"
                                        : (listData[i].phongTraoSuKien!.status == 1)
                                            ? "Đang diễn ra"
                                            : (listData[i].phongTraoSuKien!.status == 2)
                                                ? "Hoàn thành"
                                                : "",
                                    style: textDataRow),
                              ),
                             
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
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
