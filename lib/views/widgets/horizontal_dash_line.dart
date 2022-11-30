
import 'package:flutter/material.dart';

class HorizontalDashLine extends StatelessWidget {
  const HorizontalDashLine({Key? key, required this.height, required this.color}) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint){
          final boxWidth = constraint.constrainWidth();
          const dashWith = 10.0;
          final dashHeight = height;
          final dashCount = (boxWidth / (2*dashWith)).floor();
          return Flex(
              direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_){
              return SizedBox(
                width: dashWith,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          );
        }
    );
  }
}
