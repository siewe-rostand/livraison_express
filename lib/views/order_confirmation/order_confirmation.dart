
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livraison_express/utils/size_config.dart';

import '../../model/orders.dart';
import 'command_history.dart';
class OrderConfirmation extends StatelessWidget {
  final String order;
  const OrderConfirmation({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight!*0.35,
              width: SizeConfig.screenWidth!*0.7,
              child: SvgPicture.asset("img/icon/svg/ic_done_white.svg",color: Colors.green),
            ),
            const SizedBox(height: 10,),
            const Center(child: Text("Commande enregistrée avec succès")),
            const SizedBox(height: 10,),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:  [
                  const Text('N° commande'),
                  const SizedBox(width: 10,),
                  Text(order,style: const TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const CommandLists()));
            }, child: const Text('Consulter mes commandes'))
          ],
        ),
      ) ,
    );
  }
}
