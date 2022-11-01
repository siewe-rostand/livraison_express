
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/color-constant.dart';
class SocialCard extends StatelessWidget {
  final String icon;
  final VoidCallback press;

  const SocialCard({Key? key, required this.icon, required this.press}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
            color: kPrimaryLightBackground,
            shape: BoxShape.circle
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}