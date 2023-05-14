// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/paging.dart';
import '../../../../common/text_box.dart';
import '../../../../model/model_qltvn/lich_phong_van.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';

import 'cap-nhat-lpv.dart';
import 'them-moi-lpv.dart';
import 'xem-lpv.dart';

class LichPhongVanSceen extends StatelessWidget {
  const LichPhongVanSceen({super.key});
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

  TextEditingController title = TextEditingController();
  TextEditingController diaDiem = TextEditingController();
  List<LichPhongVan> listData = [];
  List<bool> selectedDataRow = [];
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  DateTime? tuNgay;
  DateTime? denNgay;

  String search = "";

  bool statusData = false;
  void callApi() async {
    setState(() {
      statusData = false;
    });
    await callApiData();
    setState(() {
      statusData = true;
    });
  }

  Future<List<LichPhongVan>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet(
            "/api/lich-phong-van/get/page?filter=deleted:false and $search&sort=status&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
      } else {
        response = await httpGet(
            "/api/lich-phong-van/get/page?filter=deleted:false&sort=status&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp",
            context);
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
              return LichPhongVan.fromJson(e);
            }).toList();
            selectedDataRow =
                List<bool>.generate(totalElements, (int index) => false);
          });
          for (var element in listData) {
            if (element.status == 0 &&
                DateTime.now()
                        .difference(DateTime.parse(element.thoiGian!))
                        .inHours >
                    0) {
                      setState(() {
                        element.status=1;
                        changeStatus(element);

                      });
                    }
            for (var elementSV in element.sinhVienPvConvert!) {
              var responseSV = await httpGet(
                  "/api/sinh-vien-dang-ky/get/$elementSV", context);
              var bodySV = jsonDecode(responseSV["body"]);

              SinhVienDangKy sv = SinhVienDangKy.fromJson(bodySV['result']);
              setState(() {
                element.listSinhVienPv.add(sv);
              });
            }
            for (var elementTNV in element.thanhPhanThamDuConvert!) {
              var responseTNV =
                  await httpGet("/api/nguoi-dung/get/$elementTNV", context);
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

  changeStatus(LichPhongVan lpv)async{
    await httpPut("/api/lich-phong-van/put/${lpv.id}", lpv.toJson(), context);

  }

  onChangedStatus(value) {
    statusId = value.id;
  }

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApi();
  }

  void btnReset() {
    setState(() {
      title.text = '';
      diaDiem.text = '';
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
      search = "";
      tuNgay = null;
      denNgay = null;
    });
    callApi();
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findDiaDiem = "";
      String findTuNgay = "";
      String findDenNgay = "";
      String findStatus = "";

      if (title.text != "") {
        findName = "and title~'*${title.text}*' ";
      } else {
        findName = "";
      }
      if (diaDiem.text != "") {
        findDiaDiem = "and diaDiem~'*${diaDiem.text}*' ";
      } else {
        findDiaDiem = "";
      }
      if (tuNgay != null) {
        findTuNgay =
            "and thoiGian>:'${DateFormat('dd-MM-yyyy').format(tuNgay!)} 00:00:00' ";
      } else {
        findTuNgay = "";
      }
      if (denNgay != null) {
        findDenNgay =
            "and thoiGian<:'${DateFormat('dd-MM-yyyy').format(denNgay!)} 23:59:59' ";
      } else {
        findDenNgay = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName + findDiaDiem + findStatus + findTuNgay + findDenNgay;
      print(search);
      if (search != "") if (search.substring(0, 3) == "and")
        search = search.substring(4);
    });
    callApi();
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
    callApi();
  }

  @override
  void dispose() {
    title.dispose();
    diaDiem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (statusData == true)
        ? ListView(
            controller: scrollControllerHideMenu,
            children: [
              const BreadCrumb(
                listPreTitle: [
                  {'url': "/trang-chu", 'title': 'Trang chủ'},
                ],
                content: "Lịch phỏng vấn",
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [containerShadow]),
      child: Column(children: [
        Row(
          children: [
            BtnAppWidget(
              onPressed: () async {
                // bool statusChange = false;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => ThemMoiLPVSceen());
                btnReset();
              },
              labelBtn: "Thêm mới",
              iconBtn: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
        CommonApp().sizeBoxWidget(height: 25),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: (listData != [])
              ? DataTable(
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
                          'Tính năng',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    for (int i = 0; i < listData.length; i++)
                      DataRow(
                        // onSelectChanged: (bool? selected) {
                        //   setState(
                        //     () {
                        //       selectedDataRow[i] = selected!;
                        //     },
                        //   );
                        // },
                        // selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SizedBox(
                              width: 300,
                              child: SelectableText(listData[i].title ?? "",
                                  style: textDataRow))),
                          DataCell(SelectableText(
                              (listData[i].thoiGian != null)
                                  ? DateFormat('HH:mm dd-MM-yyyy').format(
                                      DateTime.parse(listData[i].thoiGian!)
                                          .toLocal())
                                  : "",
                              style: textDataRow)),
                          DataCell(SizedBox(
                              width: 300,
                              child: SelectableText(
                                  (listData[i].diaDiem != null)
                                      ? listData[i].diaDiem!
                                      : "",
                                  style: textDataRow))),
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
                                      // ignore: prefer_const_constructors
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 162, 210, 252),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        XemLPV(
                                                          data: listData[i],
                                                        ));
                                          },
                                          child: const Icon(
                                            Icons.visibility,
                                            color: Color(0xFF023E74),
                                            size: 20,
                                          ))),
                                ),
                                Tooltip(
                                  message: "Sửa",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFEE2B5),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap:(listData[i].status!=2)? () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        CapNhatLPV(
                                                          data: listData[i],
                                                          callBack: (value) {
                                                            setState(() {
                                                              listData[i] =
                                                                  value;
                                                            });
                                                          },
                                                        ));
                                          }:null,
                                          child:  Icon(
                                            Icons.edit_calendar,
                                            color:(listData[i].status!=2)? Color(0xffD97904):Colors.grey,
                                            size: 20,
                                          ))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              : CommonApp().loadingCallAPi(),
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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [containerShadow]),
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
              rederName(context),
              rederDiaDiem(),
              rederTuNgay(),
              rederDenNgay(),
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
          const SizedBox(height: 20)
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: marginRightForm, bottom: 25),
    );
  }

  rederName(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
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
              controller: title,
            ),
          )
        ],
      ),
    );
  }

  rederTuNgay() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Từ ngày',
            style: textDropdownTitle,
          ),
          SizedBox(height: 15),
          DatePickerBox(
            selectedDate: tuNgay,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1 / 5, color: Colors.black45),
                borderRadius: BorderRadius.circular(5)),
            callBack: (value) {
              tuNgay = value;
            },
          )
        ],
      ),
    );
  }

  rederDenNgay() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đến ngày',
            style: textDropdownTitle,
          ),
          SizedBox(height: 15),
          DatePickerBox(
            selectedDate: denNgay,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1 / 5, color: Colors.black45),
                borderRadius: BorderRadius.circular(5)),
            callBack: (value) {
              denNgay = value;
            },
          )
        ],
      ),
    );
  }

  rederDiaDiem() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Địa điểm',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: diaDiem,
            ),
          )
        ],
      ),
    );
  }
}
