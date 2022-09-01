
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/orders.dart';
import 'package:livraison_express/service/address_services.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/views/address_detail/map_text_field.dart';

import '../../model/address.dart';
import '../../utils/main_utils.dart';
import '../MapView.dart';

class AddressDialog extends StatefulWidget {
  const AddressDialog({Key? key, required this.address, this.buttonText, this.color, this.readOnly=true, this.title}) : super(key: key);
  final Address address;
  final String? buttonText;
  final String? title;
  final Color? color;
  final bool? readOnly;

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  TextEditingController addressTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController quarterTextController = TextEditingController();
  GlobalKey<FormState> formKey= GlobalKey<FormState>();
  double? placeLon,placeLat;
  String? location;
  @override
  void initState() {
    addressTextController=TextEditingController(text:widget.address.nom);
    descTextController=TextEditingController(text:widget.address.description);
    quarterTextController=TextEditingController(text:widget.address.quarter);
    titleTextController=TextEditingController(text:widget.address.surnom??widget.address.titre);
    super.initState();
  }

  textField({required String labelText, required TextEditingController controller, Function(String? value)? onSave, Function(String value)? onChange}){
    return TextFormField(
      readOnly: widget.readOnly!,
      onSaved: onSave,
      controller: controller,
      onChanged: onChange,
      decoration:  InputDecoration(
          label: Text(labelText)
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title:Row(
        children:  [
         Text(widget.title??'Détails',style: const TextStyle(color: primaryColor),),
        const Spacer(),
        IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
            icon: Icon(Icons.close,color: Colors.grey[12],),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        )
      ],),
      content: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.only(top: 18),
          margin: const EdgeInsets.only(top: 13,right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textField(
                  labelText: 'Titre',
                  onChange: (val)=> print(val),
                  onSave: (val)=>widget.address.titre=val,
                  controller: widget.readOnly==true?TextEditingController(text: widget.address.surnom??widget.address.titre):titleTextController),

              textField(
                  labelText: 'quartier',
                  onSave: (val)=>widget.address.quarter,
                  controller: widget.readOnly==true? TextEditingController(text: widget.address.quarter):quarterTextController),

              textField(
                  labelText: 'description',
                  onSave: (val)=>widget.address.description,
                  controller: widget.readOnly==true? TextEditingController(text: widget.address.description):descTextController),

              widget.readOnly==true?
              textField(
                  labelText: 'Adresse geolocalisee',
                  onSave: (val)=>widget.address.nom,
                  controller: widget.readOnly==true? TextEditingController(text: widget.address.nom):addressTextController)
              :
              MapTextField(address: widget.address,textController: addressTextController,),
              const SizedBox(height: 10,),
              SizedBox(
                width:double.infinity,
                height:45,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty
                            .all(widget.color)),
                    onPressed: () async {
                      if (widget.readOnly==true) {
                        Navigator.of(context)
                            .pop();
                      }else{
                        // print('${widget.address.toJson()}');
                        widget.address.surnom = titleTextController.text;
                        widget.address.nom = addressTextController.text;
                        widget.address.description = descTextController.text;
                        widget.address.quarter = quarterTextController.text;
                        await AddressService().updateAddress(address: widget.address).then((value){
                          var res = json.decode(value.body);
                          var msg =res['message'];
                          var user= res['data'];
                          showToast(context: context, text: msg, iconData: Icons.check, color: Colors.green);
                        }).catchError((onError){
                          log("message $onError");
                        });
                       Navigator.of(context)
                           .pop();
                      }
                    },
                    child:  Text(
                      widget.buttonText??'FERMER',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color:
                          Colors.black38),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
