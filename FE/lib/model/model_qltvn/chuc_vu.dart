class ChucVu {
  int? id;
  String? name;
  int? level;
  int? status;

  ChucVu({this.id, this.name, this.level, this.status});

  ChucVu.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        level = json['level'],
        status = json['status'];

  Map<String, dynamic> toJson() => {'name': name, 'level': level,'status': status};
}
