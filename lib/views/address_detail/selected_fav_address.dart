import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    await AddressService().getAddressList().then((value) {
      var body = json.decode(value.body);
      var res = body['data'] as List;
      setState(() {
        fav= res.map((e) =>Address.fromJson(e)).toList();
        address.add(fav);
      });

      // print('${res}.');
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
        child:
        address.isEmpty? Center(child: CircularProgressIndicator(color: UserHelper.getColor(),)): fav.isEmpty
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
            itemBuilder:
                (context, index) {
              return AddressDialogItems(address: fav[index]);
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
}
