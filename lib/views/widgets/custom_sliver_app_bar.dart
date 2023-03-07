
import 'package:flutter/material.dart';

import '../../constant/color-constant.dart';
import '../../data/user_helper.dart';
import '../../utils/size_config.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  const CustomSliverAppBar({Key? key,required this.title}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 0,
      backgroundColor: kGrey5,
      pinned: true,
      floating: true,
      expandedHeight: getProportionateScreenHeight(90),
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          height: getProportionateScreenHeight(90),
          child: Stack(
            children: [
              Container(
                height: getProportionateScreenHeight(45),
                color: colorFromHex(UserHelper.module.moduleColor!),
              ),
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                      child: Center(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kSecondaryColor.withOpacity(0.9),
                              fontSize: getProportionateScreenWidth(20),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}