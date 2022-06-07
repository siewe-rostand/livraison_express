// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Module _$ModuleFromJson(Map<String, dynamic> json) => Module(
      id: json['id'] as int?,
      libelle: json['libelle'] as String?,
      slug: json['slug'] as String?,
      heureOuverture: json['heure_ouverture'] as String?,
      heureFermeture: json['heure_fermeture'] as String?,
      image: json['image'] as String?,
      moduleColor: json['moduleColor'] as String?,
      isActive: json['is_active'] as int?,
      isOpen: json['is_open'] as int?,
      isActiveInCity: json['is_active_in_city'] as bool?,
      // shops: (json['shops'] as List<dynamic>?)
      //     ?.map((e) => Magasins.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      // availableInCity: (json['available_in_cities'] as List<dynamic>?)
      //     ?.map((e) => e as String)
      //     .toList(),
    );

Map<String, dynamic> _$ModuleToJson(Module instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('libelle', instance.libelle);
  writeNotNull('slug', instance.slug);
  writeNotNull('heure_ouverture', instance.heureOuverture);
  writeNotNull('heure_fermeture', instance.heureFermeture);
  writeNotNull('image', instance.image);
  writeNotNull('moduleColor', instance.moduleColor);
  writeNotNull('is_active', instance.isActive);
  writeNotNull('is_open', instance.isOpen);
  writeNotNull('is_active_in_city', instance.isActiveInCity);
  // writeNotNull('shops', instance.shops);
  // writeNotNull('available_in_cities', instance.availableInCity);
  return val;
}
