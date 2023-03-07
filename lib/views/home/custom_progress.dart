import 'package:flutter/material.dart';
import 'dart:math'as math;
class CustomProgress extends StatefulWidget {
  final Widget child;
  const CustomProgress({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomProgress> createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgress> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  @override
  void initState() {
    controller=AnimationController(vsync: this,duration: const Duration(seconds: 2));
    controller.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation:controller,
        builder: (_,child){
          return Transform.rotate(
            angle: controller.value*2*math.pi,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
