import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/order.dart';
import 'package:livraison_express/model/order_status.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/views/home/home-page.dart';
import 'package:livraison_express/views/order_confirmation/order_status_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color-constant.dart';
import '../../model/orders.dart';
import '../../utils/size_config.dart';
import '../../utils/value_helper.dart';
import '../address_detail/selected_fav_address.dart';

class CommandLists extends StatefulWidget {
  const CommandLists({Key? key}) : super(key: key);

  @override
  State<CommandLists> createState() => _CommandListsState();
}

class _CommandListsState extends State<CommandLists> {
  List<Command> command=[];
  List orders=[];
  late SharedPreferences prefs;


  getCourse() async{
    prefs =await SharedPreferences.getInstance();
    await CourseApi.getOrders().
    then((value) {
      if (mounted) {
        setState(() {
          command=value;
          var order=json.encode(command);
          orders.add(command);
          prefs.setString("orders", order);
        });
      }
      // print('${res}.');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getCourse();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes',style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
            color: Colors.black54
        ),
      ),
      body:
          orders.isEmpty?const Center(child: CircularProgressIndicator()):command.isEmpty?
           Center(
            child:  Text(
              "Vous n'avez encore aucune\ncommande.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(16)),
            ),
          ):
          ListView.builder(
              itemCount: command.length,
              itemBuilder: (context, index) {
                String? or= prefs.getString('orders');
                final decOrder= json.decode(or!) as List;
                List<Command> saveOrder=decOrder.map((e) => Command.fromJson(e)).toList();
                      Command commands =command[index];
                Command order =command[index];
                // String? quarter=saveOrder[index].sender?.adresses![0].quarter;
                // print(" ;;;${saveOrder[index].infos?.id}");
                log('... ${order.toJson()}');
                return Card(
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
                                    setState(() {

                                    });
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
                                "order.sender!.adresses![0].quarter??quarter!",
                                textAlign: TextAlign.center,
                              )),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.grey[400],
                          ),
                          Expanded(
                              child: Text(
                                order.receiver!.adresses![0].quartier!,
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
                                    style: TextStyle(

                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              })
    );
  }
}
