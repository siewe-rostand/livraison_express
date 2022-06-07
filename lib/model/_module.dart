import 'package:json_annotation/json_annotation.dart';

import '../constant/some-constant.dart';
import 'magasin.dart';

part '_module.g.dart';
@JsonSerializable(includeIfNull: false)
class Module {
  final int? id;
  final String? libelle;
  final String? slug;
  @JsonKey(name: ModuleConstant.heureOverture)
  final String? heureOuverture;
  @JsonKey(name: ModuleConstant.heureFermeture)
  final String? heureFermeture;
  final String? image;
  final String? moduleColor;
  @JsonKey(name: ModuleConstant.isActive)
  final int? isActive;
  @JsonKey(name: ModuleConstant.isOpen)
  final int? isOpen;
  @JsonKey(name: ModuleConstant.isActiveInCity)
  final bool? isActiveInCity;
  // final List<Magasins>? shops;
  // @JsonKey(name: ModuleConstant.availableInCity)
  // final List<String>? availableInCity;

  Module(
      {this.id,
      this.libelle,
      this.slug,
      this.heureOuverture,
      this.heureFermeture,
      this.image,
      this.moduleColor,
      this.isActive,
      this.isOpen,
      this.isActiveInCity,
      // this.shops,
      // this.availableInCity
  });

  factory Module.fromJson(Map<String,dynamic> json)=>_$ModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}