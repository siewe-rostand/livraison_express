

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/color-constant.dart';
import '../../model/orders.dart';
import '../../utils/size_config.dart';
import 'widget/horizontal_line.dart';
class SliverCardResume extends StatelessWidget {
   final Command command;
  const SliverCardResume({Key? key, required this.command,}):super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = getProportionateScreenHeight(140);
    command.paiement!.datePayment = null;
    String mode = command.paiement!.datePayment == null? " (Non Payée)": " (Payée)";
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
                child: const HorizontalLine(),
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
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
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
                                    Text(command.infos!.distanceText!)
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
                                    Text('${command.paiement!.totalAmount!} FCFA')
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
                                    Text(command.infos!.dateLivraison!, textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Paiement: '),
                              Text(command.paiement!.paymentMode == 'cash'? "A la livraison $mode" : "Carte bancaire $mode",
                                style: TextStyle(color: command.paiement!.datePayment == null? primaryRed:primaryGreenDark),)
                            ],
                          )
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