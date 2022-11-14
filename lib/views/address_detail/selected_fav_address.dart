import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/address_services.dart';
import 'package:livraison_express/views/address_detail/address_dialog_items.dart';

import '../../model/address.dart';
import '../../utils/main_utils.dart';
import '../../utils/size_config.dart';
import '../../utils/value_helper.dart';
import 'address_dialog.dart';

enum Menu { detail, edit, delete }
class SelectedFavAddress extends StatefulWidget {
  final bool isDialog;
  final Function(Address)? onTap;
  const SelectedFavAddress({Key? key, required this.isDialog,  this.onTap}) : super(key: key);

  @override
  State<SelectedFavAddress> createState() => _SelectedFavAddressState();
}

class _SelectedFavAddressState extends State<SelectedFavAddress> {
  List<Address> fav=[];
  List address=[];

  getAddressList() async{
    await AddressService.getAddressList().then((value) {
      setState(() {
        fav= value;
        address.add(fav);
      });
    });
  }
  @override
  void initState() {
    getAddressList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MainUtils.hideKeyBoard(context);
    return widget.isDialog==false?Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black54
        ),
        title: const Text('Mes Adresses',style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
        child:FutureBuilder<List<Address>>(
          future: AddressService.getAddressList(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
               fav= snapshot.data!;
              return fav.isEmpty? Center(
                child: Text(
                  ' Votre liste est vide ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(16)),
                ),
              ) :
                ListView.builder(
                itemCount: fav.length,
                  itemBuilder: (context, index) {
                    Address address = fav[index];
                    widget.onTap!(address);
                    return item(address: address);
                  });
            }else{
              return Center(child: CircularProgressIndicator(color: UserHelper.getColor(),));
            }
          }),
        ),
    ):
    Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Align(
            child: Text(
              ' Choisir votre adresse: ',
              style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  color:
                  UserHelper.getColor()),
            ),
            alignment:
            Alignment.topCenter,
          ),
          SizedBox(
            width: double.maxFinite,
            height: SizeConfig.screenHeight!*.75,
            child:address.isEmpty? Center(child: CircularProgressIndicator(color: UserHelper.getColor(),)): fav.isEmpty
                ?  Center(
              child: Text(
                ' Votre liste est vide ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: getProportionateScreenWidth(16)),
              ),
            )
                : ListView.builder(
                itemCount: fav.length,
                shrinkWrap: true,
                itemBuilder:
                    (context, index) {
                  return TextButton(
                    onPressed: (){
                      widget.onTap!(fav[index]);
                      Navigator.of(context).pop();
                      },
                      child: AddressDialogItems(address: fav[index],isDialog: true,));
                }),
          ),
          const Spacer(),
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
    );
  }

  Widget item({required Address address,bool? isDialog}){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        elevation:isDialog==true?0:7,
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
                  Center(child: Text(address.surnom?.toUpperCase() ?? address.titre!.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800),)),
                  const SizedBox(height: 8,),
                  Text(address.quarter??''),
                ],
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(left: getProportionateScreenWidth(15)),
                child: PopupMenuButton<Menu>(
                    onSelected: (Menu item){
                      if(item.name == "edit"){
                        showGenDialog(context, false, AddressDialog(address: address,buttonText: "ENREGISTRER",readOnly: false, title: "Modifier",));
                      }
                      if(item.name == "detail"){
                        showGenDialog(context, false, AddressDialog(address: address,color: Colors.white,));
                      }
                      if(item.name =='delete'){
                        String message='Cette adresse sera définitivement supprimer';
                        errorDialog(context: context, title: "Attention!", message: message,onTap: ()async{
                          await AddressService.deleteAddress(id: address.id!).then((value) {
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
