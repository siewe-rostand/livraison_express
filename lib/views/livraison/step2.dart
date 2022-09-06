import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:livraison_express/views/address_detail/map_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/address-favorite.dart';
import '../../model/address.dart';
import '../../model/client.dart';
import '../../model/quartier.dart';
import '../../model/user.dart';
import '../../utils/main_utils.dart';
import '../MapView.dart';
import '../address_detail/selected_fav_address.dart';

class Step2 extends StatefulWidget {
  const Step2({Key? key, required this.formKey, required this.receiverAddress, required this.receiver}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final Address receiverAddress;
  final Client receiver;

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  Client receiver = Client();
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
  AddressFavorite selectedAddressDestination = AddressFavorite();
  double? placeLatDestination,placeLonDestination;
  String? locationDestination;
  String quartierDestination = '';
  bool isLoading = false,isMeDepart = true;
  int radioSelected = 1;
  String fullName = '',telephone = '',telephone1 = '',email = '',name='',fname='';
  bool isChecked = false,isToday = false,isChecked1 = false;
  String? city;

  init() async {
    receiver =widget.receiver;
    receiverAddress =widget.receiverAddress;
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
      nomDestinationTextController.text = fullName;
      phone2DestinationTextController.text =
          telephone1;
      phoneDestinationTextController.text =
          telephone;
      emailDestinationTextController.text = email;
      receiver.name= radioSelected==0?appUser1.lastname:name;
      receiver.surname= radioSelected==0?appUser1.firstname:fname;
      // widget.sender.id=appUser1.id;
      // sender.id = int.parse(id);
      receiver.providerId =radioSelected==0?appUser1.providerId:'';
      receiver.providerName =radioSelected==0?
      extractedUserData['provider_name']:'livraison-express';
      receiverAddress.providerName = "livraison-express";
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
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: const Text("contact du destinataire",
              style: TextStyle(color: Colors.black38),),
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
          radioSelected == 0
              ? TextFormField(
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            onSaved: (val)=>receiver.fullName=val,
            readOnly: radioSelected == 0 &&
                nomDestinationTextController
                    .text.isNotEmpty,
            decoration:const InputDecoration(
                labelText: 'Nom et prenom *'),
            controller: nomDestinationTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            },
          )
              : autoComplete(),
          TextFormField(
            onSaved: (val)=>receiver.telephone=val,
            keyboardType: TextInputType.phone,
            readOnly: radioSelected == 0 &&
                phoneDestinationTextController
                    .text.isNotEmpty,
            decoration: radioSelected == 0
                ? const InputDecoration(
                labelText: 'Telephone 1 *')
                : const InputDecoration(
                labelText: 'Telephone 1'),
            controller: phoneDestinationTextController,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            validator: radioSelected == 0
                ? (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            }
                : null,
          ),
          TextFormField(
            onSaved: (val)=>receiver.telephoneAlt=val,
            readOnly: radioSelected == 0 &&
                phone2DestinationTextController
                    .text.isNotEmpty,
            keyboardType: TextInputType.phone,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                labelText: 'Telephone 2'),
            controller: phone2DestinationTextController,
          ),
          TextFormField(
            onSaved: (val)=>receiver.email=val,
            readOnly: radioSelected == 0 &&
                emailDestinationTextController
                    .text.isNotEmpty,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: radioSelected == 0
                ? const InputDecoration(labelText: 'Email *')
                : const InputDecoration(labelText: 'Email '),
            controller: emailDestinationTextController,
            validator: radioSelected == 0
                ? (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            }
                : null,
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
                        content: SelectedFavAddress(
                          isDialog: true,
                          onTap: (a) {
                            quarterDestinationTextController.text = a.quarter!;
                            addressDestinationTextController.text=a.nom??'';
                            descDestinationTextController.text=a.description??'';
                            setState(() {
                              receiverAddress.latitude=a.latitude;
                              receiverAddress.longitude=a.longitude;
                              receiverAddress.latLng=a.latLng;
                            });
                            print(a.toJson());;
                          },
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
            onSaved: (val)=>receiverAddress.ville=val,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration:
            const InputDecoration(labelText: 'Ville '),
            controller: cityDestinationTextController,
            enabled: false,
          ),
          TypeAheadFormField<String>(
            textFieldConfiguration:  TextFieldConfiguration(
              controller: quarterDestinationTextController,
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
              quarterDestinationTextController.text = suggestion;
            },
            onSaved: (value)=>widget.receiverAddress.quarter=value,
            autoFlipDirection: true,
            hideOnEmpty: true,
          ),
          TextFormField(
            onSaved: (val)=>receiverAddress.description=val,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
                labelText: 'Description du lieu '),
            controller: descDestinationTextController,
          ),
          MapTextField(address: receiverAddress,textController: addressDestinationTextController,),
          Visibility(
              visible: isChecked,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    onSaved: (val){
                      receiverAddress.titre=val;
                      receiverAddress.surnom=val;
                    },
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
                receiverAddress.isFavorite = true;
                receiverAddress.titre =
                    titleDestinationTextController.text;
              });
              print(isChecked);
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }
}