// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/paging.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/chuc_vu.dart';
import '../../../../model/model_qltvn/status.dart';
import 'cap_nhat_chuc_vu.dart';
import 'them_moi_chuc_vu.dart';

class QuanLyChucVuSceen extends StatelessWidget {
  const QuanLyChucVuSceen({super.key});

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
  TextEditingController level = TextEditingController();
  List<ChucVu> listData = [];
  List<bool> selectedDataRow = [];
  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  String search = "";

  Future<List<ChucVu>> callApiData() async {
    setState(() {
      listData = [];
    });
    try {
      var response;
      if (search != "") {
        response = await httpGet("/api/chuc-vu/get/page?filter=deleted:false and $search&page=${curentPage - 1}&size=$selectedValueRpp", context);
      } else {
        response = await httpGet("/api/chuc-vu/get/page?filter=deleted:false&page=${curentPage - 1}&size=$selectedValueRpp", context);
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
              return ChucVu.fromJson(e);
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
      var response = await httpDelete("/api/chuc-vu/del/$idTopic", context);
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
      level.text = '';
      selectStatus = Status(id: null, name: "--Chọn trạng thái--");
      search = "";
    });
    callApiData();
  }

  void clearAllSelections(id) async {
    processing();
    Navigator.pop(context);
  }

  void btnSearch() async {
    setState(() {
      search = "";
      String findName = "";
      String findLevel = "";
      String findStatus = "";
      if (name.text != "") {
        findName = "and name~'*${name.text}*' ";
      } else {
        findName = "";
      }
      if (level.text != "") {
        findLevel = "and level:${level.text} ";
      } else {
        findLevel = "";
      }
      if (selectStatus.id != null) {
        findStatus = "and status:${selectStatus.id} ";
      } else {
        findStatus = "";
      }
      search = findName + findLevel + findStatus;
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
    name.dispose();
    level.dispose();
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
                content: "Quản lý chức vụ",
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
                    builder: (BuildContext context) => ThemMoiChucVu(
                          callBack: (value) {
                            statusChange = value;
                          },
                        ));
                if (statusChange) {
                  btnReset();
                }
              },
              labelBtn: "Thêm mới chức vụ",
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
                          'Tên',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Cấp độ',
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

                              // if (selectedDataRow[i]) {
                              //   listObjectTopic.add(listTopic[i]);
                              // } else {
                              //   listObjectTopic.remove(listTopic[i]);
                              // }
                            },
                          );
                        },
                        selected: selectedDataRow[i],
                        cells: <DataCell>[
                          DataCell(Text(
                            '${tableIndex++}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(listData[i].name ?? "", style: textDataRow)),
                          DataCell(SelectableText((listData[i].level != null) ? listData[i].level.toString() : "", style: textDataRow)),
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
                                  message: "Sửa",
                                  child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: const Color(0xffFEE2B5), borderRadius: BorderRadius.circular(5)),
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CapNhatChucVu(
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
                                                                        Text('Xác nhận xoá chức vụ', style: textTitleAlertDialog),
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
                                                              child: Text("Xoá chức vụ: ${listData[i].name}", style: textNormal),
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
                                                                        var response = await httpDelete("/api/chuc-vu/del/${listData[i].id}", context);
                                                                        var body = jsonDecode(response["body"]);
                                                                        if (body == true) {
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Xoá chức vụ thành công",
                                                                            color: const Color.fromARGB(136, 72, 238, 67),
                                                                            icon: const Icon(Icons.done),
                                                                          );
                                                                          Navigator.pop(context);
                                                                        } else {
                                                                          showToast(
                                                                            context: context,
                                                                            msg: "Chức vụ đã được sử dụng",
                                                                            color: const Color.fromARGB(255, 255, 132, 124),
                                                                            icon: const Icon(Icons.warning),
                                                                          );
                                                                          Navigator.pop(context);
                                                                        }
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
              rederName(context),
              rederLevel(context),
              renderStatus(context),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 5),
          Center(
              child: Text(
            "Cấp độ: 0-Đội trưởng, 1-Đội phó, 2-Trưởng ban, 3-Thành viên",
            style: textCardContentBlack,
          )),
          CommonApp().sizeBoxWidget(height: 10),
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

  rederLevel(context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: marginRightForm, bottom: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cấp độ',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          SizedBox(
            width: 300,
            child: TextBoxCustom(
              height: 40,
              controller: level,
            ),
          )
        ],
      ),
    );
  }
}
