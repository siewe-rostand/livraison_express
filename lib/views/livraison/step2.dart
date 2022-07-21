import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/address-favorite.dart';
import '../../model/address.dart';
import '../../model/client.dart';
import '../../model/quartier.dart';
import '../MapView.dart';

class Step2 extends StatefulWidget {
  const Step2({Key? key}) : super(key: key);

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  Client receiver = Client();
  Client sender = Client();
  TextEditingController quarterDestinationTextController =
  TextEditingController();
  TextEditingController nomDestinationTextController = TextEditingController();
  TextEditingController phoneDestinationTextController =
  TextEditingController();
  TextEditingController phone2DestinationTextController =
  TextEditingController();
  TextEditingController emailDestinationTextController =
  TextEditingController();
  TextEditingController addressDestinationTextController =
  TextEditingController();
  TextEditingController descDestinationTextController = TextEditingController();
  TextEditingController cityDestinationTextController = TextEditingController();
  TextEditingController titleDestinationTextController =
  TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  Address receiverAddress = Address();
  Address senderAddress = Address();
  AddressFavorite selectedAddressDestination = AddressFavorite();
  double? placeLatDestination,placeLonDestination;
  String? locationDestination;
  String quartierDestination = '';
  bool isLoading = false,isMeDepart = true;
  int radioSelected2 = 1;
  String fullName = '',telephone = '',telephone1 = '',email = '';
  bool isChecked = false,isToday = false,isChecked1 = false;
  List addresses = [];
  String? city;

  init() async {
    city =await UserHelper.getCity();
    setState(() {
      cityDestinationTextController = TextEditingController(text: city);
    });
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
          phoneDestinationTextController.text =telephone;
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
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("contact de l'expediteur"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 0,
              groupValue: radioSelected2,
              onChanged: (int? value) async {
                SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
                String? userString =
                sharedPreferences.getString("userData");
                final extractedUserData =
                json.decode(userString!);
                email = extractedUserData['email'];
                fullName = extractedUserData['fullname'];
                telephone = extractedUserData['telephone'];
                telephone1 =
                extractedUserData['telephone_alt'];
                var id = extractedUserData['provider_id'];
                setState(() {
                  radioSelected2 = value!;
                  nomDestinationTextController.text =
                      fullName;
                  phone2DestinationTextController.text =
                      telephone1;
                  phoneDestinationTextController.text =
                      telephone;
                  emailDestinationTextController.text =
                      email;
                  receiver.id = id;
                  // print(sender.id);
                  receiver.providerName =
                  extractedUserData['provider_name'];
                });
              },
            ),
            const Text('Moi'),
            Radio(
              value: 1,
              groupValue: radioSelected2,
              onChanged: (int? value) {
                fullName = '';
                email = '';
                telephone1 = '';
                telephone = '';
                setState(() {
                  radioSelected2 = value!;
                  nomDestinationTextController.text =
                      fullName;
                  phone2DestinationTextController.text =
                      telephone1;
                  phoneDestinationTextController.text =
                      telephone;
                  emailDestinationTextController.text =
                      email;
                  sender.id = null;
                  sender.providerName = 'livraison-express';
                });
              },
            ),
            const Text('Autre'),
          ],
        ),
        radioSelected2==0? TextFormField(
          decoration: const InputDecoration(
              labelText: 'Nom et prenom *'),
          controller: nomDestinationTextController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Veuillez remplir ce champ";
            }
            return null;
          },
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
        ):
        autoComplete(),
        TextFormField(
          enabled: radioSelected2==0?false:true,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              labelText: 'Telephone 1 *'),
          controller: phoneDestinationTextController,
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
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
          controller: phone2DestinationTextController,
        ),
        TextFormField(
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          decoration:
          const InputDecoration(labelText: 'Email *'),
          controller: emailDestinationTextController,
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
          controller: cityDestinationTextController,
          enabled: false,
        ),
        TextFormField(
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
              labelText: 'Description du lieu *'),
          controller: descDestinationTextController,
        ),
        GestureDetector(
          onTap: () async {
            var result = await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                    const MapsView()));
            setState(() {
              placeLonDestination = result['Longitude'];
              placeLatDestination = result['Latitude'];
              locationDestination = result['location'];
              print(
                  '//received from map $placeLonDestination / $placeLatDestination');
              addressDestinationTextController.text =
              locationDestination!;
              // senderAddress.nom!=location;
            });
          },
          child: TextFormField(
            enabled: false,
            decoration: const InputDecoration(
                labelText: 'Adresse geolocalisee *'),
            controller: addressDestinationTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            },
          ),
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
                  controller:
                  titleDestinationTextController,
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
              senderAddress.isFavorite = true;
              senderAddress.titre =
                  titleDestinationTextController.text;
            });
            print(isChecked);
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        isLoading == true
            ? const CircularProgressIndicator()
            : Container(),
      ],
    );
  }
}
