import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';

import '../../data/user_helper.dart';
import '../../model/address.dart';
import '../../service/address_services.dart';
import '../../utils/size_config.dart';
import '../../utils/value_helper.dart';
import 'address_dialog.dart';

class AddressDialogItems extends StatefulWidget {
  final Address address;
  final bool? isDialog;
  const AddressDialogItems({Key? key, required this.address, this.isDialog}) : super(key: key);

  @override
  State<AddressDialogItems> createState() => _AddressDialogItemsState();
}

class _AddressDialogItemsState extends State<AddressDialogItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation: widget.isDialog==true?0:7,
        child:
        SizedBox(
          width: double.infinity,
          height: getProportionateScreenHeight(60),
          child: Row(

            children: [
              Container(
                margin:  EdgeInsets.only(right:getProportionateScreenWidth(15),left: getProportionateScreenWidth(8)),
                child: SvgPicture.asset('img/icon/svg/ic_address.svg',height: getProportionateScreenHeight(25)),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.address.surnom ?? "fav[index].titre!", style: const TextStyle(fontWeight: FontWeight.w800),),
                  const SizedBox(height: 8,),
                  Text(widget.address.quarter??''),
                ],
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(left: getProportionateScreenWidth(15)),
                child: PopupMenuButton<Menu>(
                    onSelected: (Menu item){
                      if(item.name == "edit"){
                        print(widget.address.toJson());
                        showGenDialog(context, false, AddressDialog(address: widget.address,buttonText: "ENREGISTRER",readOnly: false, title: "Modifier",));
                      }
                      if(item.name == "detail"){
                        // print(fav[index].toJson());
                        showGenDialog(context, false, AddressDialog(address: widget.address,color: Colors.white,));
                      }
                      if(item.name =='delete'){
                        String message='Cette adresse sera définitivement supprimer';
                        errorDialog(context: context, title: "Attention!", message: message,onTap: ()async{
                          await AddressService.deleteAddress(id: widget.address.id!).then((value) {
                            setState(() {});
                            var body = json.decode(value.body);
                            var res = body['message'];
                            Navigator.of(context).pop();
                            showToast(context: context, text: res, iconData: Icons.check, color: Colors.green);
                          });
                        });

                      }
                    },
                    itemBuilder:(BuildContext context){
                      return <PopupMenuEntry<Menu>>[
                        buildPopupMenuItem('Détails', Icons.settings,Menu.detail),
                        buildPopupMenuItem('Modifier', Icons.edit,Menu.edit),
                        buildPopupMenuItem('Supprimer', Icons.delete,Menu.delete),
                      ];
                    }),
              )
            ],),
        ),
      ),
    );
  }
}
