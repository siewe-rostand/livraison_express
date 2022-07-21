import 'package:flutter/material.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/utils/size_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ModuleColor moduleColor;

  const CustomButton({Key? key, required this.text, required this.moduleColor}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      margin: EdgeInsets.only(top: getProportionateScreenHeight(10)),
      decoration:  BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(185, 205, 237, 1),
            blurRadius: 6,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            // Color.fromRGBO(16, 16, 16, 1),
            // Color.fromRGBO(110, 82, 252, 1),
            // Color.fromRGBO(83, 145, 248, 1),

            moduleColor.moduleColor!,
            Color.fromRGBO(251, 194, 235, 1),
            moduleColor.moduleColor!,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}