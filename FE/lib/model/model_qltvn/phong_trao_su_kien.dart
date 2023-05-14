import 'tinh-nguyen-vien.dart';

class PhongTraoSuKien {
  int? id;
  String? title;
  String? content;
  String? poster;
  String? startDate;
  String? endDate;
  String? diaDiem;
  String? kinhPhi;
  String? nguoiPhuTrach;
  List<int>? nguoiPhuTrachConvert;
  List<TinhNguyenVien> listNguoiPhuTrach;
  int? soLuongHoTro;
  int? soLuongDaDangKy;
  int? status;

  PhongTraoSuKien({
    this.id,
    this.title,
    this.content,
    this.poster,
    this.startDate,
    this.endDate,
    this.diaDiem,
    this.kinhPhi,
    this.nguoiPhuTrach,
    this.nguoiPhuTrachConvert,
    required this.listNguoiPhuTrach,
    this.soLuongHoTro,
    this.soLuongDaDangKy,
    this.status,
  });

  PhongTraoSuKien.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        poster = json['poster'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        diaDiem = json['diaDiem'],
        kinhPhi = json['kinhPhi'],
        nguoiPhuTrach = json['nguoiPhuTrach'],
        nguoiPhuTrachConvert = stringToList(json['nguoiPhuTrach']),
        listNguoiPhuTrach = [],
        soLuongHoTro = json['soLuongHoTro'],
        soLuongDaDangKy = 0,
        status = json['status'];

  Map<String, dynamic> toJson() => {'title': title, 'content': content, 'poster': poster, 'startDate': startDate, 'endDate': endDate, 'diaDiem': diaDiem, 'kinhPhi': kinhPhi, 'nguoiPhuTrach': nguoiPhuTrach, 'soLuongHoTro': soLuongHoTro, 'status': status};
}

List<int> stringToList(String inputString) {
  String myString = inputString.substring(1, inputString.length - 1);
  List<String> myList = myString.split(",");
  return myList.map((e) => int.parse(e)).toList();
}
