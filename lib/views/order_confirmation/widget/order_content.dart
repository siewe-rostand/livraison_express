import 'package:flutter/material.dart';
import 'package:livraison_express/model/orders.dart';

import '../../../model/attributes.dart';
import '../../../model/product.dart';
import '../../../utils/size_config.dart';
import 'horizontal_line.dart';

class OrderContent extends StatelessWidget {
  final Command _order;

  const OrderContent(this._order,{Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: SizeConfig.screenHeight!*0.3,
            child: Text(
              'CONTENU',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(16)
              ),
            ),
          ),
        ),
        const HorizontalLine(),
        _order.orders?.module == "delivery"
            ? Text('\u2022 ${_order.infos?.contenu}')
            : Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(10),),
            Row(
              children: [
                item('Produit'),
                item('Qté'),
                item('Prix'),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(15),),
            Row(
              children: [
                item('\u2022 Livraison '),
                item('1'),
                item('${_order.orders?.montantLivraison} FCFA')
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10),),
          ],
        )
      ],
    );
  }

  item(String text){
    return Expanded(
        child: Text(
          text,
          textAlign: TextAlign.center,
        )
    );
  }

  listItem(Products p){
    return Row(
      children: [
        item(getProductName(p)),
        item(p.quantity.toString()),
        item("${p.totalPrice ?? p.prixUnitaire} FCFA"),
      ],
    );
  }

  String getProductName(Products p){
    String name = "\u2022 ${p.libelle}";

    if(p.attributes != null && p.attributes!.isNotEmpty){
      name = name + getAttributePart(p.attributes!);
    }

    return name;
  }

  String getAttributePart(List<Attributes> attributes){
    String string = "";
    int i = 1;
    for (var a in attributes) {
      if(a != null){
        int j = 1;
        a.options?.forEach((o) {
          if(o != null){
            if(o != null && o.quantity != null && o.quantity! > 0){
              string = string + o.name!;
              if(j != a.options?.length){
                string = string + ', ';
              }
            }
          }
          if(i != attributes.length && attributes.isNotEmpty){
            string = string + ', ';
          }
          j++;
        });
      }
      i++;
    }

    return string;
  }
}