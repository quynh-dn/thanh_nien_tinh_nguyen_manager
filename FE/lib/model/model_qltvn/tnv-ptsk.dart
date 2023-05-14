import 'package:haivn/model/model_qltvn/phong_trao_su_kien.dart';
import 'package:haivn/model/model_qltvn/tinh-nguyen-vien.dart';

class TnvPtsk {
  int? id;
  int? idTnv;
  TinhNguyenVien? nguoiDung;
  int? idPtsk;
  PhongTraoSuKien? phongTraoSuKien;
  int? status;

  TnvPtsk({this.id, this.idTnv, this.nguoiDung, this.status,this.idPtsk,this.phongTraoSuKien});

  TnvPtsk.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idTnv = json['idTnv'],
        nguoiDung = TinhNguyenVien.fromJson( json['nguoiDung']),
        idPtsk = json['idPtsk'],
        phongTraoSuKien= PhongTraoSuKien.fromJson(json['phongTraoSuKien']),
        status = json['status'];

  Map<String, dynamic> toJson() => {'idTnv': idTnv, 'idPtsk': idPtsk,'status': status};
}
