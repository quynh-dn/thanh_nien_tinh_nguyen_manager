// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';

import '../../../web_config.dart';
import 'them-ptsk.dart';

class XemPTSKSceen extends StatefulWidget {
  PhongTraoSuKien data;
  Function? callbak;
  XemPTSKSceen({super.key, required this.data, this.callbak});

  @override
  State<XemPTSKSceen> createState() => _BodyState();
}

class _BodyState extends State<XemPTSKSceen> {
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

  List<String> listTrangThai = ["", "Đang diễn ra", "Hoàn thành", "Hủy"];

  TextEditingController title = TextEditingController();
  TextEditingController diaDiem = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController kinhPhi = TextEditingController();
  TextEditingController soLoung = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String poster = "";

  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  List<TinhNguyenVien> listTNV = [
    TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: "")
  ];
  List<int> listCheckTNV = [0];

  Future<List<TinhNguyenVien>> callTNV(List<int> khac) async {
    String searchKhac = "";
    for (var element in khac) {
      searchKhac += "and id!$element ";
    }
    List<TinhNguyenVien> listDepartment = [];
    try {
      var response = await httpGet(
          "/api/nguoi-dung/get/page?filter=status:1 and role:1 $searchKhac",
          context);
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

  PhongTraoSuKien data = PhongTraoSuKien(listNguoiPhuTrach: []);
  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    diaDiem.dispose();
    kinhPhi.dispose();
    soLoung.dispose();
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
              {'url': "/phong-trao-su-kien", 'title': 'Phong trào sự kiện'},
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [containerShadow]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ThemMoiPTSKSceen(
                            data: data,
                            callback: (value) {
                              setState(() {
                                data = value;
                              });
                            },
                          ));
                },
                child: Text('Chỉnh sửa', style: textBtnWhite),
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
                child: Text('Trở về', style: textBtnWhite),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 255, 132, 124),
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          (data.poster != null && data.poster != "")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "$baseUrl/api/files/${data.poster}",
                      width: MediaQuery.of(context).size.width * 0.7,
                      fit: BoxFit.contain,
                    ),
                  ],
                )
              : Row(),
          CommonApp().sizeBoxWidget(height: 15),
          Row(
            children: [
              Text(
                '${data.title} - ',
                style: titleContainerBox,
              ),
              Container(
                child: (data.status == 3)
                    ? Text("Huỷ", style: titleContainerBoxRed)
                    : (data.status == 1)
                        ? Text("Đang diễn ra", style: titleContainerBoxGreen)
                        : (data.status == 2)
                            ? Text("Hoàn thành", style: titleContainerBoxBlue)
                            : Text(""),
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 25),
          Wrap(
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ngày bắt đầu ',
                          style: textDropdownTitle,
                        ),
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(data.startDate!)),
                      style: textDropdownTitle,
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ngày kết thúc ',
                          style: textDropdownTitle,
                        ),
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(data.endDate!)),
                      style: textDropdownTitle,
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Địa điểm ',
                          style: textDropdownTitle,
                        )
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    Text(
                      '${data.diaDiem} ',
                      style: textDropdownTitle,
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Kinh phí ',
                          style: textDropdownTitle,
                        ),
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    Text(
                      '${data.kinhPhi} ',
                      style: textDropdownTitle,
                    ),
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Số lượng người hỗ trợ dự kiến',
                          style: textDropdownTitle,
                        ),
                      ],
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    Text(
                      '${data.soLuongHoTro} ',
                      style: textDropdownTitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Người phụ trách ',
                    style: textDropdownTitle,
                  ),
                ],
              ),
              CommonApp().sizeBoxWidget(height: 10),
              Wrap(
                children: [
                  for (var elementTNV in data.listNguoiPhuTrach)
                    Container(
                      margin: const EdgeInsets.only(bottom: 25, right: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${elementTNV.fullName} - ${elementTNV.chucVu!.name} - ${elementTNV.maSV}',
                            style: textDropdownTitle,
                          ),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '',
                      style: textDropdownTitle,
                    ),
                  ],
                ),
                CommonApp().sizeBoxWidget(height: 10),
                Text(
                  '${data.content}',
                  style: textDropdownTitle,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ThemMoiPTSKSceen(
                            data: data,
                            callback: (value) {
                              setState(() {
                                data = value;
                              });
                            },
                          ));
                },
                child: Text('Chỉnh sửa', style: textBtnWhite),
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
                  widget.callbak!(data);
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
