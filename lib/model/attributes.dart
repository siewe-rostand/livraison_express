import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livraison_express/model/options.dart';

class Attributes{
  int? id;
  String? name;
  int? requiredChoiceQuota;
  List<Options>? options;

  Attributes({this.id,this.name,this.options,this.requiredChoiceQuota});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['titre'];
    requiredChoiceQuota = json['max_items'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titre'] = name;
    data['max_items'] = FontAwesomeIcons.opera;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}