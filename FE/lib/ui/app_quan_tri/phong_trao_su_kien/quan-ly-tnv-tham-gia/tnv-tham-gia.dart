// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:haivn/model/model_qltvn/tnv-ptsk.dart';
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

import 'cap-nhat-tnv-tham-gia.dart';
import 'them-moi-tnv-tham-gia.dart';

class QuanLyTNVThamGiaSceen extends StatelessWidget {
  const QuanLyTNVThamGiaSceen({super.key});
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

  Future<List<TnvPtsk>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet("/api/tnv-ptsk/get/page?filter=deleted:false and $search&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/tnv-ptsk/get/page?filter=deleted:false&sort=status&page=${curentPage - 1}&size=$selectedValueRpp", context);
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
                content: "Quản lý tvn tham gia phong trào sự kiện",
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
                    builder: (BuildContext context) => ThemMoiTNVThamGia(
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
              onPressed: (listDelete.length != 0)
                  ? () async {
                      print(listDelete);
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
                                                  Text('Xác nhận phê duyệt tham gia', style: textTitleAlertDialog),
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
                                          SelectableText("Xác nhận cho những tình nguyện viên tham dự phong trào sự kiện", style: textDataRow),
                                        ],
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
                                                  for (var elementDel in listDelete) {
                                                    await httpGet("/api/tnv-ptsk/approve/$elementDel", context);
                                                  }
                                                  // var response = await httpDelete("/api/tnv-ptsk/del/${listData[i].id}", context);
                                                  showToast(
                                                    context: context,
                                                    msg: "Phê duyệt thành công",
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
                  : () {},
              labelBtn: "Phê duyệt tham gia",
              iconBtn: const Icon(
                Icons.assignment_turned_in,
                color: Colors.white,
              ),
              colorBtn: (listDelete.length == 0) ? Colors.grey : const Color(0xff6C92D0),
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
                          'Tên tình nguyện viên',
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
                          'Phong trào sự kiện',
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
                          if (listData[i].status == 0) {
                            setState(
                              () {
                                selectedDataRow[i] = selected!;
                                if (selectedDataRow[i] == true) {
                                  listDelete.add(listData[i].id!);
                                } else {
                                  listDelete.remove(listData[i].id!);
                                }
                              },
                            );
                          }
                        },
                        selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText((listData[i].nguoiDung != null) ? "${listData[i].nguoiDung!.fullName}" : "", style: textDataRow)),
                          DataCell(SelectableText("${listData[i].nguoiDung!.chucVu!.name}", style: textDataRow)),
                          DataCell(SizedBox(width: 400, child: SelectableText("${listData[i].phongTraoSuKien!.title}", style: textDataRow))),
                          DataCell(SelectableText(
                              (listData[i].status == 0)
                                  ? "Đăng ký"
                                  : (listData[i].status == 1)
                                      ? "Tham gia"
                                      : (listData[i].status == 2)
                                          ? "Từ chối"
                                          : "",
                              style: textDataRow)),
                          DataCell(
                            Row(
                              children: [
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
                                                builder: (BuildContext context) => CapNhatTNVThamGia(
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
                                          onTap: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                      content: Container(
                                                        height: 150,
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
                                                                        Text('Xác nhận xoá', style: textTitleAlertDialog),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed: () => {Navigator.pop(context)},
                                                                    icon: const Icon(Icons.close),
                                                                  ),
                                                                ]),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        var response = await httpDelete("/api/tnv-ptsk/del/${listData[i].id}", context);
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
                                          },
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
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
              rederKhoa(context),
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

  rederKhoa(context) {
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
              child: DropdownSearch<TinhNguyenVien>(
                asyncItems: (String? filter) => callTNV(),
                itemAsString: (TinhNguyenVien? u) => "${u!.fullName} - ${u.chucVu!.name}",
                selectedItem: selectedTNV,
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
                    hintText: "--Chọn sinh viên--",
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
                    selectedTNV = value!;
                  });
                },
              )),
        ],
      ),
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
