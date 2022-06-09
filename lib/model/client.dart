import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';
import 'package:livraison_express/model/address.dart';


class Client{
   String? id;
   String? fullName;
   String? name;
   String? surname;
   String? email;
   String? telephone;
   String? telephoneAlt;
   String? noteInterne;
   String? providerId;
   String? providerName;
   List<Address>? addresses;

  Client({
    this.id,
    this.name,
    this.providerId,
    this.providerName,
    this.email,
    this.fullName,
    this.telephone,
    this.noteInterne,
    this.surname,
    this.telephoneAlt,
    this.addresses
});

  static Map<String,dynamic> toMap(Client client)=>{
    ClientConstant.id:client.id,
    ClientConstant.fullName:client.fullName,
    ClientConstant.name:client.name,
    ClientConstant.surname:client.surname,
    ClientConstant.telephone:client.telephone,
    ClientConstant.telephoneAlt:client.telephoneAlt,
    ClientConstant.email:client.email,
    ClientConstant.noteIterne:client.noteInterne,
    ClientConstant.addresses:client.addresses,
  };

   Client.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     fullName = json['fullname'];
     surname = json['surname'];
     email = json['email'];
     name = json['name'];
     noteInterne = json['note_interne'];
     telephone = json['telephone'];
     telephoneAlt = json['telephone_alt'];
     providerId = json['provider_id'];
     providerName = json['provider_name'];
     if (json['adresses'] != null) {
       addresses = <Address>[];
       json['adresses'].forEach((v) {
         addresses!.add(Address.fromJson(v));
       });
     }
   }
   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['id'] = id;
     data['fullname'] = fullName;
     data['name'] = name;
     data['surname'] = surname;
     data['email'] = email;
     data['telephone'] = telephone;
     data['telephone_alt'] = telephoneAlt;
     data['provider_id'] = providerId;
     data['provider_name'] = providerName;
     if (addresses != null) {
       data['adresses'] = addresses!.map((v) => v.toJson()).toList();
     }
     return data;
   }

}
