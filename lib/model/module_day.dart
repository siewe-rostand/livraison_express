import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';
import 'package:livraison_express/model/module_day_item.dart';

part 'module_day.g.dart';

@JsonSerializable(includeIfNull: true)
class ModuleDays{
  final List<ModuleDayItem>? items;
  final bool? opened;
  final bool? enabled;

  ModuleDays({
    this.enabled,
    this.opened,
    this.items,
});

  // static Map<String,dynamic> toMap(ModuleDays moduleDays)=>{
  //   DayConstant.opened:moduleDays.opened,
  //   DayConstant.enabled:moduleDays.enabled,
  //   DayConstant.items:moduleDays.items
  // };
  //
  // factory ModuleDays.fromJson(Map<String,dynamic> json){
  //   var list = json[DayConstant.items] as List;
  //   print(list.runtimeType);
  //   List<ModuleDayItem> moduleDayItem = list.map((i) => ModuleDayItem.fromJson(i)).toList();
  //   return ModuleDays(
  //     opened: json[DayConstant.opened],
  //     enabled: json[DayConstant.enabled],
  //     items: moduleDayItem
  //   );
  // }

  factory ModuleDays.fromJson(Map<String,dynamic> json) =>_$ModuleDaysFromJson(json);
  Map<String, dynamic> toJson()=>_$ModuleDaysToJson(this);
}