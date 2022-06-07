// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_day_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleDayItem _$ModuleDayItemFromJson(Map<String, dynamic> json) =>
    ModuleDayItem(
      enabled: json['enabled'] as bool?,
      opened: json['opened'] as bool?,
      closeAt: json['close_at'] as String?,
      openAt: json['opened_at'] as String?,
    );

Map<String, dynamic> _$ModuleDayItemToJson(ModuleDayItem instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'opened': instance.opened,
      'opened_at': instance.openAt,
      'close_at': instance.closeAt,
    };
