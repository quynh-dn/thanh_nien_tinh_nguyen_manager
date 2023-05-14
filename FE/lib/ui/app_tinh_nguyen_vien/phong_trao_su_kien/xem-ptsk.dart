// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haivn/api.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:haivn/model/model_qltvn/tnv-ptsk.dart';
import 'package:localstorage/localstorage.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/common_app/common_app.dart';
import 'package:intl/intl.dart';

import '../../../common/toast.dart';
import '../../../web_config.dart';

class XemPTSKTNVSceen extends StatefulWidget {
  PhongTraoSuKien data;
  XemPTSKTNVSceen({super.key, required this.data});

  @override
  State<XemPTSKTNVSceen> createState() => _BodyState();
}

class _BodyState extends State<XemPTSKTNVSceen> {
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

  PhongTraoSuKien data = PhongTraoSuKien(listNguoiPhuTrach: []);
  bool statusData = false;
  late bool statusBtn;
  late int thangThai;
  LocalStorage storage = LocalStorage("storage");
  var id;
  callCheckData() async {
    id = await storage.getItem("id");
    var responseCheck = await httpGet(
        "/api/tnv-ptsk/get/page?filter=idTnv:$id and idPtsk:${data.id}",
        context);
    var bodyCheck = jsonDecode(responseCheck["body"]);
    var contentCheck = bodyCheck["result"]["content"];
    // print(responseCheck);
    setState(() {});
    if (contentCheck.length > 0) {
      statusBtn = false;
      thangThai = contentCheck.first['status'];
      statusData = true;
    } else {
      statusBtn = true;
      statusData = true;
    }
  }

  @override
  void initState() {
    super.initState();
    data = widget.data;
    callCheckData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Header(
      content: (statusData == true)
          ? ListView(
              controller: scrollControllerHideMenu,
              children: [
                const BreadCrumb(
                  listPreTitle: [
                    {'url': "/trang-chu", 'title': 'Trang chủ'},
                    {
                      'url': "/phong-trao-su-kien-tnv",
                      'title': 'Phong trào sự kiện'
                    },
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
            )
          : CommonApp().loadingCallAPi(),
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
          if (statusBtn == false)
            Center(
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: (thangThai == 0)
                      ? Text(
                          "Bạn đã đăng ký tham gia phong trào sự kiện",
                          style: textDropdownTitleOrange,
                        )
                      : (thangThai == 1)
                          ? Text(
                              "Bạn đã tham gia phong trào sự kiện",
                              style: textDropdownTitleGreen,
                            )
                          : (thangThai == 2)
                              ? Text(
                                  "Bạn không thể tham gia phong trào sự kiện này",
                                  style: textDropdownTitleRed,
                                )
                              : Row()),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (statusBtn == true && widget.data.status == 1)
                  ? ElevatedButton(
                      onPressed: () async {
                        processing();
                        TnvPtsk dataTnvPtsk = TnvPtsk(
                            idTnv: int.tryParse(id),
                            idPtsk: data.id,
                            status: 0);
                        if (widget.data.soLuongDaDangKy! >=
                            widget.data.soLuongHoTro!) {
                          showToast(
                            context: context,
                            msg: "Số lượng tình nguyện viên tham gia đã đầy",
                            color: Color.fromRGBO(232, 158, 30, 1),
                            icon: const Icon(Icons.warning),
                          );
                          Navigator.pop(context);
                        } else {
                          await httpPost("/api/tnv-ptsk/post",
                              dataTnvPtsk.toJson(), context);
                          Future.delayed(const Duration(seconds: 1), () {
                            showToast(
                              context: context,
                              msg: "Đăng ký thành công",
                              color: Color.fromARGB(255, 73, 238, 67),
                              icon: const Icon(Icons.done),
                            );
                            setState(() {
                              statusBtn = false;
                              thangThai = 0;
                            });
                            Navigator.pop(context);
                          });
                        }

                        // http
                      },
                      child: Text('Đăng ký tham gia', style: textBtnWhite),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 124, 165, 255),
                        elevation: 3,
                        minimumSize: Size(100, 40),
                      ),
                    )
                  : Row(),
              SizedBox(
                width: 15,
              ),
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
          )
        ],
      ),
    );
  }
}
