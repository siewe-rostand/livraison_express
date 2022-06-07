// import 'package:json_annotation/json_annotation.dart';
// import 'package:livraison_express/constant/some-constant.dart';
//
// import 'magasin.dart';
//
// class Module {
//   final int? id;
//   final String? libelle;
//   final String? slug;
//   final String? heureOuverture;
//   final String? heureFermeture;
//   final String? image;
//   final String? moduleColor;
//   final int? isActive;
//   final int? isOpen;
//   final bool? isActiveInCity;
//   final List<Magasin>? shops;
//   final List<String>? availableInCity;
//
//   Module(
//       {this.id,
//         this.libelle,
//         this.slug,
//         this.heureOuverture,
//         this.heureFermeture,
//         this.image,
//         this.moduleColor,
//         this.isActive,
//         this.isOpen,
//         this.isActiveInCity,
//         this.shops,
//         this.availableInCity});
//
//   static Map<String, dynamic>toMap(Module module)=>{
//     ModuleConstant.id:module.id,
//     ModuleConstant.name:module.libelle,
//     ModuleConstant.isActive:module.isActive,
//     ModuleConstant.slug:module.slug,
//     ModuleConstant.heureFermeture:module.heureFermeture,
//     ModuleConstant.heureOverture:module.heureOuverture,
//     ModuleConstant.isOpen:module.isOpen,
//     ModuleConstant.isActiveInCity:module.isActiveInCity,
//     ModuleConstant.availableInCity:module.availableInCity,
//     ModuleConstant.shops:module.shops,
//   };
//
//   factory Module.fromJsom(Map<String,dynamic>json){
//     var list = json[ModuleConstant.shops] as List;
//     // print(list.runtimeType);
//     List<Magasin> shops = list.map((i) => Magasin.fromJson(i)).toList();
//     var streetsFromJson  = json[ModuleConstant.availableInCity];
//     List<String> streetsList = streetsFromJson.cast<String>();
//     // List<Magasin>.from(json[ModuleConstant.shops].map((x) => Magasin.fromJson(x)));
//     return Module(
//         id: json[ModuleConstant.id] as int,
//         libelle: json[ModuleConstant.name] as String,
//         slug: json[ModuleConstant.slug] as String,
//         heureOuverture: json[ModuleConstant.heureOverture] as String,
//         heureFermeture: json[ModuleConstant.heureFermeture] as String,
//         isActive: json[ModuleConstant.isActive] as int,
//         isOpen: json[ModuleConstant.isOpen] as int,
//         image: json[ModuleConstant.image] as String,
//         isActiveInCity: json[ModuleConstant.isActiveInCity] as bool,
//         shops:  List<Magasin>.from(json[ModuleConstant.shops].map((x) => Magasin.fromJson(x))),
//         availableInCity: streetsList
//     );
//   }
//
//
// }
// class Data{
//   Module? module;
//
//   Data({this.module});
//   factory Data.fromJson(Map<String,dynamic> json)=> Data(
//     module: Module.fromJsom(json),
//   );
// }