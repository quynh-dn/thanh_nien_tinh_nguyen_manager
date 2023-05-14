// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haivn/common/header.dart';
import 'package:haivn/common/style.dart';
import 'package:haivn/model/model_qltvn/chuc_vu.dart';
import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import '../../../../api.dart';
import '../../../../common/breadcrumb.dart';
import '../../../../common/btn_app/btn_app.dart';
import '../../../../common/common_app/common_app.dart';
import '../../../../common/date_picker_box.dart';
import '../../../../common/dropdow_search/dropdow_search_common.dart';
import '../../../../common/text_box.dart';
import '../../../../common/toast.dart';
import '../../../../model/model_qltvn/lich_phong_van.dart';
import '../../../../model/model_qltvn/lop_hoc.dart';
import '../../../../model/model_qltvn/sinh-vien-dang-ky.dart';
import '../../../../model/model_qltvn/status.dart';
import '../../../../model/model_qltvn/tinh-nguyen-vien.dart';
import 'package:intl/intl.dart';

import '../../../web_config.dart';

class ThemMoiPTSKSceen extends StatefulWidget {
  PhongTraoSuKien? data;
  Function? callback;
  ThemMoiPTSKSceen({super.key, this.data, this.callback});

  @override
  State<ThemMoiPTSKSceen> createState() => _BodyState();
}

class _BodyState extends State<ThemMoiPTSKSceen> {
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

  TextEditingController title = TextEditingController();
  TextEditingController diaDiem = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController kinhPhi = TextEditingController();
  TextEditingController soLoung = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String poster = "";

  Status selectStatus = Status(id: null, name: "--Chọn trạng thái--");

