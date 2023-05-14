// ignore_for_file: file_names

import 'sinh-vien-dang-ky.dart';
import 'tinh-nguyen-vien.dart';

class LichPhongVan {
  int? id;
  String? title;
  String? content;
  String? thoiGian;
  String? diaDiem;
  String? thanhPhanThamDu;
  List<int>? thanhPhanThamDuConvert;
  List<TinhNguyenVien> listThanhPhanThamDu;
  String? sinhVienPv;
  List<int>? sinhVienPvConvert;
  List<SinhVienDangKy> listSinhVienPv;

  int? status;

  LichPhongVan({
    this.id,
    this.title,
    this.content,
    this.diaDiem,
    this.thoiGian,
    this.sinhVienPv,
    required this.listSinhVienPv,
    this.thanhPhanThamDu,
    required this.listThanhPhanThamDu,
    this.thanhPhanThamDuConvert,
    this.sinhVienPvConvert,
    this.status,
  });

  LichPhongVan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        thoiGian = json['thoiGian'],
        diaDiem = json['diaDiem'],
        thanhPhanThamDu = json['thanhPhanThamDu'],
        thanhPhanThamDuConvert = stringToList(json['thanhPhanThamDu']),
        sinhVienPv = json['sinhVienPv'],
        sinhVienPvConvert = stringToList(json['sinhVienPv']),
        listSinhVienPv=[],
        listThanhPhanThamDu=[],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'thoiGian': thoiGian,
        'diaDiem': diaDiem,
        'thanhPhanThamDu': thanhPhanThamDu,
        'sinhVienPv': sinhVienPv,
        'status': status,
      };
}

List<int> stringToList(String inputString) {
  String myString = inputString.substring(1, inputString.length - 1);
  List<String> myList = myString.split(",");
  return myList.map((e) => int.parse(e)).toList();
}
