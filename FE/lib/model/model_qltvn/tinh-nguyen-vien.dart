// ignore_for_file: file_names

import 'chuc_vu.dart';
import 'lop_hoc.dart';

class TinhNguyenVien {
  int? id;
  int? role;
  String? fullName;
  String? username;
  String? password;
  String? maSV;
  int? idLop;
  LopHoc? lopHoc;
  String? ngaySinh;
  String? diaChi;
  bool? gioiTinh;
  String? email;
  String? sdt;
  String? ngayVao;
  int? idChucVu;
  ChucVu? chucVu;
  String? avatar;
  int? status;

  TinhNguyenVien({this.id, this.fullName, this.username, this.idChucVu, this.chucVu, this.password, this.maSV, this.idLop, this.lopHoc, this.ngaySinh, this.diaChi, this.gioiTinh, this.email, this.sdt, this.status});

  TinhNguyenVien.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        role = json['role'],
        fullName = json['fullName'],
        username = json['username'],
        password = json['password'],
        maSV = json['maSV'],
        idLop = json['idLop'],
        lopHoc = (json['lopHoc'] != null) ? LopHoc.fromJson(json['lopHoc']) : null,
        ngaySinh = json['ngaySinh'],
        diaChi = json['diaChi'],
        gioiTinh = json['gioiTinh'],
        email = json['email'],
        sdt = json['sdt'],
        ngayVao = json['ngayVao'],
        idChucVu = json['idChucVu'],
        chucVu =(json['chucVu']!=null)? ChucVu.fromJson(json['chucVu']):null,
        avatar = json['avatar'],
        status = json['status'];
  Map<String, dynamic> toJson() => {
        'role': role,
        'fullName': fullName,
        'username': username,
        'password': password,
        'maSV': maSV,
        'idLop': idLop,
        'ngaySinh': ngaySinh,
        'diaChi': diaChi,
        'gioiTinh': gioiTinh,
        'email': email,
        'sdt': sdt,
        'ngayVao': ngayVao,
        'avatar': avatar,
        'idChucVu': idChucVu,
        'status': status,
      };
}
