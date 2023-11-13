
class AppUser1 {
  int? id;
  String? uid;
  String? uuid;
  String? providerId;
  String? providerName;
  String? email;
  String? emailMasked;
  String? fullname;
  String? firstname;
  String? lastname;
  String? telephone;
  String? token;
  String? telephoneAlt;
  String? onesignalEmailAuthHash;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  List<String>? roles;
  String? createdAt;
  String? updatedAt;

  static AppUser1 appUser1 = AppUser1();

  AppUser1({
    this.id,
    this.uid,
    this.uuid,
    this.providerId,
    this.providerName,
    this.email,
    this.emailMasked,
    this.token,
    this.fullname,
    this.firstname,
    this.lastname,
    this.telephone,
    this.telephoneAlt,
    this.onesignalEmailAuthHash,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.roles,
    this.createdAt,
    this.updatedAt,
  });

  AppUser1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    uid = json["uid"];
    uuid = json["uuid"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    email = json["email"];
    token = json["token"];
    emailMasked = json["email_masked"];
    fullname = json["fullname"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    telephone = json["telephone"];
    telephoneAlt = json["telephone_alt"];
    onesignalEmailAuthHash = json["onesignal_email_auth_hash"];
    emailVerifiedAt = json["email_verified_at"];
    phoneVerifiedAt = json["phone_verified_at"];
    roles = json["roles"] == null ? null : List<String>.from(json["roles"]);
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
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
    data["fullname"] = fullname;
    data["firstname"] = firstname;
    data["lastname"] = lastname;
    data["telephone"] = telephone;
    data["telephone_alt"] = telephoneAlt;
    data["onesignal_email_auth_hash"] = onesignalEmailAuthHash;
    data["email_verified_at"] = emailVerifiedAt;
    data["phone_verified_at"] = phoneVerifiedAt;
    if (roles != null) data["roles"] = roles;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
