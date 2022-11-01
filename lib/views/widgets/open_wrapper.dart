import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    Key? key,
    required this.closedBuilder,
    this.transitionType,
    this.onClosed,
    required this.nextPage
  }): super(key: key);

  final Widget Function(BuildContext, void Function()) closedBuilder;
  final ContainerTransitionType? transitionType;
  final void Function(Never?)? onClosed;
  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Colors.transparent,
      closedElevation: 0.0,
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: transitionType??ContainerTransitionType.fade,
      closedBuilder: closedBuilder ,/** this is the initial widget  of the page */
      openBuilder: (context, re){
        return nextPage;
      },/** this is the widget that is shown when the initial widget has been clicked  */
      onClosed: onClosed,
      tappable: false,
    );
  }
}
class OpenContainerWrapper1 extends StatelessWidget {
  const OpenContainerWrapper1({
    Key? key,
    required this.closedBuilder,
    this.transitionType,
    required this.onClosed,
    required this.nextPage, this.routeSettings
  }): super(key: key);

  final Widget Function(BuildContext, void Function()) closedBuilder;
  final ContainerTransitionType? transitionType;
  final void Function(Never?)? onClosed;
  final Widget nextPage;
  final RouteSettings? routeSettings;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 4.0,
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: transitionType??ContainerTransitionType.fade,
      closedBuilder: closedBuilder ,/** this is the initial widget  of the page */
      openBuilder: (context, _){
        return nextPage;
      },/** this is the widget that is shown when the initial widget has been clicked  */
      onClosed: onClosed,
      tappable: false,
      routeSettings: routeSettings,
    );
  }
}

class InkWellOverlay extends StatelessWidget {
  const InkWellOverlay({
    Key? key,
    required this.onTap,
    this.width,
    this.height,
    this.child,
  }):super(key: key);

  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}