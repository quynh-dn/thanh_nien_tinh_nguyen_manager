// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/common_app/common_app.dart';
import 'package:haivn/common/header.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:haivn/model/model_qltvn/lich_phong_van.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:intl/intl.dart';
import '../api.dart';
import '../common/breadcrumb.dart';
import '../common/style.dart';
import '../model/model_qltvn/poster.dart';
import '../model/model_qltvn/sinh-vien-dang-ky.dart';
import '../model/model_qltvn/tinh-nguyen-vien.dart';
import '../web_config.dart';
import 'app_quan_tri/phong_trao_su_kien/xem-ptsk.dart';
import 'app_quan_tri/tinh-nguyen-vien/lich-phong-van/xem-lpv.dart';
import 'app_quan_tri/tinh-nguyen-vien/quan-ly-tnv/xem-tnv.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuBodyState();
}

class _TrangChuBodyState extends State<TrangChu> {
  List<Poster> listPoster = [];
  List<PhongTraoSuKien> listPTSK = [];
  List<TinhNguyenVien> listTNV = [];
  List<LichPhongVan> listLPV = [];

  Future<List<Poster>> callApiPoster() async {
    setState(() {
      listPoster = [];
    });
    try {
      var response = await httpGet("/api/poster/get/page?filter=status:1", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listPoster = content.map((e) {
              return Poster.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      return listPoster;
    }

    return listPoster;
  }

  Future<List<PhongTraoSuKien>> callApiPTSK() async {
    setState(() {
      listPTSK = [];
    });
    try {
      var response = await httpGet("/api/phong-trao-su-kien/get/page?filter=status:1&size=10&page=0", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listPTSK = content.map((e) {
              return PhongTraoSuKien.fromJson(e);
            }).toList();
          });
          for (var element in listPTSK) {
            for (var elementTNV in element.nguoiPhuTrachConvert!) {
              var responseTNV = await httpGet("/api/nguoi-dung/get/$elementTNV", context);
              var bodyTNV = jsonDecode(responseTNV["body"]);
              TinhNguyenVien tnv = TinhNguyenVien.fromJson(bodyTNV['result']);
              setState(() {
                element.listNguoiPhuTrach.add(tnv);
              });
            }
            var responseSLTG = await httpGet("/api/phong-trao-su-kien/get/soluongtnv/${element.id}", context);
            var bodyTNV = jsonDecode(responseSLTG["body"]);
            setState(() {
              element.soLuongDaDangKy = int.tryParse(bodyTNV.toString()) ?? 0;
            });
          }
        }
      }
    } catch (e) {
      return listPTSK;
    }

    return listPTSK;
  }

  Future<List<LichPhongVan>> callApiLPV() async {
    setState(() {
      listLPV = [];
    });
    try {
      var response = await httpGet("/api/lich-phong-van/get/page?filter=deleted:false&sort=status&sort=id,desc&page=0&size=5", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listLPV = content.map((e) {
              return LichPhongVan.fromJson(e);
            }).toList();
          });
          for (var element in listLPV) {
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
      return listLPV;
    }
    return listLPV;
  }

