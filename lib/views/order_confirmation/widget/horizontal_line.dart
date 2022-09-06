
import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class HorizontalLine extends StatelessWidget {
  final Color color;

  const HorizontalLine({this.color = Colors.grey,Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: getProportionateScreenHeight(1),
      color: color,
    );
  }
}
