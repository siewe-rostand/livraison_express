import 'package:livraison_express/constant/all-constant.dart';


class AppUser1 {
  int? id;
  String? uid;
  String? uuid;
  String? providerId;
  String? providerName;
  String? email;
  String? emailMasked;
  dynamic? name;
  String? fullname;
  String? firstname;
  String? lastname;
  String? telephone;
  String? token;
  String? telephoneMasked;
  dynamic? telephoneAlt;
  dynamic? quote;
  dynamic? qualite;
  dynamic? ville;
  dynamic? description;
  dynamic? modules;
  dynamic? adresse;
  dynamic? lastLoginAt;
  dynamic? lastLoginIp;
  String? onesignalEmailAuthHash;
  dynamic? agenda;
  dynamic? cautionIncrementationCoursesDistribuable;
  List<dynamic>? magasinsIds;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  List<String>? roles;
  List<dynamic>? permissions;
  List<dynamic>? city;
  List<dynamic>? zones;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;

  static AppUser1 appUser1=AppUser1();

  AppUser1(
      {this.id,
      this.uid,
      this.uuid,
      this.providerId,
      this.providerName,
      this.email,
      this.emailMasked,
      this.name,
        this.token,
      this.fullname,
      this.firstname,
      this.lastname,
      this.telephone,
      this.telephoneMasked,
      this.telephoneAlt,
      this.quote,
      this.qualite,
      this.ville,
      this.description,
      this.modules,
      this.adresse,
      this.lastLoginAt,
      this.lastLoginIp,
      this.onesignalEmailAuthHash,
      this.agenda,
      this.cautionIncrementationCoursesDistribuable,
      this.magasinsIds,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.roles,
      this.permissions,
      this.city,
      this.zones,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  AppUser1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    uuid = json["uuid"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    email = json["email"];
    token = json["token"];
    emailMasked = json["email_masked"];
    name = json["name"];
    fullname = json["fullname"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    telephone = json["telephone"];
    telephoneMasked = json["telephone_masked"];
    telephoneAlt = json["telephone_alt"];
    quote = json["quote"];
    qualite = json["qualite"];
    ville = json["ville"];
    description = json["description"];
    modules = json["modules"];
    adresse = json["adresse"];
    lastLoginAt = json["last_login_at"];
    lastLoginIp = json["last_login_ip"];
    onesignalEmailAuthHash = json["onesignal_email_auth_hash"];
    agenda = json["agenda"];
    cautionIncrementationCoursesDistribuable =
        json["caution_incrementation_courses_distribuable"];
    magasinsIds = json["magasins_ids"] ?? [];
    emailVerifiedAt = json["email_verified_at"];
    phoneVerifiedAt = json["phone_verified_at"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    permissions = json["permissions"] ?? [];
    city = json["city"] ?? [];
    zones = json["zones"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data["uuid"] = uuid;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["email"] = email;
    data["token"] = token;
    data["email_masked"] = emailMasked;
    data["name"] = name;
    data["fullname"] = fullname;
    data["firstname"] = firstname;
    data["lastname"] = lastname;
    data["telephone"] = telephone;
    data["telephone_masked"] = telephoneMasked;
    data["telephone_alt"] = telephoneAlt;
    data["quote"] = quote;
    data["qualite"] = qualite;
    data["ville"] = ville;
    data["description"] = description;
    data["modules"] = modules;
    data["adresse"] = adresse;
    data["last_login_at"] = lastLoginAt;
    data["last_login_ip"] = lastLoginIp;
    data["onesignal_email_auth_hash"] = onesignalEmailAuthHash;
    data["agenda"] = agenda;
    data["caution_incrementation_courses_distribuable"] =
        cautionIncrementationCoursesDistribuable;
    if (magasinsIds != null) data["magasins_ids"] = magasinsIds;
    data["email_verified_at"] = emailVerifiedAt;
    data["phone_verified_at"] = phoneVerifiedAt;
    if (roles != null) data["roles"] = roles;
    if (permissions != null) data["permissions"] = permissions;
    if (city != null) data["city"] = city;
    if (zones != null) data["zones"] = zones;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}
