
import 'package:flutter/material.dart';

import '../../constant/color-constant.dart';
import '../../data/user_helper.dart';
import '../../utils/size_config.dart';

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
        required this.addQuantity,
        required this.deleteQuantity,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: getProportionateScreenHeight(30),
          width: getProportionateScreenHeight(30),
          decoration: BoxDecoration(
              color: kOverlay10,
              borderRadius:
              BorderRadius.circular(30),
              border: Border.all(
                  width: 1.5,
                  color:
                  colorFromHex(UserHelper.module.moduleColor!).withOpacity(0.2))),
          child: IconButton(onPressed: deleteQuantity, icon: const Icon(
              Icons.remove,
            size: 15,
            color: kOverlay40,
          )),
        ),
        const SizedBox(width: 5,),
        Text(text),
        const SizedBox(width: 5,),
        Container(
          height: getProportionateScreenHeight(30),
          width: getProportionateScreenHeight(30),
          decoration: BoxDecoration(
              color: kOverlay10,
              borderRadius:
              BorderRadius.circular(30),
              border: Border.all(
                  width: 1.5,
                  color:
                  colorFromHex(UserHelper.module.moduleColor!).withOpacity(0.2))),
          child: IconButton(onPressed: addQuantity, icon: const Icon(
              Icons.add,
            size: 15,
            color: kOverlay40,
          )),
        ),
      ],
    );
  }
}