import 'package:livraison_express/model/address.dart';


class Client{
   int? id;
   String? fullName;
   String? name;
   String? surname;
   String? email;
   String? telephone;
   String? username;
   String? telephoneAlt;
   String? noteInterne;
   String? providerId;
   String? providerName;
   String? dateCreation;
   String? dateModification;
   List<Address>? addresses;

   static Client client=Client();

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
    this.username,
    this.telephoneAlt,
    this.dateCreation,
    this.dateModification,
    this.addresses
});
   Client.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     fullName = json['fullname'];
     surname = json['surname'];
     username = json['username'];
     email = json['email'];
     name = json['name'];
     noteInterne = json['note_interne'];
     telephone = json['telephone'];
     telephoneAlt = json['telephone_alt'];
     dateCreation = json["date_creation"];
     dateModification = json["date_modification"];
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
     data["date_creation"] = dateCreation;
     data["date_modification"] = dateModification;
     data['provider_id'] = providerId;
     data['provider_name'] = providerName;
     if (addresses != null) {
       data['adresses'] = addresses!.map((v) => v.toJson()).toList();
     }
     return data;
   }

}
