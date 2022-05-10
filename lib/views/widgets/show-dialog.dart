
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../super-market/cart-provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowDialog extends ChangeNotifier{
  static showCartDialog(BuildContext context,String title,String message,String non,String oui){
    showDialog(
        context: context,
      builder: (BuildContext builderContext){
        final cartProvider = Provider.of<CartProvider>(context,listen: false);
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
                  cartProvider.clear();
                  Navigator.of(builderContext).pop();
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
}