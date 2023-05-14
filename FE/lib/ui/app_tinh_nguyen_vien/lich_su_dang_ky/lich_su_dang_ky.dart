// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:haivn/model/model_qltvn/tnv-ptsk.dart';
import 'package:localstorage/localstorage.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/paging.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';

import '../../../web_config.dart';
import '../phong_trao_su_kien/xem-ptsk.dart';

class LichSuDangKySceen extends StatelessWidget {
  const LichSuDangKySceen({super.key});
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
  int selectedValueRpp = 5;
  bool onload = false;

  int? statusId;
  List<TnvPtsk> listData = [];
  List<bool> selectedDataRow = [];
  TinhNguyenVien selectedTNV = TinhNguyenVien(id: null, fullName: "--Chọn sinh viên--", chucVu: ChucVu(name: ""));
  PhongTraoSuKien selectedPTSK = PhongTraoSuKien(id: null, title: "--Chọn PTSK--", listNguoiPhuTrach: []);
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  DateTime? ngaySinh;

  String search = "";

  List<int> listDelete = [];
  LocalStorage storage = LocalStorage("storage");
  String? id;

  Future<List<TnvPtsk>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      id = storage.getItem("id");
      if (search != "") {
        response = await httpGet("/api/tnv-ptsk/get/page?filter=idTnv:$id and $search&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/tnv-ptsk/get/page?filter=idTnv:$id&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
      }
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            totalElements = body["result"]["totalElements"];
            content = body["result"]["content"];
            page = body['result']['totalPages'];
            listData = content.map((e) {
              return TnvPtsk.fromJson(e);
            }).toList();
            selectedDataRow = List<bool>.generate(totalElements, (int index) => false);
          });

          for (var element in listData) {
            for (var elementTNV in element.phongTraoSuKien!.nguoiPhuTrachConvert!) {
              var responseTNV = await httpGet("/api/nguoi-dung/get/$elementTNV", context);
              var bodyTNV = jsonDecode(responseTNV["body"]);
              TinhNguyenVien tnv = TinhNguyenVien.fromJson(bodyTNV['result']);
              setState(() {
                element.phongTraoSuKien!.listNguoiPhuTrach.add(tnv);
              });
            }
            var responseSLTG = await httpGet("/api/phong-trao-su-kien/get/soluongtnv/${element.idPtsk}", context);
            var bodyTNV = jsonDecode(responseSLTG["body"]);
            setState(() {
              element.phongTraoSuKien!.soLuongDaDangKy = int.tryParse(bodyTNV.toString()) ?? 0;
            });
          }
        }
      }
    } catch (e) {
      return listData;
    }
    return listData;
  }

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

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiData();
  }

  void btnReset() {
    setState(() {
      search = "";
      selectedPTSK = PhongTraoSuKien(id: null, title: "--Chọn PTSK--", listNguoiPhuTrach: []);
      selectedTNV = TinhNguyenVien(id: null, fullName: "--Chọn sinh viên--", chucVu: ChucVu(name: ""));
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
      listDelete = [];
    });
    callApiData();
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findEmail = "";
      String findChucVu = "";

      if (selectedTNV.id != null) {
        findName = "and idTnv:${selectedTNV.id} ";
      } else {
        findName = "";
      }
      if (selectedPTSK.id != null) {
        findEmail = "and idPtsk:${selectedPTSK.id} ";
      } else {
        findEmail = "";
      }
      if (selectStatus.id != null) {
        findChucVu = "and status:${selectStatus.id} ";
      } else {
        findChucVu = "";
      }
      search = findName + findEmail + findChucVu;
      print(search);
      if (search != "") if (search.substring(0, 3) == "and") search = search.substring(4);
    });
    callApiData();
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
    callApiData();
    setState(() {
      onload = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                content: "Lịch sử đăng ký tham gia phong trào sự kiện",
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
        CommonApp().sizeBoxWidget(height: 25),
        Wrap(
          children: [
            for (var elementPTSK in listData)
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => XemPTSKTNVSceen(
                            data: elementPTSK.phongTraoSuKien!,
                          ));
                },
                child: Container(
                  width: 330,
                  height: 390,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: (elementPTSK.status == 0)
                        ? Color.fromARGB(255, 255, 234, 202)
                        : (elementPTSK.status == 1)
                            ? Color.fromARGB(255, 214, 255, 188)
                            : Color.fromARGB(255, 255, 193, 193),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        "$baseUrl/api/files/${elementPTSK.phongTraoSuKien!.poster}",
                        width: 300,
                        height: 220,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 10),
                      Text("${elementPTSK.phongTraoSuKien!.title}}", style: textCardContentBlack),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 145,
                            child: (elementPTSK.phongTraoSuKien!.status == 3)
                                ? Text("Huỷ", style: textDropdownTitleRed)
                                : (elementPTSK.phongTraoSuKien!.status == 1)
                                    ? Text("Đang diễn ra", style: textDropdownTitleGreen)
                                    : (elementPTSK.phongTraoSuKien!.status == 2)
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
                                  "${elementPTSK.phongTraoSuKien!.diaDiem}",
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
                          Expanded(child: Text("Từ: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.phongTraoSuKien!.startDate!))}", style: textDropdownTitle)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text("Đến: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(elementPTSK.phongTraoSuKien!.endDate!))}", style: textDropdownTitle))
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text("Số lượng tham gia: ${elementPTSK.phongTraoSuKien!.soLuongDaDangKy}/${elementPTSK.phongTraoSuKien!.soLuongHoTro}", style: textDropdownTitle),
                    ],
                  ),
                ),
              )
          ],
        ),
        CommonApp().sizeBoxWidget(height: 25),
        PagingTable(
          page: page,
          curentPage: curentPage,
          rowCount: totalElements,
          setCurentPage: (value) {
            curentPage = value;
            callApiData();
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
            children: [
              rederGVCN(context),
              renderStatus(context),
            ],
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

  renderStatus(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 0, "name": "Đăng ký"},
        {"id": 1, "name": "Tham gia"},
        {"id": 2, "name": "Từ chối"},
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

  rederGVCN(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phong trào sự kiện',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
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
    );
  }
}
