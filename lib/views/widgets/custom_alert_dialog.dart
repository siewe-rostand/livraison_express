import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/user_helper.dart';
import '../../utils/size_config.dart';

class CustomAlertDialog extends StatelessWidget {
  final String svgIcon;
  final String title;
  final String message;
  final String negativeText;
  final String positiveText;
  final bool dismissible;
  final double? height;
  final double? width;
  final Function()? onCancel;
  final Function() onContinue;


  const CustomAlertDialog({Key? key,
    required this.svgIcon,
    required this.title,
    required this.message,
    this.dismissible = true,
    this.negativeText = "Annuler",
    this.positiveText = "Continuer",
    this.onCancel,
    this.height,
    this.width,
    required this.onContinue,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => dismissible,
      child: Dialog(
        elevation: 10,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          height: height ?? SizeConfig.screenHeight! * 0.5,
          width: width??SizeConfig.screenWidth! * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SvgPicture.asset(
                          svgIcon,
                        ),
                      ),
                    )
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: UserHelper.getColorDark(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(25),
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10),),
                          Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: onCancel != null,
                                child: TextButton(
                                    onPressed: onCancel,
                                    child: Text(
                                      negativeText,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontWeight: FontWeight.w600
                                      ),
                                    )
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white)
                                ),
                                onPressed: onContinue,
                                child: Text(
                                  positiveText,
                                  style: TextStyle(
                                      color: UserHelper.getColor(),
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
