import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:livraison_express/model/client.dart';
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
  const Step1({Key? key, required this.sender}) : super(key: key);
  final Client sender;

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
  AddressFavorite selectedAddressDepart = AddressFavorite();
  double? placeLatDepart,placeLonDepart;
  String? location;
  String quartierDepart = '';
  bool isMeDest = true, isChecked = false;
  List<Contact> contacts=[];
  List addresses = [];
  List<Address> addressList = [];
  int radioSelected = 1;
  String fullName = '',telephone = '',telephone1 = '',email = '';
  String? city;
  final logger =Logger();
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();

  init() async {
    city =await UserHelper.getCity();
    setState(() {
      cityDepartTextController = TextEditingController(text: city);
    });
    sender =widget.sender;
    print('city uuuu....$city');
  }

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
          phoneDepartTextController.text =telephone;
        },
        hideOnEmpty: true,
        autoFlipDirection: true,
      );
  }
  getStoredUserInfo(int value)async{
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
    var id = appUser1.providerId;
    setState(() {
      radioSelected = value;
      nomDepartTextController.text = fullName;
      phone2DepartTextController.text =
          telephone1;
      phoneDepartTextController.text =
          telephone;
      emailDepartTextController.text = email;
      // sender.id = int.parse(id);
      print("${id.runtimeType}");
      sender.providerName =radioSelected==0?
      extractedUserData['provider_name']:'livraison-express';
      senderAddress.providerName = "livraison-express";
    });
  }
  setSender(){
    var providerName="livraison-express";
    sender.fullName = nomDepartTextController.text;
    sender.telephone = phoneDepartTextController.text;
    sender.telephoneAlt = phone2DepartTextController.text;
    sender.email = emailDepartTextController.text;
    senderAddress.nom = location;
    senderAddress.quarter = quartierDepart;
    senderAddress.description = descDepartTextController.text;
    senderAddress.latitude = placeLatDepart.toString();
    senderAddress.longitude = placeLonDepart.toString();
    senderAddress.latLng =
        senderAddress.latitude! + ',' + senderAddress.longitude!;
    if(selectedAddressDepart.toString().isNotEmpty){
      senderAddress.id=selectedAddressDepart.id;
      senderAddress.providerId=selectedAddressDepart.id;
      senderAddress.providerName=selectedAddressDepart.providerName;
    }
    senderAddress.providerName="livraison-express";
    debugPrint("${sender.name} ${senderAddress.providerName}");
    List<Address> addresses = [];
    addresses.add(senderAddress);
    sender.addresses = addresses;
    logger.w(sender.toJson());
    print('///address${sender.addresses![0].toJson()}');

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
  bool isFavoriteAddress(AddressFavorite addressFavorite, Address address) {
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
    setSender();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: step1FormKey,
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
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            readOnly: radioSelected==0 && phone2DepartTextController.text.isNotEmpty,
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
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                labelText: 'Telephone 2 *'),
            controller: phone2DepartTextController,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
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
                        content: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Align(
                              child: Text(
                                ' Choisir votre adresse: ',
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              alignment: Alignment.topCenter,
                            ),
                            addresses.isEmpty
                                ? const Text(
                              ' Votre liste est vide ',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            )
                                : ListView.builder(
                                itemBuilder:
                                    (context, index) {
                                  return const Text('draw');
                                }),
                            Align(
                              alignment:
                              Alignment.bottomCenter,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty
                                          .all(Colors
                                          .white)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: const Text(
                                    'FERMER',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        Colors.black38),
                                  )),
                            )
                          ],
                        ),
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
            decoration:
            const InputDecoration(labelText: 'Ville '),
            controller: cityDepartTextController,
            enabled: false,
          ),
          TextFormField(
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                labelText: 'Description du lieu'),
            controller: descDepartTextController,
          ),
          TextFormField(
            onTap: ()async{
              MainUtils.hideKeyBoard(context);
              var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                      const MapsView()));
              setState(() {
                placeLonDepart = result['Longitude'] ?? 0.0;
                placeLatDepart = result['Latitude'] ?? 0.0;
                location = result['location'];
                print(
                    '//received from map $placeLonDepart / $placeLatDepart');
                addressDepartTextController.text = location!;
                // senderAddress.nom!=location;
              });
            },
            readOnly: true,
            decoration: const InputDecoration(
                labelText: 'Adresse geolocalisee *'),
            controller: addressDepartTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ\n"
                    "activer votre localisation et reesayer";
              } else {
                if (placeLonDepart == 0.0 ||
                    placeLatDepart == 0.0) {
                  location = "";
                  return "La valeur de ce champ est incorrecte";
                }
                return null;
              }
            },
          ),
          Visibility(
              visible: isChecked,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
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
                  senderAddress.isFavorite = true;
                  senderAddress.titre =
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
