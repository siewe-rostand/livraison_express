

class Image{
  int? id;
  String? sm;
  String? md;
  String? lg;

  Image({this.id, this.sm, this.md, this.lg});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sm = json['sm'];
    md = json['md'];
    lg = json['lg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sm'] = sm;
    data['md'] = md;
    data['lg'] = lg;
    return data;
  }
}