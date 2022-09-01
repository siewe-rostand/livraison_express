
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:provider/provider.dart';

import '../super-market/cart-provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowDialog{
  late FToast fToast;
  static showCartDialog(BuildContext context,String title,String message,String non,String oui,{
    bool? listen }){
    showDialog(
        context: context,
      builder: (BuildContext builderContext){
          return AlertDialog(
            content: Text(message),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.triangleExclamation,color: Color(0xffFFAE42),),
                const SizedBox(
                  width: 5,
                ),
                Text(title),
              ],
            ),
            actions: [
              TextButton(
                child:  Text(non),
                onPressed: (){
                  Navigator.of(builderContext).pop();
                },
              ),
              TextButton(
                child:  Text(oui),
                onPressed: (){
                },
              )
            ],
          );
      }
    );
  }

  static showValidateDialog(BuildContext context,String text){
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        backgroundColor: Colors.red,
        content:
        Text(text),
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Flexible(child: Text("Nous n'avons pas pu récupérer votre position")),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: const Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }
}