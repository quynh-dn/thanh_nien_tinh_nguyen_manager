// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import '../../../api.dart';
import '../../../common/breadcrumb.dart';
import '../../../common/btn_app/btn_app.dart';
import '../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../common/common_app/common_app.dart';

import '../../../common/paging.dart';
import '../../../common/text_box.dart';
import '../../../model/model_qltvn/phong_trao_su_kien.dart';
import 'package:intl/intl.dart';

import '../../../model/model_qltvn/status.dart';
import '../../../model/model_qltvn/tinh-nguyen-vien.dart';
import '../../../web_config.dart';
import '../../app_quan_tri/phong_trao_su_kien/xem-ptsk.dart';
import 'xem-ptsk.dart';

class PTSKTNVSceen extends StatelessWidget {
  const PTSKTNVSceen({super.key});

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
  String findTopic = "";
  String error = "";
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

  int curentPage = 1;
  int page = 0;
  int totalElements = 0;
  int selectedValueRpp = 8;
  bool onload = false;

  int? statusId;

  TextEditingController name = TextEditingController();
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  List<PhongTraoSuKien> listPTSK = [];
  List<bool> selectedDataRow = [];
  String search = "";
  Future<List<PhongTraoSuKien>> callApiTopic() async {
    try {
      var response;
      if (search != "") {
        response = await httpGet("/api/phong-trao-su-kien/get/page?filter=$search and status!3&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/phong-trao-su-kien/get/page?filter=status!3&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
      }

      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            totalElements = body["result"]["totalElements"];
            content = body["result"]["content"];
            page = body['result']['totalPages'];
            listPTSK = content.map((e) {
              return PhongTraoSuKien.fromJson(e);
            }).toList();

            selectedDataRow = List<bool>.generate(totalElements, (int index) => false);
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

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiTopic();
  }

  void btnReset() {
    setState(() {
      search = "";
      name.text = '';
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
    });
    callApiTopic();
  }

  void btnSearch() {
    setState(() {
      search = "";
      String findName = "";
      String findStatus = "";
      if (name.text != "") {
        findName = "and title~'*${name.text}*' ";
      } else {
        findName = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName + findStatus;
      print(search);
      if (search != "") if (search.substring(0, 3) == "and") search = search.substring(4);
    });
    callApiTopic();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    callApiTopic();
    setState(() {
      onload = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (onload == true)
        ? ListView(
            controller: scrollControllerHideMenu,
            children: [
              const BreadCrumb(
                listPreTitle: [
                  {'url': "/trang-chu", 'title': 'Trang chủ'},
                ],
                content: "Phong trào sự kiện",
              ),
              Container(
                padding: paddingPage,
                child: Column(
                  children: [
                    renderSearch(context),
                    CommonApp().sizeBoxWidget(height: 30),
                    tableWidget(context),
                  ],
                ),
              ),
              CommonApp().footerApp(),
            ],
          )
        : CommonApp().loadingCallAPi();
  }

  Widget tableWidget(context) {
    var tableIndex = (curentPage - 1) * selectedValueRpp + 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(children: [
        CommonApp().dividerWidget(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Hiển thị',
              style: textDropdownTitle,
            ),
            CommonApp().sizeBoxWidget(width: 15),
            DropdowSearchComon(
              selectedValueRpp: selectedValueRpp,
              onChangedCallback: onChangeRowTable,
              indexTypeDropdow: 6,
              widthDropdow: 150,
              marginDropdow: EdgeInsets.only(right: marginRight, bottom: 25),
            ),
          ],
        ),
        CommonApp().sizeBoxWidget(height: 5),
        (listPTSK != [])
            ? Wrap(
                children: [
                  for (var elementPTSK in listPTSK)
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => XemPTSKTNVSceen(
                                  data: elementPTSK,
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
                                Expanded(child: Text("Từ: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.startDate!).toLocal())}", style: textDropdownTitle)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text("Đến: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.endDate!).toLocal())}", style: textDropdownTitle))
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text("Số lượng tham gia: ${elementPTSK.soLuongDaDangKy}/${elementPTSK.soLuongHoTro}", style: textDropdownTitle),
                          ],
                        ),
                      ),
                    )
                ],
              )
            : CommonApp().loadingCallAPi(),
        CommonApp().sizeBoxWidget(height: 25),
        PagingTable(
          page: page,
          curentPage: curentPage,
          rowCount: totalElements,
          setCurentPage: (value) {
            curentPage = value;
            callApiTopic();
            // setState(() {});
          },
        )
      ]),
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
            'Tìm kiếm',
            style: titleContainerBox,
          ),
          CommonApp().sizeBoxWidget(height: 25),
          Wrap(
            children: [rederName(context),renderStatus()],
          ),
          Row(
            children: [
              BtnAppWidget(
                onPressed: btnSearch,
                labelBtn: "Tìm kiếm",
                iconBtn: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              BtnAppWidget(
                labelBtn: "Đặt lại ",
                onPressed: btnReset,
                iconBtn: const Icon(
                  Icons.restart_alt_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  rederName(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRight, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiêu đề',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: name,
            ),
          )
        ],
      ),
    );
  }

  renderStatus() {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 1, "name": "Đang diễn ra"},
        {"id": 2, "name": "Hoàn thành"},
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
