

import 'package:flutter/material.dart';

import '../views/address_detail/selected_fav_address.dart';

PopupMenuItem<Menu> buildPopupMenuItem(
    String title, IconData iconData, Menu position) {
  return PopupMenuItem<Menu>(
    value: position,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
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