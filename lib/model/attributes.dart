import 'package:livraison_express/constant/some-constant.dart';
import 'package:livraison_express/model/options.dart';

class Attributes{
  int? id;
  String? name;
  int? requiredChoiceQuota;
  List<Options>? options;
  Attributes({this.id,this.name,this.options,this.requiredChoiceQuota});

  static Map<String, dynamic> toMap(Attributes attribute) => {
    AttributeConstant.id: attribute.id,
    AttributeConstant.name: attribute.name,
    AttributeConstant.requiredChoiceQuota: attribute.requiredChoiceQuota,
  };

  factory Attributes.fromJson(Map<String, dynamic> json) {
    var list = json['options'] as List;
    print(list.runtimeType);
    List<Options> options = list.map((i) => Options.fromJson(i)).toList();
    return Attributes(
      id: json[AttributeConstant.id],
      name: json[AttributeConstant.name] ,
      options: options,
      requiredChoiceQuota: json[AttributeConstant.requiredChoiceQuota]
    );
  }
}