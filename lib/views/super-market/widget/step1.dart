import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:livraison_express/model/client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/user_helper.dart';
import '../../../model/address.dart';
import '../../../model/user.dart';
class Step1 extends StatefulWidget {
  final GlobalKey<FormState> step1FormKey;
  const Step1({Key? key, required this.step1FormKey}) : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String fullName = '';
  String telephone = '';
  String telephone1 = '';
  String email = '';
  int radioSelected = 1;
  Client senderClient = Client();
  Address senderAddress = Address();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController phone2DepartTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  String? city;


  autoComplete(){
    return
      TypeAheadField(
        getImmediateSuggestions: true,
        textFieldConfiguration:  TextFieldConfiguration(
          decoration: const InputDecoration(labelText: 'Nom et prenom *'),
          controller: _typeAheadController,
        ),
        suggestionsCallback: (pattern) {
          // call the function to get suggestions based on text entered
          return getContacts(pattern);
        },
        itemBuilder: (context,Contact suggestion) {
          // show suggection list
          suggestion.phones?.forEach((element) {
            telephone=element.value!;
          });
          return ListTile(
            title: Text(suggestion.displayName!),
            subtitle: Text(
              telephone,
            ),
          );
        },
        onSuggestionSelected: (Contact suggestion) {
          suggestion.phones?.forEach((element) {
            telephone=element.value!;
          });
          _typeAheadController.text=suggestion.displayName!;
          phoneTextController.text =telephone;
        },
        hideOnEmpty: true,
        autoFlipDirection: true,
      );
  }
  Future<List<Contact>> getContacts(String query) async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final PermissionStatus permission = await Permission.contacts.status;
    if(permission == PermissionStatus.granted) {
      return await ContactsService.getContacts(query: query,
          withThumbnails: false,photoHighResolution: false
      );
    }else{
      await Permission.contacts.request().then((value) {
        if(value==PermissionStatus.granted){
          getContacts(query);
        }
      });
      throw Exception('error');
    }
  }
  getUserData(int? value)async{
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userString =
    sharedPreferences.getString("userData");
    final extractedUserData =
    json.decode(userString!);
    AppUser1 appUser = AppUser1.fromJson(extractedUserData);
    AppUser1? user=UserHelper.currentUser1??appUser;
    email =(user.email??appUser.email)!;
    fullName =(user.fullname??appUser.fullname)!;
    telephone =(user.telephone??appUser.telephone)!;
    telephone1 =(user.telephoneAlt??appUser.telephoneAlt)??'';
    setState(() {
      radioSelected = value!;
      nameTextController.text = fullName;
      phone2DepartTextController.text = telephone1;
      phoneTextController.text = telephone;
      emailTextController.text = email;
      senderClient.providerName=user.providerName;
      senderAddress.providerName =
      "livraison-express";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.step1FormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('CHEZ MOI',style: TextStyle(fontWeight: FontWeight.bold),),
                  Radio(
                    activeColor:UserHelper.getColor(),
                    value: 0,
                    groupValue: radioSelected,
                    onChanged: (int? value) {
                      getUserData(value);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('AUTRE',style: TextStyle(fontWeight: FontWeight.bold),),
                  Radio(
                    activeColor: UserHelper.getColor(),
                    value:1,
                    groupValue: radioSelected,
                    onChanged: (int? value) {
                      fullName = '';
                      email = '';
                      telephone1 = '';
                      telephone = '';
                      setState(() {
                        radioSelected = value!;
                        nameTextController.text = fullName;
                        phone2DepartTextController.text = telephone1;
                        phoneTextController.text = telephone;
                        emailTextController.text = email;
                        // sender.id = null;
                        senderClient.providerName =
                        'livraison-express';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          radioSelected == 0?TextFormField(
            controller: nameTextController,
            readOnly: radioSelected==0 && nameTextController.text.isNotEmpty,
            decoration: const InputDecoration(
                labelText: 'Nom et prenom *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer le nom et prénom";
              }
              return null;
            },
          ):
          autoComplete(),
          TextFormField(
            controller: phoneTextController,
            readOnly: radioSelected==0 && phoneTextController.text.isNotEmpty,
            decoration:
            const InputDecoration(labelText: 'Telephone 1 *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le numéro de téléphone';
              }
              return null;
            },
          ),
          TextFormField(
            controller: phone2DepartTextController,
            readOnly: radioSelected==0 && phone2DepartTextController.text.isNotEmpty,
            decoration:
            const InputDecoration(labelText: 'Telephone 2 '),
          ),
          TextFormField(
            controller: emailTextController,
            readOnly: radioSelected==0 && emailTextController.text.isNotEmpty,
            decoration:radioSelected==0?
            const InputDecoration(labelText: 'Email *'):const InputDecoration(labelText: 'Email '),
            validator:radioSelected==0? (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            }:null,
          ),
        ],
      ),
    );
  }
}
