import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
   Color? backgroundColor;
   Color? progressColor;
   double? progress;
   double? size;
  // final Widget child;

   CustomContainer({
    Key? key,
    required this.backgroundColor,
    required this.progressColor,
    required this.progress,
    required this.size,
    // required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Stack(
        children: [
          Container(
            color: backgroundColor,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size! * progress!,
              color: progressColor,
              // child: child,
            ),
          ),
        ],
      ),
    );
  }
}