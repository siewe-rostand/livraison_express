import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';
part 'module_day_item.g.dart';

@JsonSerializable(includeIfNull: true)
class ModuleDayItem{
  final bool? enabled;
  final bool? opened;
  @JsonKey(name: DayConstant.openedAt)
  final String? openAt;
  @JsonKey(name: DayConstant.closeAt)
  final String? closeAt;

  ModuleDayItem({
    this.enabled,
    this.opened,
    this.closeAt,
    this.openAt
});

  // static Map<String,dynamic> toMap(ModuleDayItem moduleDayItem)=>{
  //   DayConstant.closeAt:moduleDayItem.closeAt,
  //   DayConstant.opened:moduleDayItem.opened,
  //   DayConstant.enabled:moduleDayItem.enabled,
  //   DayConstant.openedAt:moduleDayItem.openAt
  // };
  //
  // factory ModuleDayItem.fromJson(Map<String,dynamic> json){
  //   return ModuleDayItem(
  //     openAt: json[DayConstant.openedAt],
  //     opened: json[DayConstant.opened],
  //     closeAt: json[DayConstant.closeAt],
  //     enabled: json[DayConstant.enabled],
  //   );
  // }

  factory ModuleDayItem.fromJson(Map<String,dynamic> json) =>_$ModuleDayItemFromJson(json);
  Map<String, dynamic> toJson()=>_$ModuleDayItemToJson(this);
}