  List<TinhNguyenVien> listTNV = [TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: "")];
  List<int> listCheckTNV = [0];

  Future<List<TinhNguyenVien>> callTNV(List<int> khac) async {
    String searchKhac = "";
    for (var element in khac) {
      searchKhac += "and id!$element ";
    }
    List<TinhNguyenVien> listDepartment = [];
    try {
      var response = await httpGet("/api/nguoi-dung/get/page?filter=status:1 and role:1 $searchKhac", context);
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

  PhongTraoSuKien data = PhongTraoSuKien(listNguoiPhuTrach: []);
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      data = widget.data!;
      title.text = data.title ?? "";
      content.text = data.content ?? "";
      diaDiem.text = data.diaDiem ?? "";
      kinhPhi.text = data.kinhPhi ?? "";
      soLoung.text = data.soLuongHoTro.toString();
      poster = data.poster ?? "";
      startDate = DateTime.tryParse(data.startDate.toString());
      endDate = DateTime.tryParse(data.endDate.toString());
      selectStatus = Status(
          id: data.status,
          name: (data.status == 0)
              ? "Huỷ"
              : (data.status == 1)
                  ? "Đang diễn ra"
                  : (data.status == 2)
                      ? "Hoàn thành"
                      : "");
      listCheckTNV = data.nguoiPhuTrachConvert ?? [];
      listTNV = data.listNguoiPhuTrach;
    }
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    diaDiem.dispose();
    kinhPhi.dispose();
    soLoung.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      content: ListView(
        controller: scrollControllerHideMenu,
        children: [
          BreadCrumb(
            listPreTitle: const [
              {'url': "/trang-chu", 'title': 'Trang chủ'},
              {'url': "/phong-trao-su-kien", 'title': 'Phong trào sự kiện'},
            ],
            content: (widget.data == null) ? "Tạo phong trào sự kiện" : "Cập nhật phong trào sự kiện",
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
            'Nhập thông tin',
            style: titleContainerBox,
          ),
          CommonApp().sizeBoxWidget(height: 25),
          Wrap(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tiêu đề ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
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
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Địa điểm ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
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
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ngày bắt đầu ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          DatePickerBox(
                            selectedDate: startDate,
                            width: 300,
                            decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                            callBack: (value) {
                              startDate = value;
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ngày kết thúc ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          DatePickerBox(
                            selectedDate: endDate,
                            width: 300,
                            decoration: BoxDecoration(border: Border.all(width: 1 / 5, color: Colors.black45), borderRadius: BorderRadius.circular(5)),
                            callBack: (value) {
                              endDate = value;
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Kinh phí ',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextBoxCustom(
                              height: 40,
                              controller: kinhPhi,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Số lượng người hỗ trợ dự kiến',
                                style: textDropdownTitle,
                              ),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          CommonApp().sizeBoxWidget(height: 10),
                          SizedBox(
                            width: 300,
                            child: TextBoxCustom(
                              height: 40,
                              controller: soLoung,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (widget.data != null) renderStatus(context)
            ],
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 60),
              width: 340,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Người phụ trách ',
                        style: textDropdownTitle,
                      ),
                      Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  CommonApp().sizeBoxWidget(height: 10),
                  for (var i = 0; i < listTNV.length; i++)
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownSearch<TinhNguyenVien>(
                            asyncItems: (String? filter) => callTNV(listCheckTNV),
                            itemAsString: (TinhNguyenVien? u) => "${u!.fullName} - ${u.maSV}",
                            selectedItem: listTNV[i],
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
                                listTNV[i] = value!;
                                listCheckTNV[i] = value.id!;
                              });
                            },
                          ),
                          (i == listTNV.length - 1)
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listTNV.removeAt(i);
                                              listCheckTNV.removeAt(i);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            size: 15,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listTNV.add(TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                              listCheckTNV.add(0);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 15,
                                          )),
                                    )
                                  ],
                                )
                              : (listTNV.length == 1)
                                  ? SizedBox(
                                      width: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listTNV.add(TinhNguyenVien(id: 0, fullName: "--Chọn sinh viên-", maSV: ""));
                                              listCheckTNV.add(0);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 15,
                                          )),
                                    )
                                  : SizedBox(
                                      width: 20,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listTNV.removeAt(i);
                                              listCheckTNV.removeAt(i);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            size: 15,
                                          )),
                                    ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ảnh áp phích   ',
                        style: textDropdownTitle,
                      ),
                      OutlinedButton(
                        child: Text("Tải ảnh"),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['png', 'JPEG', 'JPG', 'TIFF', 'GIF'],
                            withReadStream: true,
                            allowMultiple: false,
                          );
                          if (result != null) {
                            var avatarImage = await uploadFile(result, context: context);
                            setState(() {
                              poster = avatarImage;
                            });
                          } else {
                            return showToast(
                              context: context,
                              msg: "Chọn lại file",
                              color: Color.fromRGBO(245, 117, 29, 1),
                              icon: const Icon(Icons.info),
                            );
                          }
                        },
                      )
                    ],
                  ),
                  CommonApp().sizeBoxWidget(height: 10),
                  (poster != "")
                      ? Image.network(
                          "$baseUrl/api/files/$poster",
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        )
                      : Row()
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: backgroundPageColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Nội dung phong trào',
                      style: textDropdownTitle,
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
                CommonApp().sizeBoxWidget(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextBoxCustom(
                    controller: content,
                    minLines: 5,
                    maxLines: 1000,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  processing();
                  bool statusData = true;
                  for (var element in listTNV) {
                    if (element.id == 0) statusData = false;
                  }
                  if (title.text == "" || startDate == null || endDate == null || diaDiem.text == "" || soLoung.text == "" || kinhPhi.text == "" || statusData == false) {
                    showToast(
                      context: context,
                      msg: "Cần nhập đủ thông tin",
                      color: Colors.orange,
                      icon: const Icon(Icons.warning),
                    );
                    Navigator.pop(context);
                  } else {
                    data.title = title.text;
                    data.diaDiem = diaDiem.text;
                    data.content = content.text;
                    data.startDate = DateFormat('yyyy-MM-dd').format(startDate!);
                    data.endDate = DateFormat('yyyy-MM-dd').format(endDate!);
                    data.soLuongHoTro = int.tryParse(soLoung.text);
                    data.poster = (poster != "") ? poster : null;
                    data.kinhPhi = kinhPhi.text;

                    data.nguoiPhuTrach = listCheckTNV.toString();
                    print(data.toJson());
                    if (widget.data == null) {
                      data.status = 1;
                      var response = await httpPost("/api/phong-trao-su-kien/post", data.toJson(), context);
                      showToast(
                        context: context,
                        msg: "Thêm mới thành công",
                        color: Color.fromARGB(136, 72, 238, 67),
                        icon: const Icon(Icons.done),
                      );
                      Navigator.pop(context);
                    } else {
                      data.status = selectStatus.id;
                      var response = await httpPut("/api/phong-trao-su-kien/put/${widget.data!.id}", data.toJson(), context);
                      print(response);
                      showToast(
                        context: context,
                        msg: "Cập nhật thành công",
                        color: Color.fromARGB(136, 72, 238, 67),
                        icon: const Icon(Icons.done),
                      );
                      widget.callback!(data);
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                  }
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
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.data != null) widget.callback!(data);
                },
                child: Text('Hủy', style: textBtnWhite),
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

  renderStatus(context) {
    return DropdowSearchComon(
      listStatusSelect: const [
        {"id": 1, "name": "Đang diễn ra"},
        {"id": 2, "name": "Hoàn thành"},
        {"id": 3, "name": "Huỷ"},
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
