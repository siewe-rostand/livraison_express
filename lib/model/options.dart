import 'package:livraison_express/constant/some-constant.dart';

class Options{
  int? id;
  String? name;
  int? price;
  int? quantity;
  Options({this.id,this.name,this.price,this.quantity});

  static Map<String, dynamic> toMap(Options options) => {
    OptionsConstant.id: options.id,
    OptionsConstant.name: options.name,
    OptionsConstant.quantity: options.quantity,
    OptionsConstant.price: options.price
  };

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      id: json[OptionsConstant.id],
      name: json[OptionsConstant.name],
      price: json[OptionsConstant.price],
      quantity: json[OptionsConstant.quantity],
    );
  }
}