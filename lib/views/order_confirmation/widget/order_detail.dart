import 'package:flutter/material.dart';
import 'package:livraison_express/model/orders.dart';

import '../../../constant/color-constant.dart';
import '../../../utils/size_config.dart';
import '../silver_card_resume.dart';
import 'contact_info.dart';
import 'order_content.dart';

class OrderDetailScreen extends StatefulWidget {
  final Command order;

  const OrderDetailScreen(this.order,{Key? key}):super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ScrollController _controller = ScrollController();
  late Command _order;

  @override
  void initState() {
    _order = widget.order;
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryColorDark,
      ),
      body: Column(
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
                        _order.infos!.distanceText!,
                        _order.paiement!.montantTotal!.toString(),
                        _order.infos!.dateLivraison!
                    )
                  ];
                },
                body: ScrollConfiguration(
                  behavior: const ScrollBehavior()
                    ..buildOverscrollIndicator(
                        context,
                        Stack(),
                        ScrollableDetails(
                            direction: AxisDirection.down,
                            controller: _controller)),
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
      ),
    );
  }
}