  Future<List<TinhNguyenVien>> callApiTNV() async {
    setState(() {
      listTNV = [];
    });
    try {
      var response = await httpGet("/api/nguoi-dung/get/page?filter=status:1 and role:1&sort=ngayVao,desc&size=5&page=0", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listTNV = content.map((e) {
              return TinhNguyenVien.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      return listTNV;
    }
    return listTNV;
  }

  bool statusData = false;
  void callApi() async {
    await callApiPoster();
    await callApiPTSK();
    await callApiTNV();
    await callApiLPV();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      content: (statusData)
          ? ListView(
              controller: scrollControllerHideMenu,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const BreadCrumb(
                  listPreTitle: [],
                  content: "Trang chủ",
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  margin: EdgeInsets.only(left: 15,top: 5,right:15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadiusContainer,
                    boxShadow: [boxShadowContainer],
                    border: borderAllContainerBox,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.width * 0.4,
                      viewportFraction: 0.83,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: listPoster.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                            ),
                            child: Image.network(
                              "$baseUrl/api/files/${item.fileName!}",
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.width * 0.4,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadiusContainer,
                    boxShadow: [boxShadowContainer],
                    border: borderAllContainerBox,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 15),
                        child: Text(
                          "Phong trào sự kiện đang diễn ra",
                          style: textTitleNavbarBlack,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var elementPTSK in listPTSK)
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) => XemPTSKSceen(
                                              data: elementPTSK,
                                              callbak: (value) {
                                                setState(() {
                                                  elementPTSK = value;
                                                });
                                              },
                                            ));
                                  },
                                  child: Container(
                                    width: 330,
                                    height: 390,
                                    margin: const EdgeInsets.all(15),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(color: backgroundPageColor, borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          "$baseUrl/api/files/${elementPTSK.poster}",
                                          width: 300,
                                          height: 220,
                                          fit: BoxFit.fill,
                                        ),
                                        const SizedBox(height: 10),
                                        Text("${elementPTSK.title}", style: textCardContentBlack),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Container(
                                              width: 145,
                                              child: (elementPTSK.status == 0)
                                                  ? Text("Huỷ", style: textDropdownTitleRed)
                                                  : (elementPTSK.status == 1)
                                                      ? Text("Đang diễn ra", style: textDropdownTitleGreen)
                                                      : (elementPTSK.status == 2)
                                                          ? Text("Hoàn thành", style: textDropdownTitleMain)
                                                          : Text(""),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                    "${elementPTSK.diaDiem}",
                                                    style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Expanded(child: Text("Từ: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.startDate!))}", style: textDropdownTitle)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: Text("Đến: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.endDate!))}", style: textDropdownTitle))
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Text("Số lượng tham gia: ${elementPTSK.soLuongDaDangKy}/${elementPTSK.soLuongHoTro}", style: textDropdownTitle),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 20,
                        ),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 460,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadiusContainer,
                          boxShadow: [boxShadowContainer],
                          border: borderAllContainerBox,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tình nguyện viên mới',
                                  style: textNormal,
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: colorIconTitleBox,
                                  size: sizeIconTitleBox,
                                ),
                              ],
                            ),
                            //Đường line
                            Container(
                              margin: marginTopBottomHorizontalLine,
                              child: Divider(
                                thickness: 1,
                                color: ColorHorizontalLine,
                              ),
                            ),
                            (listTNV.length > 4)
                                ? Column(
                                    children: [
                                      for (int j = 0; j < 5; j++)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 13,
                                            bottom: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffC8C9CA),
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            // onHover: (value) => Colors.red,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  //Số thứ tự
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color:Color(0xff2B5378),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.elliptical(10, 10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '#${j + 1}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 20),
                                                Flexible(
                                                  child: Text(
                                                    "${listTNV[j].fullName} - ${listTNV[j].chucVu!.name} gia nhập ngày ${(listTNV[j].ngayVao != null && listTNV[j].ngayVao != "") ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listTNV[j].ngayVao!)) : ""}",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (() {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => XemTNV(
                                                        data: listTNV[j],
                                                      ));
                                            }),
                                          ),
                                        ),
                                      Container(
                                        margin: EdgeInsets.only(top: 18),
                                        child: TextButton(
                                          onPressed: () {
                                            context.go("/quan-ly-tnv");
                                          },
                                          child: Text(
                                            'Xem thêm',
                                            style: TextStyle(
                                              color:Color(0xff2B5378),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :(listTNV.length>0)
                               ?  Column(
                                    children: [
                                      for (int j = 0; j < listTNV.length; j++)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 13,
                                            bottom: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffC8C9CA),
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            // onHover: (value) => Colors.red,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  //Số thứ tự
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color:Color(0xff2B5378),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.elliptical(10, 10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '#${j + 1}',
                                                          // '${}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 20),
                                                Flexible(
                                                  child: Text(
                                                    "${listTNV[j].fullName} - ${listTNV[j].chucVu!.name} gia nhập ngày ${(listTNV[j].ngayVao != null && listTNV[j].ngayVao != "") ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listTNV[j].ngayVao!)) : ""}",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (() {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => XemTNV(
                                                        data: listTNV[j],
                                                      ));
                                            }),
                                          ),
                                        ),
                                      Container(
                                        margin: EdgeInsets.only(top: 18),
                                        child: TextButton(
                                          onPressed: () {
                                            context.go("/quan-ly-tnv");
                                          },
                                          child: Text(
                                            'Xem thêm',
                                            style: TextStyle(
                                              color:Color(0xff2B5378)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ):Column(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 20,
                        ),
                        width: MediaQuery.of(context).size.width * 1,
                        height: 460,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadiusContainer,
                          boxShadow: [boxShadowContainer],
                          border: borderAllContainerBox,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lịch phỏng vấn',
                                  style: textNormal,
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: colorIconTitleBox,
                                  size: sizeIconTitleBox,
                                ),
                              ],
                            ),
                            //Đường line
                            Container(
                              margin: marginTopBottomHorizontalLine,
                              child: Divider(
                                thickness: 1,
                                color: ColorHorizontalLine,
                              ),
                            ),
                            (listLPV.length > 4)
                                ? Column(
                                    children: [
                                      for (int j = 0; j < 5; j++)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 13,
                                            bottom: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffC8C9CA),
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            // onHover: (value) => Colors.red,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  //Số thứ tự
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color:Color(0xff2B5378),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.elliptical(10, 10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '#${j + 1}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 20),
                                                Flexible(
                                                   child: Text(
                                                    "[${listLPV[j].title}] lúc: ${(listLPV[j].thoiGian != null && listLPV[j].thoiGian != "") ? DateFormat('HH:mm a dd-MM-yyyy').format(DateTime.parse(listLPV[j].thoiGian!).toLocal()) : ""}",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (() {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => XemLPV(
                                                      data: listLPV[j],
                                                    ));
                                            }),
                                          ),
                                        ),
                                      Container(
                                        margin: EdgeInsets.only(top: 18),
                                        child: TextButton(
                                          onPressed: () {
                                            context.go("/lich-phong-van");
                                          },
                                          child: Text(
                                            'Xem thêm',
                                            style: TextStyle(
                                              color:Color(0xff2B5378),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :(listLPV.isNotEmpty)? Column(
                                    children: [
                                      for (int j = 0; j < listLPV.length; j++)
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 13,
                                            bottom: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color(0xffC8C9CA),
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            // onHover: (value) => Colors.red,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  //Số thứ tự
                                                  child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color:Color(0xff2B5378),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.elliptical(10, 10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '#${j + 1}',
                                                          // '${}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(width: 20),
                                                Flexible(
                                                 child: Text(
                                                    "[${listLPV[j].title}] lúc: ${(listLPV[j].thoiGian != null && listLPV[j].thoiGian != "") ? DateFormat('HH:mm a dd-MM-yyyy').format(DateTime.parse(listLPV[j].thoiGian!).toLocal()) : ""}",
                                                    softWrap: false,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (() {
                                               showDialog(
                                                context: context,
                                                builder: (BuildContext context) => XemLPV(
                                                      data: listLPV[j],
                                                    ));
                                            }),
                                          ),
                                        ),
                                      Container(
                                        margin: EdgeInsets.only(top: 18),
                                        child: TextButton(
                                          onPressed: () {
                                           context.go("/lich-phong-van");
                                          },
                                          child: Text(
                                            'Xem thêm',
                                            style: TextStyle(
                                              color:Color(0xff2B5378)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ):Column(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CommonApp().footerApp()
              ],
            )
          : CommonApp().loadingCallAPi(),
    );
  }
}
