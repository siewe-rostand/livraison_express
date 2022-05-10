import 'package:livraison_express/constant/all-constant.dart';

class AppUser {
  int? id;
  final String? providerId;
  final String? providerName;
  final String? username;
  final String? email;
  final String? telephone;
  final String? fullName;
  final String? firstname;
  final String? lastname;
  final String? token;
  final String? fcmToken;
  final String? uuid;
  final String? image;
  final String? rememberToken;
  final List? roles;

  AppUser({
    this.image,
    this.rememberToken,
    this.roles,
    this.providerId,
    this.providerName,
    this.username,
    this.email,
    this.telephone,
    this.fullName,
    this.firstname,
    this.lastname,
    this.token,
    this.fcmToken,
    this.uuid,
    this.id,
  });

  static Map<String, dynamic> toMap(AppUser user) => {
    UserConstant.id: user.id,
    UserConstant.username: user.username,
    UserConstant.image: user.image,
    UserConstant.firstname: user.firstname,
    UserConstant.fullName: user.fullName,
    UserConstant.lastname:user.lastname,
    UserConstant.providerId:user.providerId,
    UserConstant.providerName:user.providerName,
    UserConstant.email:user.email,
    UserConstant.telephone:user.telephone,
    UserConstant.roles:user.roles,
    UserConstant.token:user.token,
    UserConstant.fcmToken:user.fcmToken,
    UserConstant.uuid:user.uuid,
    UserConstant.rememberToken:user.rememberToken
  };

  factory AppUser.fromJson(Map<String,dynamic>json){
    return AppUser(
      id: json[UserConstant.id],
      providerId: json[UserConstant.providerId],
      providerName: json[UserConstant.providerName],
      username: json[UserConstant.username],
      firstname: json[UserConstant.firstname],
      fullName: json[UserConstant.fullName],
      lastname: json[UserConstant.lastname],
      image: json[UserConstant.image],
      email: json[UserConstant.email],
      telephone: json[UserConstant.telephone],
      token: json[UserConstant.token],
      fcmToken: json[UserConstant.fcmToken],
      roles: json[UserConstant.roles],
      rememberToken: json[UserConstant.rememberToken],
      uuid: json[UserConstant.uuid],
    );
  }

}
