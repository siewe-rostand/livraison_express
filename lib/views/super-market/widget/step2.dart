import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../data/user_helper.dart';
import '../../../model/address-favorite.dart';
import '../../../model/address.dart';
import '../../../model/quartier.dart';
import '../../../utils/main_utils.dart';
import '../../MapView.dart';

class Step2 extends StatefulWidget {
  const Step2({Key? key}) : super(key: key);

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  TextEditingController addressTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController cityDepartTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController quarterTextController = TextEditingController();
  Address senderAddress = Address();
  AddressFavorite selectedAddressDepart = AddressFavorite();
  String? city;
  List addresses = [];
  double? placeLat;
  double? placeLon;
  String? location;
  bool isChecked = false;

  initView()async{
    city =await UserHelper.getCity();
    cityDepartTextController = TextEditingController(text: city);;
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
    initView();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Consulter ma liste d'adresses: "),
            IconButton(
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            content: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Align(
                                  child: Text(
                                    ' Choisir votre adresse: ',
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        Color(0xff00a117)),
                                  ),
                                  alignment:
                                  Alignment.topCenter,
                                ),
                                addresses.isEmpty
                                    ? const Text(
                                  ' Votre liste est vide ',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold),
                                )
                                    : ListView.builder(
                                    itemBuilder:
                                        (context, index) {
                                      return const Text(
                                          'draw');
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
                icon: SvgPicture.asset('img/icon/svg/ic_address.svg'))
          ],
        ),

        TextFormField(
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          decoration:
          const InputDecoration(labelText: 'Ville '),
          controller: cityDepartTextController,
          enabled: false,
        ),
        TypeAheadField<String>(
          textFieldConfiguration:  TextFieldConfiguration(
            controller: quarterTextController,
            decoration: const InputDecoration(
                labelText: 'Quartier'),
          ),
          suggestionsCallback: (String pattern) async {
            return city=='Douala'|| city == "DOUALA"?quarter.quarterDouala
                .where((item) =>
                item.toLowerCase().startsWith(pattern.toLowerCase()))
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
          autoFlipDirection: true,
          hideOnEmpty: true,
        ),
        TextFormField(
          autovalidateMode:
          AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
              labelText: 'Description du lieu '),
          controller: descTextController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Veuillez remplir ce champ";
            }
            return null;
          },
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: ()async{
            MainUtils.hideKeyBoard(context);
            var result = await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                    const MapsView()));
            setState(() {
              placeLon = result['Longitude'] ?? 0.0;
              placeLat = result['Latitude'] ?? 0.0;
              location = result['location'];
              print(
                  '//received from map $placeLon / $placeLat');
              addressTextController.text = location!;
              // senderAddress.nom!=location;
            });
          },
          readOnly: true,
          decoration: const InputDecoration(
              labelText: 'Adresse geolocalisee *'),
          controller: addressTextController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Veuillez remplir ce champ\n"
                  "activer votre localisation et reesayer";
            } else {
              if (placeLon == 0.0 ||
                  placeLat == 0.0) {
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
                  controller: titleTextController,
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
                    titleTextController.text;
              }
            });
            print(isFavoriteAddress(selectedAddressDepart, senderAddress));
          },
          controlAffinity: ListTileControlAffinity.leading,
        )
      ],
    );
  }
}
