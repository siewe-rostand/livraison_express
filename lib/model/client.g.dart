// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clients _$ClientsFromJson(Map<String, dynamic> json) => Clients(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      fullName: json['fullname'] as String?,
      telephone: json['telephone'] as String?,
      noteInterne: json['note_interne'] as String?,
      surname: json['surname'] as String?,
      telephoneAlt: json['telephone_alt'] as String?,
      addresses: (json['adressess'] as List<dynamic>?)
          ?.map((e) => Addresses.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClientsToJson(Clients instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullName,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'telephone': instance.telephone,
      'telephone_alt': instance.telephoneAlt,
      'note_interne': instance.noteInterne,
      'adressess': instance.addresses,
    };
