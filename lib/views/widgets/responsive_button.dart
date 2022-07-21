import 'package:flutter/material.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/utils/size_config.dart';

class ResponsiveButton extends StatelessWidget {
  final double? width;
  final bool? isResponsive;
  const ResponsiveButton({Key? key, this.width, this.isResponsive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: getProportionateScreenHeight(60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: redDark
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("img/button-one.png"),
        ],
      ),
    );
  }
}
