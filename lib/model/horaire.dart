import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';

import 'day.dart';
import 'module_day.dart';
part 'horaire.g.dart';

class Horaires {
  List<Days>? items;
  Days? today;
  Days? tomorrow;
  int? dayOfWeek;
  int? tomorrowDayOfWeek;
  String? readme;

  Horaires(
      {this.items,
        this.today,
        this.tomorrow,
        this.dayOfWeek,
        this.tomorrowDayOfWeek,
        this.readme});

  Horaires.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Days>[];
      json['items'].forEach((v) {
        items!.add(Days.fromJson(v));
      });
    }
    today = json['today'] != null ? Days.fromJson(json['today']) : null;
    tomorrow =
    json['tomorrow'] != null ? Days.fromJson(json['tomorrow']) : null;
    dayOfWeek = json['dayOfWeek'];
    tomorrowDayOfWeek = json['tomorrowDayOfWeek'];
    readme = json['readme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (today != null) {
      data['today'] = today!.toJson();
    }
    if (tomorrow != null) {
      data['tomorrow'] = tomorrow!.toJson();
    }
    data['dayOfWeek'] = dayOfWeek;
    data['tomorrowDayOfWeek'] = tomorrowDayOfWeek;
    data['readme'] = readme;
    return data;
  }
}

@JsonSerializable(includeIfNull: true)
class Horaire{
  final List<ModuleDays>? items;
  final ModuleDays? today;
  final ModuleDays? tomorrow;
  final int? dayOfWeek;
  final int? tomorrowDayOfWeek;

  Horaire({
    this.items,
    this.dayOfWeek,
    this.today,
    this.tomorrow,
    this.tomorrowDayOfWeek
});

  factory Horaire.fromJson(Map<String,dynamic> json) =>_$HoraireFromJson(json);
  Map<String, dynamic> toJson()=>_$HoraireToJson(this);
}