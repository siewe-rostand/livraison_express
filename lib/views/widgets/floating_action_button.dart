import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/user_helper.dart';
import '../../provider/cart-provider.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback  onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 32,
        child: badge.Badge(
          padding: const EdgeInsets.all(10),
          badgeColor: UserHelper.getColorDark(),
          animationType: badge.BadgeAnimationType.scale,
          badgeContent: Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Text(
                cart.getCounter(UserHelper.module.slug!).toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12,color: Colors.white),
              );
            },
          ),
          child: IconButton(
            onPressed:onTap,
            icon: Icon(
              Icons.shopping_cart,
              color: UserHelper.getColor(),
            ),
          ),
        ),
      ),
    );
  }
}
