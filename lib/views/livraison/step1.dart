import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/views/address_detail/map_text_field.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/address-favorite.dart';
import '../../model/address.dart';
import '../../model/quartier.dart';
import '../../model/user.dart';
import '../../utils/main_utils.dart';
import '../MapView.dart';

class Step1 extends StatefulWidget {
  const Step1({Key? key, required this.sender, required this.addressSender, required this.step1FormKey}) : super(key: key);
  final Client sender;
  final Address addressSender;
  final GlobalKey<FormState> step1FormKey;

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {

  Client sender = Client();
  TextEditingController quarterTextController = TextEditingController();
  TextEditingController nomDepartTextController = TextEditingController();
  TextEditingController phoneDepartTextController = TextEditingController();
  TextEditingController phone2DepartTextController = TextEditingController();
  TextEditingController emailDepartTextController = TextEditingController();
  TextEditingController addressDepartTextController = TextEditingController();
  TextEditingController descDepartTextController = TextEditingController();
  TextEditingController cityDepartTextController = TextEditingController();
  TextEditingController titleDepartTextController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  Address senderAddress = Address();
  Adresse selectedAddressDepart = Adresse();
  double? placeLatDepart,placeLonDepart;
  String? location;
  String quartierDepart = '';
  bool isMeDest = true, isChecked = false;
  List<Contact> contacts=[];
  List addresses = [];
  List<Address> addressList = [];
  int radioSelected = 1;
  String fullName = '',telephone = '',telephone1 = '',email = '',name='',fname='';
  String? city;
  final logger =Logger();
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();

  init() async {
    city =await UserHelper.getCity();
    setState(() {
      cityDepartTextController = TextEditingController(text: city);
    });
    sender =widget.sender;
  }

  autoComplete(){
    return
      TypeAheadFormField(
        getImmediateSuggestions: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            widget.sender.telephone=element.value;
          });
          widget.sender.fullName=suggestion.displayName;
          fname=suggestion.givenName??'';
          name=suggestion.familyName??'';
          _typeAheadController.text=suggestion.displayName!;
          phoneDepartTextController.text =telephone;
        },
        hideOnEmpty: true,
        autoFlipDirection: true,
        validator: (value) {
          if (value!.isEmpty) {
            return "Veuillez remplir ce champ";
          }
          return null;
        },
      );
  }
  getStoredUserInfo(int value)async{
    radioSelected = value;
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userString =
    sharedPreferences.getString("userData");
    final extractedUserData =
    json.decode(userString!);
    AppUser1 user1=AppUser1.fromJson(extractedUserData);
    AppUser1? appUser1 = UserHelper.currentUser1??user1;
    email =radioSelected==0? appUser1.email!:'';
    fullName =radioSelected==0? appUser1.fullname!:'';
    telephone = radioSelected==0?appUser1.telephone!:'';
    telephone1 =radioSelected==0?appUser1.telephoneAlt??'':'';
    print('${appUser1.providerId}');
    setState(() {
      nomDepartTextController.text = fullName;
      phone2DepartTextController.text =
          telephone1;
      phoneDepartTextController.text =
          telephone;
      emailDepartTextController.text = email;
      widget.sender.name= radioSelected==0?appUser1.lastname:name;
      widget.sender.surname= radioSelected==0?appUser1.firstname:fname;
      // widget.sender.id=appUser1.id;
      // sender.id = int.parse(id);
      widget.sender.providerId =radioSelected==0?appUser1.providerId:'';
      widget.sender.providerName =radioSelected==0?
      extractedUserData['provider_name']:'livraison-express';
      widget.addressSender.providerName = "livraison-express";
      logger.d(widget.addressSender.toJson());
      logger.d(widget.sender.toJson());
    });
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
  bool isFavoriteAddress(Adresse addressFavorite, Address address) {
    if (addressFavorite.toString().isEmpty) {
      return false;
    }
    return addressFavorite.quartier == address.quarter &&
        addressFavorite.description == address.description &&
        addressFavorite.latitude == address.latitude &&
        addressFavorite.longitude == address.longitude &&
        addressFavorite.nom == address.address;

  }
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Form(
      key: widget.step1FormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: const Text(
              "Contact de l'expediteur",
              style: TextStyle(color: Colors.black38),
            ),
            alignment: Alignment.topLeft,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 0,
                groupValue: radioSelected,
                onChanged: (int? value) {
                  getStoredUserInfo(value!);
                },
              ),
              const Text('Moi'),
              Radio(
                value: 1,
                groupValue: radioSelected,
                onChanged: (int? value) {
                 getStoredUserInfo(value!);
                },
              ),
              const Text('Autre'),
            ],
          ),
          radioSelected==0? TextFormField(
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            onSaved: (value)=>widget.sender.fullName=value,
            readOnly: radioSelected==0 && nomDepartTextController.text.isNotEmpty,
            decoration: const InputDecoration(
                labelText: 'Nom et prenom *'),
            controller: nomDepartTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            },
          ):
          autoComplete(),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (value)=>widget.sender.telephone=value,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            readOnly: radioSelected==0 && phoneDepartTextController.text.isNotEmpty,
            decoration: const InputDecoration(
                labelText: 'Telephone 1 *'),
            controller: phoneDepartTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (value)=>widget.sender.telephoneAlt=value,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                labelText: 'Telephone 2 *'),
            controller: phone2DepartTextController,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (value)=>widget.sender.email=value,
            readOnly: radioSelected==0 && emailDepartTextController.text.isNotEmpty,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration:radioSelected==0?
            const InputDecoration(labelText: 'Email *'):const InputDecoration(labelText: 'Email '),
            controller: emailDepartTextController,
            validator:radioSelected==0? (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            }:null,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Adresse de l'expediteur",
                style: TextStyle(color: Colors.black38),
              )),
          InkWell(
            onTap: () {
              showDialog<void>(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        content: SelectedFavAddress(isDialog: true,onTap: (a){
                          quarterTextController.text=a.quarter!;
                          addressDepartTextController.text=a.nom??'';
                          descDepartTextController.text=a.description??'';
                          setState(() {
                            widget.addressSender.latitude=a.latitude;
                            widget.addressSender.longitude=a.longitude;
                            widget.addressSender.latLng=a.latLng;
                          });
                          print(a.toJson());;
                        },),
                      ),
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Consulter ma liste d'adresses: "),
                // Image.asset('img/icon/address.png',height: 24,width: 24,)
                SvgPicture.asset(
                  'img/icon/svg/ic_address.svg',
                  height: 24,
                  width: 24,
                )
              ],
            ),
          ),
          TextFormField(
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            onSaved: (value)=>widget.addressSender.ville=value,
            decoration:
            const InputDecoration(labelText: 'Ville '),
            controller: cityDepartTextController,
            enabled: false,
          ),
          TypeAheadFormField<String>(
            textFieldConfiguration:  TextFieldConfiguration(
              controller: quarterTextController,
              decoration: const InputDecoration(
                  labelText: 'Quartier'),
            ),
            suggestionsCallback: (String pattern) async {
              if(pattern.isEmpty){
                return const Iterable<String>.empty();
              }
              return city=='Douala'|| city == "DOUALA"? quarter.quarterDouala
                  .where((String quarter) => quarter
                  .toLowerCase().split(' ').any((word) =>word.startsWith(pattern
                  .toLowerCase()) )
              )
                  .toList():quarter.quarterYaounde
                  .where((item) =>
                  item.toLowerCase().startsWith(pattern.toLowerCase()))
                  .toList();
            },
            itemBuilder: (context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) {
              quarterTextController.text = suggestion;
            },
            onSaved: (value)=>widget.addressSender.quarter=value,
            autoFlipDirection: true,
            hideOnEmpty: true,
          ),
          TextFormField(
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            onSaved: (value)=>widget.addressSender.description=value,
            decoration: const InputDecoration(
                labelText: 'Description du lieu'),
            controller: descDepartTextController,
          ),
          MapTextField(address: widget.addressSender,textController: addressDepartTextController,),
          Visibility(
              visible: isChecked,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    onSaved: (value){
                      widget.addressSender.titre=value;
                      widget.addressSender.surnom=value;
                    },
                    decoration: const InputDecoration(
                        hintText: "Titre d'adresse *"),
                    controller: titleDepartTextController,
                    validator: (value) {
                      if (isChecked == true) {
                        if (value!.isEmpty) {
                          return "Veuillez remplir ce champ";
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Ex: Maison, Bureau',
                        style:
                        TextStyle(color: Colors.black26),
                      )),
                ],
              )),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            checkColor: Colors.white,
            activeColor: Colors.black,
            title: const Text('Enregistrer cette adresse'),
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
                if (isChecked==true) {
                  widget.addressSender.isFavorite = true;
                  widget.addressSender.titre =
                      titleDepartTextController.text;
                }
              });
              print(isFavoriteAddress(selectedAddressDepart, senderAddress));
            },
            controlAffinity: ListTileControlAffinity.leading,
          )
        ],
      ),
    );
  }
}
