class Poster {
  int? id;
  String? name;
  String? fileName;
  int? stt;
  int? status;

  Poster({this.id, this.name, this.fileName, this.stt, this.status});

  Poster.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        fileName = json['fileName'],
        stt = json['stt'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'fileName': fileName,
        'stt': stt,
        'status': status,
      };
}
