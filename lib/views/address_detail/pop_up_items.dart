import 'package:flutter/material.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';


class PopupItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Menu position;
  const PopupItem({Key? key, required this.title, required this.iconData, required this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<Menu>(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }
}
