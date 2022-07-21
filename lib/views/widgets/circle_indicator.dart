import 'package:flutter/material.dart';

class CircleIndicator extends Decoration{
  final Color color;
  double radius;
  CircleIndicator({required this.color,required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // TODO: implement createBoxPainter
    throw _CirclePainter(color: color, radius: radius);
  }

}

class _CirclePainter extends BoxPainter{
  final Color color;
  double radius;
  _CirclePainter({required this.color,required this.radius});



  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint=Paint();
    paint.color=color;
    paint.isAntiAlias=true;
    
    canvas.drawCircle(offset, radius, paint);
  }}