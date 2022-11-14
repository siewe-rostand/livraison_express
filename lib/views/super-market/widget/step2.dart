
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:livraison_express/views/address_detail/map_text_field.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';
import 'package:provider/provider.dart';

import '../../../data/user_helper.dart';
import '../../../model/address.dart';
import '../../../model/quartier.dart';

class Step2 extends StatefulWidget {
  final GlobalKey<FormState> step2FormKey;
  final Address addressReceiver;
  const Step2({Key? key, required this.step2FormKey, required this.addressReceiver}) : super(key: key);

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
  Adresse selectedFavouriteAddress = Adresse();
  String? city;
  List addresses = [];
  List<Adresse> fav=[];
  double? placeLat;
  double? placeLon;
  String? location;
  String quartier="";
  bool isChecked = false;

  initView()async{
    city =await UserHelper.getCity();
    cityDepartTextController = TextEditingController(text: city);
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
    initView();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Form(
      key: widget.step2FormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Consulter ma liste d'adresses: "),
              IconButton(
                  onPressed: () async{
                    showDialog<void>(
                        context: context,
                        builder: (context) {
                          return  AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: SelectedFavAddress(isDialog: true,onTap: (s){
                              quartier=s.quarter ?? quartier;
                              quarterTextController.text=quartier;
                              addressTextController.text=s.nom??'';
                              descTextController.text=s.description??'';
                              setState(() {
                                widget.addressReceiver.latitude=s.latitude;
                                widget.addressReceiver.longitude=s.longitude;
                                widget.addressReceiver.latLng=s.latLng;
                              });
                              },),
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
            onSaved: (value)=>widget.addressReceiver.nom=value,
          ),
          TypeAheadFormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            onSaved: (value)=>widget.addressReceiver.quarter=value,
            validator: (value) {
              List<String> douala = city=='Douala'|| city == "DOUALA"? quarter.quarterDouala:quarter.quarterYaounde;
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              if (!(douala.contains(value))) {
                return "Veuillez Choisir une ville svp";
              }
              return null;
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
            onSaved: (value)=>widget.addressReceiver.description=value,
            validator: (value) {
              if (value!.isEmpty) {
                return "Veuillez remplir ce champ";
              }
              return null;
            },
          ),
          MapTextField(address: widget.addressReceiver,textController: addressTextController,),
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
                    onSaved: (value)=>widget.addressReceiver.titre=value,
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
                  widget.addressReceiver.isFavorite = true;
                  widget.addressReceiver.titre =
                      titleTextController.text;
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          )
        ],
      ),
    );
  }
}
