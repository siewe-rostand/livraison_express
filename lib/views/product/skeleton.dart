
import 'package:flutter/material.dart';
class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height,width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
          color: Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
    );
  }
}
