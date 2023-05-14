// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import 'package:haivn/model/model_qltvn/sinh-vien-dang-ky.dart';

import '../../api.dart';
import '../../model/model_qltvn/lop_hoc.dart';
import '../../model/model_qltvn/status.dart';
import '../common_app/common_app.dart';
import '../style.dart';

class DropdowSearchComon extends StatefulWidget {
  final Function? onChangedCallback; //hàm call back
  final int indexTypeDropdow; //Lựa chọn các dropdow khác nhau
  final Widget? labelDropdow; //Tiêu đề
  final EdgeInsetsGeometry? marginDropdow; //Khoảng cách
  final double? widthDropdow; //Độ rộng
  final int? selectStatus;
  final Status? selectedItemStatus;
  final LopHoc? selectedItemLopHoc; //Sử dụng khi call api về
  final ChucVu? selectedItemChucVu; //Sử dụng khi call api về
  final String? removeSelection; //Xóa bỏ lựa chọn trả về -1
  final int? selectedValueRpp; //Số lượng hiển thị dữ liệu trong bảng
  final Status? selectedTrueFalse;
  final List<dynamic>? listStatusSelect;

  const DropdowSearchComon({super.key, this.marginDropdow, this.onChangedCallback, required this.indexTypeDropdow, this.labelDropdow, this.selectedItemChucVu, this.widthDropdow, this.selectStatus, this.selectedItemStatus, this.removeSelection, this.selectedValueRpp, this.selectedTrueFalse, this.listStatusSelect, this.selectedItemLopHoc});

  @override
  State<DropdowSearchComon> createState() => _DropdowSearchComonState();
}

