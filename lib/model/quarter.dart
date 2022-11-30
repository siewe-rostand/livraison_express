
class Quarter{
  int? id;
  int? cityId;
  int? zoneId;
  String? name;
  String? city;
  String? createdAt;
  String? updatedAt;
  String? isActive;

  Quarter({this.name,this.id,this.createdAt,this.updatedAt,this.isActive,this.city,this.cityId,this.zoneId});


  Quarter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['libelle'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    isActive = json['is_active'];
    cityId = json['city_id'];
    city = json['ville'];
    zoneId = json['zone_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = name;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['is_active'] = isActive;
    data['ville'] = city;
    data['city_id'] = cityId;
    data['zone_id'] = zoneId;
    return data;
  }
}