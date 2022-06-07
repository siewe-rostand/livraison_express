// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleDays _$ModuleDaysFromJson(Map<String, dynamic> json) => ModuleDays(
      enabled: json['enabled'] as bool?,
      opened: json['opened'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ModuleDayItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModuleDaysToJson(ModuleDays instance) =>
    <String, dynamic>{
      'items': instance.items,
      'opened': instance.opened,
      'enabled': instance.enabled,
    };
