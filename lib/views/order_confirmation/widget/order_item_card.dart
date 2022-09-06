import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../constant/color-constant.dart';
import '../../../data/user_helper.dart';
import '../../../model/order_status.dart';
import '../../../model/orders.dart';
import '../../../service/course_service.dart';
import '../../../utils/size_config.dart';
import '../../../utils/value_helper.dart';
import '../../address_detail/selected_fav_address.dart';
import '../order_status_dialog.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({Key? key, required this.order, required this.saveOrder}) : super(key: key);
  final Command order;
  final Command saveOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5,right: 5),
                  height: getProportionateScreenHeight(30),
                  width: getProportionateScreenWidth(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color:UserHelper.kPrimaryColor,
                  ),
                ),
                Text(order.infos!.ref!),
                const Spacer(),
                PopupMenuButton<Menu>(
                  onSelected: (Menu item){
                    if(item.name =="detail"){
                      CourseApi().getOrderStatusHistory(orderId: order.infos?.id).then((value){
                        var body = json.decode(value.body);
                        var res = body['data'] as List;
                        List<OrderStatus> or;
                        or= res.map((e) =>OrderStatus.fromJson(e)).toList();
                        showGenDialog(context, true, OrderStatusDialog(command: order,));
                        // log("order status ${or[index].toJson()}");
                        // log("order status ${res}");
                      }).catchError((onError){
                        log("on error $onError");
                      });
                    }
                    if(item.name =='delete'){
                      String message='Cette commande sera annulée et ne sera plus présente dans cette liste.';
                      errorDialog(context: context, title: "Attention!", message: message,onTap: ()async{
                        await CourseApi.deleteOrder(id: order.infos!.id!).then((value) {
                          var body = json.decode(value.body);
                          var res = body['message'];
                          Navigator.of(context).pop();
                          showToast(context: context, text: res, iconData: Icons.check, color: Colors.green);

                        });
                      });

                    }
                  },
                  itemBuilder:(BuildContext context){
                    return <PopupMenuEntry<Menu>>[
                      buildPopupMenuItem('DETAIL', Icons.settings,Menu.detail),
                      buildPopupMenuItem('Annuler', Icons.delete,Menu.delete),
                    ];
                  },
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(4),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: getProportionateScreenWidth(30)),
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenHeight(10)),
              decoration: BoxDecoration(
                  color: kOverlay10,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(order.infos!.statutHuman!),
            ),
            SizedBox(
              height: getProportionateScreenHeight(8),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Container(decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide())
              ),),
            ),
            SizedBox(
              height: getProportionateScreenHeight(8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                      order.sender!.adresses![0].quarter??saveOrder.sender!.adresses![0].quarter!,
                      textAlign: TextAlign.center,
                    )),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[400],
                ),
                Expanded(
                    child: Text(
                      order.receiver!.adresses![0].quarter!,
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(4),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: getProportionateScreenWidth(2),),
                          Icon(Icons.calendar_today, size: getProportionateScreenWidth(12),),
                          SizedBox(width: getProportionateScreenWidth(4),),
                          Expanded(
                            child: Text(
                              order.infos!.dateLivraison!,
                              style: const TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(width: getProportionateScreenWidth(20),),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on, size: getProportionateScreenWidth(15),),
                        SizedBox(width: getProportionateScreenWidth(4),),
                        Text(
                          '${order.paiement!.montantTotal} FCFA',
                          style: TextStyle(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
