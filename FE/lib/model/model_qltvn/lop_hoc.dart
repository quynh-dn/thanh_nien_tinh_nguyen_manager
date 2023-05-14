class LopHoc {
  int? id;
  String? name;
  String? khoa;
  String? tenChuNhiem;
  String? sdtChuNhiem;
  String? emailChuNhiem;
  int? status;

  LopHoc({
    this.id,
    this.name,
    this.khoa,
    this.tenChuNhiem,
    this.sdtChuNhiem,
    this.emailChuNhiem,
    this.status,
  });

  LopHoc.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        khoa = json['khoa'],
        tenChuNhiem = json['tenChuNhiem'],
        sdtChuNhiem = json['sdtChuNhiem'],
        emailChuNhiem = json['emailChuNhiem'],
        status = json['status'];

  Map<String, dynamic> toJson() => {'name': name, 'khoa': khoa, 'tenChuNhiem': tenChuNhiem, 'sdtChuNhiem': sdtChuNhiem, 'emailChuNhiem': emailChuNhiem, 'status': status};
}
