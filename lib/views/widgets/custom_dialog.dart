
import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/utils/size_config.dart';

class CustomDialog extends StatelessWidget {
  final String title, content, positiveBtnText;
  final String? negativeBtnText;
  final IconData? iconData;
  final GestureTapCallback positiveBtnPressed;
  final GestureTapCallback? negativeBtnPressed;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.positiveBtnText,
     this.negativeBtnText='',
    required this.positiveBtnPressed,
    this.iconData=Icons.message, this.negativeBtnPressed,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }
  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(  // Bottom rectangular box
          margin: EdgeInsets.only(top: getProportionateScreenHeight(40)), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20), // spacing inside the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: getProportionateScreenHeight(16),
              ),
              Text(
                content,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              ButtonBar(
                buttonMinWidth: getProportionateScreenWidth(100),
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    child: Text(negativeBtnText!,style: TextStyle(color: UserHelper.getColor()),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(positiveBtnText,style: TextStyle(color: UserHelper.getColor()),),
                    onPressed: positiveBtnPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
         CircleAvatar( // Top Circle with icon
          maxRadius: 40.0,
          child: Icon(iconData,color: UserHelper.getColor().withBlue(79),),
           backgroundColor: Colors.grey.withOpacity(0.89),
        ),
      ],
    );
  }
}