import 'dart:ui';

class ModuleColor {
  Color? moduleColor;
  Color? moduleColorLight;
  Color? moduleColorDark;

  ModuleColor({this.moduleColor,this.moduleColorDark,this.moduleColorLight});

  factory ModuleColor.fromJson(Map<String, dynamic> json) {
    return ModuleColor(
      moduleColor: json['moduleColor'],
      moduleColorLight: json['moduleColorLight'],
      moduleColorDark: json['moduleColorDark'],
    );
  }

  static Map<String, dynamic> toMap(ModuleColor moduleColor) => {
    'moduleColor': moduleColor.moduleColor,
    'moduleColorLight': moduleColor.moduleColorLight,
    'moduleColorDark': moduleColor.moduleColorDark,
  };

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['moduleColor'] = moduleColor;
    data['moduleColorLight'] = moduleColorLight;
    data['moduleColorDark'] = moduleColorDark;
    return data;
  }
}