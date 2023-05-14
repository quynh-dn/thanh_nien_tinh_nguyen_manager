// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, must_be_immutable
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/lich_phong_van.dart';
import 'package:intl/intl.dart';

import '../../../../model/model_qltvn/status.dart';

class XemLPV extends StatefulWidget {
  LichPhongVan data;
  XemLPV({
    super.key,
    required this.data,
  });

  @override
  State<XemLPV> createState() => _BodyState();
}

class _BodyState extends State<XemLPV> {
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

  LichPhongVan data = LichPhongVan(listSinhVienPv: [], listThanhPhanThamDu: []);

  //Trạng thái
  Future<List<Status>> callStatus() async {
    var object = [
      {"id": 0, "name": "Đăng ký"},
      {"id": 1, "name": "Chờ phỏng vấn"},
      {"id": 2, "name": "Đỗ"},
      {"id": 3, "name": "Trượt"},
    ];

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    return listStatus;
  }

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  void dispose() {
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
              {'url': "/lich-phong-van", 'title': 'lịch phỏng vấn'},
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [containerShadow]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.title} ',
            style: titleContainerBox,
          ),
          (data.status == 0)
              ? Text(
                  "Chưa phỏng vấn",
                  style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 253, 146, 7)),
                )
              : (data.status == 1)
                  ? Text(
                      "Đã phỏng vấn",
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 51, 248, 2)),
                    )
                  : (data.status == 2)
                      ? Text(
                          'Huỷ',
                          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 76, 22)),
                        )
                      : Row(),
          CommonApp().sizeBoxWidget(height: 15),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Wrap(
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời gian:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        DateFormat('HH:mm a   dd-MM-yyyy').format(DateTime.parse(data.thoiGian!)),
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Địa điểm:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.diaDiem}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nội dung:',
                      style: textDropdownTitle,
                    ),
                    CommonApp().sizeBoxWidget(height: 10),
                    SizedBox(
                      width: 300,
                      child: Text(
                        "${data.content}",
                        style: textDropdownTitle,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Text(
            'Người phỏng vấn:',
            style: textDropdownTitle,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Wrap(
            children: [
              for (var element in data.listThanhPhanThamDu)
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(bottom: 25, right: 40),
                  child: SelectableText(
                    '${element.fullName} - ${element.chucVu!.name} - ${element.sdt}',
                    style: textDropdownTitle,
                  ),
                )
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          CommonApp().sizeBoxWidget(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ứng viên:',
                style: textDropdownTitle,
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
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
                          'Lớp',
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
                          'Đánh giá',
                          style: textDataColumn,
                        ),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    for (int i = 0; i < data.listSinhVienPv.length; i++)
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            '${i + 1}',
                            style: textDataRow,
                          )),
                          DataCell(SelectableText(data.listSinhVienPv[i].fullName ?? "", style: textDataRow)),
                          DataCell(SelectableText(data.listSinhVienPv[i].lopHoc!.name ?? "", style: textDataRow)),
                          DataCell(SelectableText(data.listSinhVienPv[i].sdt ?? "", style: textDataRow)),
                          DataCell(SelectableText(
                              (data.listSinhVienPv[i].status == 0)
                                  ? "Đăng ký"
                                  : (data.listSinhVienPv[i].status == 1)
                                      ? "Chờ phỏng vấn"
                                      : (data.listSinhVienPv[i].status == 2)
                                          ? "Đỗ"
                                          : (data.listSinhVienPv[i].status == 3)
                                              ? "Trượt"
                                              : "",
                              style: textDataRow)),
                          (data.status==0)
                          ?DataCell(
                            Row(
                              children: [
                                DropdownSearch<Status>(
                                  selectedItem: data.listSinhVienPv[i].statusObj,
                                  asyncItems: (String? filter) => callStatus(),
                                  itemAsString: (Status? u) => u!.name.toString(),
                                  // items:listStatus ?? [],
                                  dropdownDecoratorProps: const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      constraints: BoxConstraints.tightFor(
                                        width: 150,
                                        height: 40,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
                                      ),
                                      // hintText: hintText ?? '--Trạng thái--',
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
                                      width: 150,
                                      height: 200,
                                    ),
                                    showSearchBox: false,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      data.listSinhVienPv[i].statusObj = value;
                                      data.listSinhVienPv[i].status = value!.id;
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                          : DataCell(SelectableText( data.listSinhVienPv[i].statusObj!.name ?? "", style: textDataRow)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          CommonApp().sizeBoxWidget(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  processing();
                  for (var elementSV in data.listSinhVienPv) {
                    if (elementSV.status == 1) {
                      await httpGet("/api/sinh-vien-dang-ky/pv/${elementSV.id}", context);
                    } else if (elementSV.status == 2) {
                      await httpGet("/api/sinh-vien-dang-ky/pass/${elementSV.id}", context);
                    } else if (elementSV.status == 3) {
                      await httpGet("/api/sinh-vien-dang-ky/fail/${elementSV.id}", context);
                    }
                  }
                  Navigator.pop(context);
                  showToast(
                    context: context,
                    msg: "Cập nhật thành công",
                    color: Color.fromARGB(136, 72, 238, 67),
                    icon: const Icon(Icons.done),
                  );
                },
                child: Text('Lưu', style: textBtnWhite),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff6C92D0),
                  elevation: 3,
                  minimumSize: Size(100, 40),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
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
