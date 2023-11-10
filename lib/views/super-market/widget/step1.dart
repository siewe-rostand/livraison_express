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
import '../../../utils/string_manager.dart';

class Step1 extends StatefulWidget {
  final GlobalKey<FormState> step1FormKey;
  final Client sender;
  const Step1({Key? key, required this.step1FormKey, required this.sender})
      : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String fullName = '';
  String telephone = '';
  String telephone1 = '';
  String email = '', name = '', fname = '';
  int radioSelected = 1;
  Address senderAddress = Address();
  Address addressReceiver = Address();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController phone2DepartTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  autoComplete() {
    return TypeAheadFormField(
      getImmediateSuggestions: true,
      textFieldConfiguration: TextFieldConfiguration(
        decoration:
            const InputDecoration(labelText: StringManager.nameAndSurname),
        controller: _typeAheadController,
      ),
      suggestionsCallback: (pattern) {
        // call the function to get suggestions based on text entered
        return getContacts(pattern);
      },
      itemBuilder: (context, Contact suggestion) {
        // show suggection list
        suggestion.phones?.forEach((element) {
          telephone = element.value!;
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
          telephone = element.value!;
          widget.sender.telephone = element.value;
        });
        fname = suggestion.givenName ?? '';
        name = suggestion.familyName ?? '';
        widget.sender.fullName = suggestion.displayName;
        _typeAheadController.text = suggestion.displayName!;
        phoneTextController.text = telephone;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez entrer le nom et prénom";
        }
        return null;
      },
      onSaved: (value) => widget.sender.fullName = value,
      hideOnEmpty: true,
      autoFlipDirection: true,
    );
  }

  Future<List<Contact>> getContacts(String query) async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.granted) {
      return await ContactsService.getContacts(
          query: query, withThumbnails: false, photoHighResolution: false);
    } else {
      await Permission.contacts.request().then((value) {
        if (value == PermissionStatus.granted) {
          getContacts(query);
        }
      });
      throw Exception('error');
    }
  }

  getUserData(int? value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString("userData");
    final extractedUserData = json.decode(userString!);
    AppUser1 appUser = AppUser1.fromJson(extractedUserData);
    AppUser1? user = UserHelper.currentUser1 ?? appUser;
    email = (user.email ?? appUser.email)!;
    fullName = (user.fullname ?? appUser.fullname)!;
    telephone = (user.telephone ?? appUser.telephone)!;
    telephone1 = (user.telephoneAlt ?? appUser.telephoneAlt) ?? '';
    setState(() {
      radioSelected = value!;
      nameTextController.text = fullName;
      phone2DepartTextController.text = telephone1;
      phoneTextController.text = telephone;
      emailTextController.text = email;
      senderAddress.providerName = "livraison-express";
      widget.sender.providerName = user.providerName;
      widget.sender.fullName = nameTextController.text;
      widget.sender.telephone = telephone;
      widget.sender.telephoneAlt = telephone1;
      widget.sender.name = radioSelected == 0 ? appUser.lastname : name;
      widget.sender.surname = radioSelected == 0 ? appUser.firstname : fname;
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    phone2DepartTextController.dispose();
    emailTextController.dispose();
    _typeAheadController.dispose();
    super.dispose();
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
                  const Text(
                    'CHEZ MOI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                    activeColor: UserHelper.getColor(),
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
                  const Text(
                    'AUTRE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                    activeColor: UserHelper.getColor(),
                    value: 1,
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
                        widget.sender.providerName = 'livraison-express';
                        widget.sender.providerName = 'livraison-express';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          radioSelected == 0
              ? TextFormField(
                  controller: nameTextController,
                  onSaved: (value) => widget.sender.fullName = value,
                  readOnly:
                      radioSelected == 0 && nameTextController.text.isNotEmpty,
                  decoration:
                      const InputDecoration(labelText: 'Nom et prenom *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer le nom et prénom";
                    }
                    return null;
                  },
                )
              : autoComplete(),
          TextFormField(
            controller: phoneTextController,
            readOnly: radioSelected == 0 && phoneTextController.text.isNotEmpty,
            onSaved: (value) => widget.sender.telephone = value,
            decoration: const InputDecoration(
                labelText: '${StringManager.phoneNumber} 1 *'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le numéro de téléphone';
              }
              return null;
            },
          ),
          TextFormField(
            controller: phone2DepartTextController,
            onSaved: (value) => widget.sender.telephoneAlt = value,
            readOnly: radioSelected == 0 &&
                phone2DepartTextController.text.isNotEmpty,
            decoration: const InputDecoration(
                labelText: '${StringManager.phoneNumber} 2 '),
          ),
          TextFormField(
            controller: emailTextController,
            onSaved: (value) => widget.sender.email = value,
            readOnly: radioSelected == 0 && emailTextController.text.isNotEmpty,
            decoration: radioSelected == 0
                ? const InputDecoration(labelText: '${StringManager.email} *')
                : const InputDecoration(labelText: '${StringManager.email} '),
            validator: radioSelected == 0
                ? (value) {
                    if (value!.isEmpty) {
                      return StringManager.errorMessage;
                    }
                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
