// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/paging.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model.dart';
import '../../../../model/model_qltvn/lop_hoc.dart';
import '../../../../model/model_qltvn/status.dart';
import 'sua-dang-ky.dart';
import 'them-moi-dang-ky.dart';
import 'xem-dang-ky.dart';

class QuanLyDangKySceen extends StatelessWidget {
  const QuanLyDangKySceen({super.key});

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
  TextEditingController lop = TextEditingController();
  TextEditingController maSV = TextEditingController();
  List<SinhVienDangKy> listData = [];
  List<bool> selectedDataRow = [];

  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");
  Status selectGender = Status(id: null, name: "--Chọn giới tính--");
  LopHoc selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");

  String search = "";

  Future<List<SinhVienDangKy>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet("/api/sinh-vien-dang-ky/get/page?filter=deleted:false and $search&sort=status&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/sinh-vien-dang-ky/get/page?filter=deleted:false&sort=status&sort=id,desc&page=${curentPage - 1}&size=$selectedValueRpp", context);
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
              return SinhVienDangKy.fromJson(e);
            }).toList();
            selectedDataRow = List<bool>.generate(totalElements, (int index) => false);
          });
        }
      }
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

  Future<bool> deleteTopic(idTopic) async {
    try {
      var response = await httpDelete("/api/sinh-vien-dang-ky/del/$idTopic", context);
      if (response.containsKey("body")) {
        var content = jsonDecode(response["body"]);
        if (content == true) {
          return true;
        } else {
          error = content["result"];
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void btnReset() {
    setState(() {
      name.text = '';
      lop.text = '';
      maSV.text = '';
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
      selectGender = Status(id: null, name: "--Chọn giới tính--");
      selectedLopHoc = LopHoc(id: null, name: "--Chọn lớp học--");
      search = "";
    });
    callApiData();
  }

  void clearAllSelections(id) async {
    processing();
    // for (int i = 0; i < listObjectTopic.length; i++) {
    //   var response = await httpDelete("/api/Topic/del/${listObjectTopic[i].id}", context);
    // }
    // callApiData();
    Navigator.pop(context);
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findMaSV = "";
      String findNameClass = "";
      String findGender = "";
      String findStatus = "";
      if (name.text != "") {
        findName = "and fullName~'*${name.text}*' ";
      } else {
        findName = "";
      }
      if (maSV.text != "") {
        findMaSV = "and maSV~'*${maSV.text}*' ";
      } else {
        findMaSV = "";
      }
      if (selectedLopHoc.id != null) {
        findNameClass = "and idLop:${selectedLopHoc.id!} ";
      } else {
        findNameClass = "";
      }
      if (selectGender.id != null) {
        if (selectGender.id == 0) {
          findGender = "and gioiTinh:false ";
        } else {
          findGender = "and gioiTinh:true ";
        }
      } else {
        findGender = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName + findMaSV + findNameClass + findGender + findStatus;
      if (search != "") if (search.substring(0, 3) == "and") search = search.substring(4);
    });
    print(search);
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
    name.dispose();
    lop.dispose();
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
                content: "Quản lý sinh viên đăng ký",
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
    SecurityModel securityModel = Provider.of<SecurityModel>(context, listen: true);

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
                    builder: (BuildContext context) => ThemMoiDangKy(
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
                          'Họ tên',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Mã sinh viên',
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
                          'Ngày sinh',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Giới tính',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Email',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Số điện thoại',
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
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(listData[i].fullName ?? "", style: textDataRow)),
                          DataCell(SelectableText(listData[i].maSV ?? "", style: textDataRow)),
                          DataCell(SelectableText((listData[i].lopHoc != null) ? listData[i].lopHoc!.name.toString() : "", style: textDataRow)),
                          DataCell(SizedBox(width: 100, child: SelectableText((listData[i].ngaySinh != null) ? DateFormat('dd-MM-yyyy').format(DateTime.parse(listData[i].ngaySinh!)) : "", style: textDataRow))),
                          DataCell(SelectableText((listData[i].gioiTinh == true) ? "Nữ" : "Nam", style: textDataRow)),
                          DataCell(SelectableText(listData[i].email ?? "", style: textDataRow)),
                          DataCell(SelectableText(listData[i].sdt ?? "", style: textDataRow)),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Đăng ký"
                                  : (listData[i].status == 1)
                                      ? "Chờ phỏng vấn"
                                      : (listData[i].status == 2)
                                          ? "Đỗ"
                                          : (listData[i].status == 3)
                                              ? "Trượt"
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
                                                builder: (BuildContext context) => XemDangKy(
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
                                                builder: (BuildContext context) => SuaDangKy(
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
                                Tooltip(
                                  message: "Xóa",
                                  child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: (listData[i].status == 0 ||listData[i].status == 3 )
                                              ? () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                            content: Container(
                                                              height: 300,
                                                              width: 460,
                                                              padding: const EdgeInsets.only(left: 10),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                        SizedBox(
                                                                          child: Row(
                                                                            children: [
                                                                              Text('Xác nhận xoá sinh viên đăng ký', style: textTitleAlertDialog),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        IconButton(
                                                                          onPressed: () => {Navigator.pop(context)},
                                                                          icon: const Icon(Icons.close),
                                                                        ),
                                                                      ]),
                                                                      const SizedBox(height: 10),
                                                                      const Divider(thickness: 1, color: Colors.black),
                                                                      const SizedBox(height: 20),
                                                                    ],
                                                                  ),
                                                                  Flexible(
                                                                    child: Text("Xoá sinh viên: ${listData[i].fullName}", style: textNormal),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      const SizedBox(height: 20),
                                                                      const Divider(thickness: 1, color: Colors.black),
                                                                      const SizedBox(height: 10),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          ElevatedButton(
                                                                            onPressed: () async {
                                                                              var response = await httpDelete("/api/sinh-vien-dang-ky/del/${listData[i].id}", context);

                                                                              showToast(
                                                                                context: context,
                                                                                msg: "Xoá thành công",
                                                                                color: const Color.fromARGB(136, 72, 238, 67),
                                                                                icon: const Icon(Icons.done),
                                                                              );
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: const Text('Xác nhận'),
                                                                            style: ElevatedButton.styleFrom(
                                                                              foregroundColor: Colors.white,
                                                                              backgroundColor: const Color.fromARGB(255, 100, 181, 248),
                                                                              minimumSize: const Size(100, 40),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 15),
                                                                          ElevatedButton(
                                                                            onPressed: () => Navigator.pop(context),
                                                                            child: Text('Hủy', style: textBtnWhite),
                                                                            style: ElevatedButton.styleFrom(
                                                                              foregroundColor: Colors.white,
                                                                              backgroundColor: const Color.fromARGB(255, 255, 132, 124),
                                                                              elevation: 3,
                                                                              minimumSize: const Size(100, 40),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                  btnReset();
                                                }
                                              : null,
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: (listData[i].status == 0||listData[i].status == 3 ) ? Colors.red : Colors.grey,
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
              rederMaSv(),
              rederLopHoc(context),
              renderGender(context),
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
        {"id": 1, "name": "Chờ phỏng vấn"},
        {"id": 2, "name": "Đỗ"},
        {"id": 3, "name": "Trượt"},
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

  renderGender(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 0, "name": "Nam"},
        {"id": 1, "name": "Nữ"},
      ],
      selectedItemStatus: selectGender,
      removeSelection: "removeSelection",
      onChangedCallback: (value) {
        selectGender = value;
      },
      indexTypeDropdow: 5,
      labelDropdow: Row(
        children: [
          Text(
            "Giới tính",
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
            'Họ tên',
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

  rederMaSv() {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã sinh viên',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: maSV,
            ),
          )
        ],
      ),
    );
  }

  rederNameClass(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lớp',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: lop,
            ),
          )
        ],
      ),
    );
  }

  rederLopHoc(context) {
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
}
