

class City{
  int? id;
  String? name;
  String? latitude;
  String? longitude;
  bool? isActive;

  City({this.name,this.id,this.longitude,this.latitude,this.isActive});


  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_active'] = isActive;
    return data;
  }

}