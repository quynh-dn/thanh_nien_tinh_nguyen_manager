//Chủ đề
class Status {
  int? id;
  String? name;

  Status({this.id, this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
