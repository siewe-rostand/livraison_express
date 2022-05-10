import 'package:livraison_express/constant/some-constant.dart';

class City{
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  bool? isActive;

  City({this.name,this.id,this.longitude,this.latitude,this.isActive});

  static Map<String, dynamic>toMap(City city)=>{
    CityConstant.id:city.id,
    CityConstant.name:city.name,
    CityConstant.latitude:city.latitude,
    CityConstant.longitude:city.longitude,
    CityConstant.isActive:city.isActive
  };

  factory City.fromJson(Map<String,dynamic> json){
    return City(
      id: json[CityConstant.id],
      name: json[CityConstant.name],
      latitude: json[CityConstant.latitude],
      longitude: json[CityConstant.longitude],
      isActive: json[CityConstant.isActive]
    );
  }

}