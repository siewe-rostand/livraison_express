import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';
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
/*
class Contact {
  int? id;
  String? holderId;
  String? creatorId;
  String? updaterId;
  Null? adresseFavoriteId;
  String? uuid;
  String? username;
  String? avatar;
  String? fullname;
  String? firstname;
  String? lastname;
  String? email;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? telephone;
  String? telephoneAlt;
  String? genre;
  String? providerId;
  String? providerName;
  Null? langue;
  String? description;
  String? modules;
  String? token;
  Null? fcmToken;
  Null? cautionIncrementationCoursesDistribuable;
  int? statut;
  bool? isGuest;
  int? type;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Null? lastLoginAt;
  Null? lastLoginIp;
  Null? stripeId;
  Null? cardBrand;
  Null? cardLastFour;
  Null? trialEndsAt;

  Contact(
      {this.id,
        this.holderId,
        this.creatorId,
        this.updaterId,
        this.adresseFavoriteId,
        this.uuid,
        this.username,
        this.avatar,
        this.fullname,
        this.firstname,
        this.lastname,
        this.email,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.telephone,
        this.telephoneAlt,
        this.genre,
        this.providerId,
        this.providerName,
        this.langue,
        this.description,
        this.modules,
        this.token,
        this.fcmToken,
        this.cautionIncrementationCoursesDistribuable,
        this.statut,
        this.isGuest,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.lastLoginAt,
        this.lastLoginIp,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holderId = json['holder_id'];
    creatorId = json['creator_id'];
    updaterId = json['updater_id'];
    adresseFavoriteId = json['adresse_favorite_id'];
    uuid = json['uuid'];
    username = json['username'];
    avatar = json['avatar'];
    fullname = json['fullname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    telephone = json['telephone'];
    telephoneAlt = json['telephone_alt'];
    genre = json['genre'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    langue = json['langue'];
    description = json['description'];
    modules = json['modules'];
    token = json['token'];
    fcmToken = json['fcm_token'];
    cautionIncrementationCoursesDistribuable =
    json['caution_incrementation_courses_distribuable'];
    statut = json['statut'];
    isGuest = json['is_guest'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    lastLoginAt = json['last_login_at'];
    lastLoginIp = json['last_login_ip'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['holder_id'] = holderId;
    data['creator_id'] = creatorId;
    data['updater_id'] = updaterId;
    data['adresse_favorite_id'] = adresseFavoriteId;
    data['uuid'] = uuid;
    data['username'] = username;
    data['avatar'] = avatar;
    data['fullname'] = fullname;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['telephone'] = telephone;
    data['telephone_alt'] = telephoneAlt;
    data['genre'] = genre;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['langue'] = langue;
    data['description'] = description;
    data['modules'] = modules;
    data['token'] = token;
    data['fcm_token'] = fcmToken;
    data['caution_incrementation_courses_distribuable'] =
        cautionIncrementationCoursesDistribuable;
    data['statut'] = statut;
    data['is_guest'] = isGuest;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['last_login_at'] = lastLoginAt;
    data['last_login_ip'] = lastLoginIp;
    data['stripe_id'] = stripeId;
    data['card_brand'] = cardBrand;
    data['card_last_four'] = cardLastFour;
    data['trial_ends_at'] = trialEndsAt;
    return data;
  }
}

 */
