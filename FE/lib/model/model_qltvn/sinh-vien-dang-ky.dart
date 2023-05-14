// ignore_for_file: file_names

import 'package:haivn/model/model_qltvn/status.dart';

import 'lop_hoc.dart';

class SinhVienDangKy {
  int? id;
  String? fullName;
  String? maSV;
  int? idLop;
  LopHoc? lopHoc;
  String? ngaySinh;
  String? diaChi;
  bool? gioiTinh;
  String? email;
  String? sdt;
  int? status;
  Status? statusObj;

  SinhVienDangKy({this.id, this.fullName, this.maSV, this.idLop, this.lopHoc, this.ngaySinh, this.diaChi, this.gioiTinh, this.email, this.sdt, this.status, this.statusObj});

  SinhVienDangKy.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        maSV = json['maSV'],
        idLop = json['idLop'],
        lopHoc = LopHoc.fromJson(json['lopHoc']),
        ngaySinh = json['ngaySinh'],
        diaChi = json['diaChi'],
        gioiTinh = json['gioiTinh'],
        email = json['email'],
        sdt = json['sdt'],
        status = json['status'],
        statusObj = Status(
            id: json['status'],
            name: (json['status'] == 0)
                ? "Đăng ký"
                : (json['status'] == 1)
                    ? "Chờ phỏng vấn"
                    : (json['status'] == 2)
                        ? "Đỗ"
                        : (json['status'] == 3)
                            ? "Trượt"
                            : "");

  Map<String, dynamic> toJson() => {'fullName': fullName, 'maSV': maSV, 'idLop': idLop, 'ngaySinh': ngaySinh, 'diaChi': diaChi, 'gioiTinh': gioiTinh, 'email': email, 'sdt': sdt, 'status': status};
}
