import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/user_helper.dart';
import '../super-market/cart-provider.dart';
import '../cart/cart.dart';

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
        child: Badge(
          padding: const EdgeInsets.all(10),
          badgeColor: UserHelper.getColorDark(),
          animationType: BadgeAnimationType.scale,
          badgeContent: Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Text(
                cart.getCounter().toString(),
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
