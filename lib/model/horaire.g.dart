// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Horaire _$HoraireFromJson(Map<String, dynamic> json) => Horaire(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ModuleDays.fromJson(e as Map<String, dynamic>))
          .toList(),
      dayOfWeek: json['dayOfWeek'] as int?,
      today: json['today'] == null
          ? null
          : ModuleDays.fromJson(json['today'] as Map<String, dynamic>),
      tomorrow: json['tomorrow'] == null
          ? null
          : ModuleDays.fromJson(json['tomorrow'] as Map<String, dynamic>),
      tomorrowDayOfWeek: json['tomorrowDayOfWeek'] as int?,
    );

Map<String, dynamic> _$HoraireToJson(Horaire instance) => <String, dynamic>{
      'items': instance.items,
      'today': instance.today,
      'tomorrow': instance.tomorrow,
      'dayOfWeek': instance.dayOfWeek,
      'tomorrowDayOfWeek': instance.tomorrowDayOfWeek,
    };
