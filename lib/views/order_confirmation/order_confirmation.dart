
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
import 'package:livraison_express/utils/size_config.dart';

import 'command_history.dart';
class OrderConfirmation extends StatelessWidget {
  const OrderConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight!*0.35,
              width: SizeConfig.screenWidth!*0.7,
              decoration:  BoxDecoration(
                border: Border.all(),
                image: const DecorationImage(
                  image: provider.Svg("img/icon/svg/ic_done_white.svg",color: Colors.green)
                )
              ),
            ),
            const SizedBox(height: 10,),
            const Center(child: Text("Commande enregistrée avec succès")),
            const SizedBox(height: 10,),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('N° commande'),
                  SizedBox(width: 10,),
                  Text('1111111111111111111111',style: TextStyle(fontWeight: FontWeight.bold),),
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
