import 'package:flutter/material.dart';

import '../../model/address.dart';
import '../../utils/main_utils.dart';
import '../MapView.dart';

class MapTextField extends StatefulWidget {
  final Address address;
  final TextEditingController? textController;
  final Function(String? value)? onSave;
  const MapTextField({Key? key, required this.address, this.textController, this.onSave}) : super(key: key);

  @override
  State<MapTextField> createState() => _MapTextFieldState();
}

class _MapTextFieldState extends State<MapTextField> {
  double? placeLon,placeLat;
  String? location;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: (value){
          widget.address.nom=value;
        },
        onTap: ()async{
          MainUtils.hideKeyBoard(context);
          var result = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                  const MapsView()));
          if (mounted) {
            setState(() {
              placeLon = result['Longitude'] ?? 0.0;
              placeLat = result['Latitude'] ?? 0.0;
              location = result['location'];

              widget.address.nom=location;
              widget.address.longitude=placeLon.toString();
              widget.address.latitude=placeLat.toString();
              widget.address.latLng=placeLat.toString()+','+placeLon.toString();
              widget.textController?.text=location!;
              // senderAddress.nom!=location;
            });
          }
        },
        readOnly: true,
        decoration: const InputDecoration(
            labelText: 'Adresse geolocalisee *'),
        controller:widget.textController,
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
    );
  }
}
