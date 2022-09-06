
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/color-constant.dart';
import '../../utils/size_config.dart';
import 'widget/horizontal_line.dart';
class SliverCardResume extends StatelessWidget {
  final String distance;
  final String price;
  final String date;


  SliverCardResume(this.distance, this.price, this.date);

  @override
  Widget build(BuildContext context) {
    double height = getProportionateScreenHeight(140);
    return SliverAppBar(
      toolbarHeight: 0,
      backgroundColor: kGrey5,
      pinned: true,
      floating: true,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: height,
          color: kGrey5,
          child: Stack(
            children: [
              Positioned(
                top: height * 0.497,
                bottom: height * 0.497,
                right: 0,
                left: 0,
                child: HorizontalLine(),
              ),
              Positioned(
                top:  0,
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'img/icon/svg/ic_map_route.svg',
                                  height: 30,
                                  color: primaryColor,
                                ),
                                Text(distance)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'img/icon/svg/ic_coins.svg',
                                  height: 30,
                                  color: primaryColor,
                                ),
                                Text('$price FCFA')
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'img/icon/svg/ic_time.svg',
                                  height: 30,
                                  color: primaryColor,
                                ),
                                Text(date, textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        ],
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