class _DropdowSearchComonState extends State<DropdowSearchComon> {
  //call api lop hoc
  Future<List<LopHoc>> callLopHoc() async {
    List<LopHoc> listDepartment = [];
    try {
      var response = await httpGet("/api/lop-hoc/get/page?filter=status:1", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return LopHoc.fromJson(e);
            }).toList();
            if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
              LopHoc all = LopHoc(id: null, name: "--Chọn lớp học--");
              listDepartment.insert(0, all);
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  //call api lop hoc
  Future<List<ChucVu>> callChucVu() async {
    List<ChucVu> listDepartment = [];
    try {
      var response = await httpGet("/api/chuc-vu/get/page?filter=status:1&sort=level", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return ChucVu.fromJson(e);
            }).toList();
            if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
              ChucVu all = ChucVu(id: null, name: "--Chọn chức vụ--");
              listDepartment.insert(0, all);
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  //call api sinh vien dang ky status = 0
  Future<List<SinhVienDangKy>> callSinhVienDangKy(List<int> khac) async {
    String searchKhac = "";
    for (var element in khac) {
      searchKhac += "and id!$element ";
    }
    List<SinhVienDangKy> listDepartment = [];
    try {
      var response = await httpGet("/api/sinh-vien-dang-ky/get/page?filter=status:0 $searchKhac", context);
      if (response.containsKey("body")) {
        var body = jsonDecode(response["body"]);
        var content = [];
        if (body["success"] == true) {
          setState(() {
            content = body["result"]["content"];
            listDepartment = content.map((e) {
              return SinhVienDangKy.fromJson(e);
            }).toList();
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return listDepartment;
  }

  //Trạng thái
  Future<List<Status>> callStatus() async {
    var object = [];

    if (widget.listStatusSelect != null && widget.listStatusSelect!.isNotEmpty) {
      object = widget.listStatusSelect!;
    } else {
      if (widget.selectStatus == 2) {
        object = [
          {"id": 0, "name": "Draft"},
          {"id": 1, "name": "active"},
        ];
      } else if (widget.selectStatus == 3) {
        object = [
          {"id": 0, "name": "Draft"},
          {"id": 1, "name": "active"},
          {"id": 2, "name": "Đã cập nhật bản mới nhất"},
        ];
      }
    }

    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
      Status all = Status(id: null, name: "--Chọn trạng thái--");
      listStatus.insert(0, all);
    }

    return listStatus;
  }

  //
  Future<List<Status>> callGender() async {
    var object = [
      {"id": 0, "name": "Nam"},
      {"id": 1, "name": "Nữ"},
    ];
    List<Status> listStatus = [];
    setState(() {
      listStatus = object.map((e) {
        return Status.fromJson(e);
      }).toList();
    });
    if (widget.removeSelection != null && widget.removeSelection == "removeSelection") {
      Status all = Status(id: null, name: "--Chọn giới tính--");
      listStatus.insert(0, all);
    }

    return listStatus;
  }

  Widget selectDropdow(value) {
    if (value == 1) {
      return dropdowGender();
    } else if (value == 2) {
      return dropdowLopHoc();
    } else if (value == 3) {
      return dropdowChucVu();
    } else if (value == 5) {
      return dropdowStatus();
    } else if (value == 6) {
      return dropdowTable();
    }
    return const Text("không có dữ liệu ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widthDropdow,
      margin: widget.marginDropdow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelDropdow ?? Text(""),
          CommonApp().sizeBoxWidget(height: 10),
          selectDropdow(widget.indexTypeDropdow),
        ],
      ),
    );
  }

  //dropdow lop hoc
  Widget dropdowLopHoc({String? hintText}) {
    return DropdownSearch<LopHoc>(
      asyncItems: (String? filter) => callLopHoc(),
      itemAsString: (LopHoc? u) => u!.name.toString(),
      selectedItem: widget.selectedItemLopHoc,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(
            width: 300,
            height: 40,
          ),
          contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
          hintText: hintText ?? "--Chọn lớp học--",
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
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
        widget.onChangedCallback!(value);
      },
      // selectedItems: ["Brazil"],
    );
  }

  //dropdow khoa
  Widget dropdowChucVu({String? hintText}) {
    return DropdownSearch<ChucVu>(
      asyncItems: (String? filter) => callChucVu(),
      itemAsString: (ChucVu? u) => u!.name.toString(),
      selectedItem: widget.selectedItemChucVu,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(
            width: 300,
            height: 40,
          ),
          contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
          hintText: hintText ?? "--Chọn lớp học--",
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
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
        widget.onChangedCallback!(value);
      },
      // selectedItems: ["Brazil"],
    );
  }

  //Trạng thái
  Widget dropdowStatus({String? hintText}) {
    return DropdownSearch<Status>(
      selectedItem: widget.selectedItemStatus,
      asyncItems: (String? filter) => callStatus(),
      itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
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
          width: 300,
          height: 300,
        ),
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }

  //gioi tinh
  Widget dropdowGender({String? hintText}) {
    return DropdownSearch<Status>(
      selectedItem: widget.selectedItemStatus,
      asyncItems: (String? filter) => callGender(),
      itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
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
          width: 300,
          height: 300,
        ),
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }

  //hien thi
  Widget dropdowTable({String? hintText}) {
    return DropdownSearch<int>(
      selectedItem: widget.selectedValueRpp,
      // asyncItems: (String? filter) => callStatus(),
      // itemAsString: (Status? u) => u!.name.toString(),
      // items: widget.listStatus ?? [],
      items: [5, 10, 20, 50],
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          constraints: const BoxConstraints.tightFor(
            width: 300,
            height: 40,
          ),
          contentPadding: const EdgeInsets.only(left: 14, bottom: 10),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black45, width: 1 / 5),
          ),
          // hintText: hintText ?? '--Trạng thái--',
          hintMaxLines: 1,
          enabledBorder: const OutlineInputBorder(
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
          height: 200,
        ),
        showSearchBox: false,
      ),
      onChanged: (value) {
        widget.onChangedCallback!(value);
      },
    );
  }
}
