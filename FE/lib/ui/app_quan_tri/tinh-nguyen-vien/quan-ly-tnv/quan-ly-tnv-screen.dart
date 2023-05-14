// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
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
import '../../../../common/paging.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/lop_hoc.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import 'cap-nhat-tnv.dart';
import 'them-tnv.dart';
import 'xem-tnv.dart';

class QuanLyTNVSceen extends StatelessWidget {
  const QuanLyTNVSceen({super.key});
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

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  List<TinhNguyenVien> listData = [];
  List<bool> selectedDataRow = [];
  LopHoc selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
  ChucVu selectedChucVu = ChucVu(id: null, name: "--Chọn chức vụ--");
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  DateTime? ngaySinh;

  String search = "";

  Future<List<TinhNguyenVien>> callApiData() async {
    setState(() {
      listData = [];
      onload = false;
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet("/api/nguoi-dung/get/page?filter=deleted:false and role:1 and $search&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/nguoi-dung/get/page?filter=deleted:false and role:1&page=${curentPage - 1}&size=$selectedValueRpp", context);
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
              return TinhNguyenVien.fromJson(e);
            }).toList();
            selectedDataRow = List<bool>.generate(totalElements, (int index) => false);
          });
        }
      }
      setState(() {
        onload = true;
      });
    } catch (e) {
      return listData;
    }
    return listData;
  }

  onChangedStatus(value) {
    statusId = value.id;
  }

  onChangeRowTable(value) {
    selectedValueRpp = value;
    curentPage = 1;
    callApiData();
  }

  void btnReset() {
    setState(() {
      name.text = '';
      selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
      selectedChucVu = ChucVu(id: null, name: "--Chọn lớp học--");
      email.text = "";
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
      search = "";
      ngaySinh = null;
    });
    callApiData();
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findEmail = "";
      String findChucVu = "";
      String findLop = "";
      String findNgayVao = "";
      String findStatus = "";

      if (name.text != "") {
        findName = "and fullName~'*${name.text}*' ";
      } else {
        findName = "";
      }
      if (email.text != "") {
        findEmail = "and email~'*${email.text}*' ";
      } else {
        findEmail = "";
      }
      if (selectedChucVu.id != null) {
        findChucVu = "and idChucVu:${selectedChucVu.id} ";
      } else {
        findChucVu = "";
      }
      if (selectedLopHoc.id != null) {
        findLop = "and ipLop:${selectedLopHoc.id} ";
      } else {
        findLop = "";
      }
      if (ngaySinh != null) {
        findNgayVao = "and ngayVao>'${DateFormat('dd-MM-yyyy').format(ngaySinh!)} 00:00:00' and ngayVao<'${DateFormat('dd-MM-yyyy').format(ngaySinh!)} 23:59:59' ";
      } else {
        findNgayVao = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName + findEmail + findStatus + findChucVu + findLop + findNgayVao;
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

  Future<void> createExcel(List<TinhNguyenVien> listTNV) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    int stt = listTNV.length;
    sheet.getRangeByIndex(1, 1, 1 + stt, 11).cellStyle.fontSize = 12;
    sheet.getRangeByIndex(1, 1, 2 + stt, 11).cellStyle.fontName = "Times New Roman";
    sheet.getRangeByIndex(1, 1, 2 + stt, 11).cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByIndex(1, 1, 2 + stt, 11).cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(2, 1, 2 + stt, 11).cellStyle.borders.all.lineStyle = LineStyle.thin;
    sheet.getRangeByIndex(2, 1, 2, 11).cellStyle.backColor = '#009c87';
    sheet.getRangeByIndex(2, 1, 2, 11).cellStyle.fontSize = 13;
    sheet.getRangeByIndex(2, 1, 2, 11).cellStyle.bold = true;
    sheet.getRangeByIndex(2, 1).rowHeight = 40;
    sheet.getRangeByIndex(3, 1, 1 + stt, 1).rowHeight = 25;
    sheet.getRangeByIndex(1, 1, 1, 11).merge();
    sheet.getRangeByIndex(1, 1).rowHeight = 45;
    sheet.getRangeByIndex(1, 1).setText("Danh sách tình nguyện viên");
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 25;
    sheet.getRangeByIndex(1, 1).cellStyle.bold = true;
    sheet.getRangeByName('A1').columnWidth = 6.4;
    sheet.getRangeByName('B1').columnWidth = 25;
    sheet.getRangeByName('C1').columnWidth = 30;
    sheet.getRangeByName('D1').columnWidth = 25;
    sheet.getRangeByName('E1').columnWidth = 25;
    sheet.getRangeByName('F1').columnWidth = 22;
    sheet.getRangeByName('G1').columnWidth = 22;
    sheet.getRangeByName('H1').columnWidth = 10;
    sheet.getRangeByName('I1').columnWidth = 35;
    sheet.getRangeByName('J1').columnWidth = 16;
    sheet.getRangeByName('K1').columnWidth = 60;
    sheet.getRangeByName('A2').setText("STT");
    sheet.getRangeByName('B2').setText("Mã sinh viên");
    sheet.getRangeByName('C2').setText("Họ và tên");
    sheet.getRangeByName('D2').setText("Lớp");
    sheet.getRangeByName('E2').setText("Chức vụ");
    sheet.getRangeByName('F2').setText("Ngày vào");
    sheet.getRangeByName('G2').setText("Ngày sinh");
    sheet.getRangeByName('H2').setText("Giới tính");
    sheet.getRangeByName('I2').setText("Email");
    sheet.getRangeByName('J2').setText("Số điện thoại");
    sheet.getRangeByName('K2').setText("Địa chỉ");
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:K${1 + stt}');
    for (var i = 0; i < listTNV.length; i++) {
      sheet.getRangeByName('A${i + 3}').setNumber(i + 1);
      sheet.getRangeByName('B${i + 3}').setText(listTNV[i].maSV);
      sheet.getRangeByName('C${i + 3}').setText(listTNV[i].fullName);
      sheet.getRangeByName('D${i + 3}').setText(listTNV[i].lopHoc!.name);
      sheet.getRangeByName('E${i + 3}').setText(listTNV[i].chucVu!.name);
      sheet.getRangeByName('F${i + 3}').setText(DateFormat('dd-MM-yyyy').format(DateTime.parse(listTNV[i].ngayVao!)));
      sheet.getRangeByName('G${i + 3}').setText(DateFormat('dd-MM-yyyy').format(DateTime.parse(listTNV[i].ngaySinh!)));
      sheet.getRangeByName('H${i + 3}').setText((listTNV[i].gioiTinh == true) ? "Nữ" : "Nam");
      sheet.getRangeByName('I${i + 3}').setText(listTNV[i].email);
      sheet.getRangeByName('J${i + 3}').setText(listTNV[i].sdt);
      sheet.getRangeByName('K${i + 3}').setText(listTNV[i].diaChi);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Danh_sach_tinh_nguyen_vien.xlsx')
        ..click();
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
    name.dispose();
    email.dispose();
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
                content: "Quản lý tình nguyện viên",
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
          children: [
            BtnAppWidget(
              onPressed: () async {
                bool statusChange = false;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) => ThemMoiTNV(
                          callBack: (value) {
                            statusChange = value;
                          },
                        ));
                if (statusChange) {
                  btnReset();
                }
              },
              labelBtn: "Thêm mới",
              iconBtn: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            BtnAppWidget(
              onPressed: () async {
                List<TinhNguyenVien> listExport = [];
                try {
                  var response;
                  if (search != "") {
                    response = await httpGet("/api/nguoi-dung/get/page?filter=deleted:false and role:1 and $search", context);
                  } else {
                    response = await httpGet("/api/nguoi-dung/get/page?filter=deleted:false and role:1", context);
                  }
                  if (response.containsKey("body")) {
                    var body = jsonDecode(response["body"]);
                    var content = [];
                    if (body["success"] == true) {
                      setState(() {
                        totalElements = body["result"]["totalElements"];
                        content = body["result"]["content"];
                        page = body['result']['totalPages'];
                        listExport = content.map((e) {
                          return TinhNguyenVien.fromJson(e);
                        }).toList();
                        selectedDataRow = List<bool>.generate(totalElements, (int index) => false);
                      });
                    }
                  }
                  setState(() {
                    onload = true;
                  });
                } catch (e) {
                  return listData;
                }
                createExcel(listExport);
              },
              labelBtn: "Xuất file",
              iconBtn: const Icon(
                Icons.vertical_align_bottom,
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
                          'Tên',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Chức vụ',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngày vào',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Lớp',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Số điện thoại",
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Email",
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
                        onSelectChanged: (bool? selected) {
                          setState(
                            () {
                              selectedDataRow[i] = selected!;
                            },
                          );
                        },
                        selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(listData[i].fullName ?? "", style: textDataRow)),
                          DataCell(SelectableText((listData[i].chucVu != null) ? listData[i].chucVu!.name.toString() : "", style: textDataRow)),
                          DataCell(SelectableText((listData[i].ngayVao != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listData[i].ngayVao!)) : "", style: textDataRow)),
                          DataCell(SelectableText((listData[i].lopHoc != null) ? listData[i].lopHoc!.name.toString() : "", style: textDataRow)),
                          DataCell(SelectableText(listData[i].sdt ?? "", style: textDataRow)),
                          DataCell(SelectableText(listData[i].email ?? "", style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Khoá"
                                  : (listData[i].status == 1)
                                      ? "Hoạt động"
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
                                      decoration: BoxDecoration(color: Color.fromARGB(255, 162, 210, 252), borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => XemTNV(
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
                                      decoration: BoxDecoration(color: const Color(0xffFEE2B5), borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CapNhatTNV(
                                                      data: listData[i],
                                                      callBack: (value) {
                                                        setState(() {
                                                          listData[i] = value;
                                                        });
                                                      },
                                                    ));
                                          },
                                          child: const Icon(
                                            Icons.edit_calendar,
                                            color: Color(0xffD97904),
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
              rederName(context),
              rederKhoa(context),
              rederGVCN(context),
              rederVao(),
              rederEmail(),
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
        {"id": 0, "name": "Khoá"},
        {"id": 1, "name": "Hoạt động"},
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

  rederName(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên',
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

  rederKhoa(context) {
    return DropdowSearchComon(
      removeSelection: "removeSelection",
      selectedItemChucVu: selectedChucVu,
      onChangedCallback: (value) {
        selectedChucVu = value;
      },
      indexTypeDropdow: 3,
      labelDropdow: Row(
        children: [
          Text(
            'Chức vụ',
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: marginRightForm, bottom: 25),
    );
  }

  rederGVCN(context) {
    return DropdowSearchComon(
      removeSelection: "removeSelection",
      selectedItemLopHoc: selectedLopHoc,
      onChangedCallback: (value) {
        selectedLopHoc = value;
      },
      indexTypeDropdow: 2,
      labelDropdow: Row(
        children: [
          Text(
            'Lớp',
            style: textDropdownTitle,
          ),
        ],
      ),
      widthDropdow: 300,
      marginDropdow: EdgeInsets.only(right: marginRightForm, bottom: 25),
    );
  }

  rederVao() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngày vào',
            style: textDropdownTitle,
          ),
          SizedBox(height: 15),
          DatePickerBox(
            selectedDate: ngaySinh,
            width: 300,
            decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
            callBack: (value) {
              ngaySinh = value;
            },
          )
        ],
      ),
    );
  }

  rederEmail() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: email,
            ),
          )
        ],
      ),
    );
  }
}
