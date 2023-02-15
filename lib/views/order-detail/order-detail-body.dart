
import 'package:flutter/material.dart';
import 'package:livraison_express/model/orders.dart';
import 'package:livraison_express/views/order-detail/resume-silver-card.dart';

import '../../constant/color-constant.dart';
import '../../utils/size_config.dart';
import '../order_confirmation/widget/contact_info.dart';
import '../order_confirmation/widget/order_content.dart';

class OrderDetailBody extends StatefulWidget {
  final Command command;
  const OrderDetailBody({Key? key,required this.command}) : super(key: key);

  @override
  State<OrderDetailBody> createState() => _OrderDetailBodyState();
}

class _OrderDetailBodyState extends State<OrderDetailBody> {
  late Command _order;

  @override
  void initState() {
    _order = widget.command;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 2,
          title: Text(
            _order.infos!.ref!,
            style: TextStyle(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(color: Colors.grey[800]),
          backgroundColor: kGrey5,
        ),
        Expanded(
          child: NestedScrollView(
              headerSliverBuilder: (context, isScrolled){
                return [
                  SliverCardResume(
                    distance: _order.infos!.distanceText!,
                    price: _order.paiement!.totalAmount.toString(),
                    date: _order.infos!.dateLivraison!,
                  )
                ];
              },
              body: ScrollConfiguration(
                behavior: const ScrollBehavior()
                  ..buildViewportChrome(context, Container(), AxisDirection.down),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(20),),
                        OrderContent(_order),
                        ContactInfo('expediteur', _order.sender!),
                        ContactInfo('destinataire', _order.receiver!),
                      ],
                    ),
                  ),
                ),
              )
          ),
        )
      ],
    );
  }
}
