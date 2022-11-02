import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/widgets/plus-minus-button.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../model/cart-model.dart';
import '../super-market/cart-provider.dart';
import '../../data/local_db/db-helper.dart';

class CartItemView extends StatefulWidget {
  final int id;
  final int quantity;
  final int price;
  final String image;
  final String title;
  const CartItemView(
      {Key? key,
      required this.id,
      required this.title,
      required this.image,
      required this.quantity,
      required this.price})
      : super(key: key);

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final logger = Logger();
  DBHelper1? dbHelper = DBHelper1();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return  Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: 90,
                height: 90,
                color: Colors.white38,
                child: SizedBox(
                    height: 85,
                    child:Image.network(widget.image)),
              ),
              flex: 2,
            ),
            // Padding(padding: EdgeInsets.all(4)),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( widget.title),
                  PlusMinusButtons(
                      addQuantity:  () {
                        int qty =  widget.quantity ;
                        int px = widget.price;
                        qty++;
                        int? newPrice = px * qty;
                        dbHelper!.updateQuantity(
                            CartItem(
                                id: widget.id,
                                quantity:qty,
                                price:newPrice,
                                title: widget.title,
                                image: widget.image,
                                unitPrice: widget.price
                            )
                        ).then((value) {
                          newPrice =0;
                          qty=0;
                          cartProvider.addTotalPrice(double.parse(widget.price.toString()));

                          print('///');
                        }).onError((error, stackTrace) {
                          logger.e('error message',
                              error);
                        });
                      },
                      deleteQuantity:  () {
                        int qty = widget.quantity;
                        int px = widget.price;
                        qty--;
                        int total = qty*px;
                        if(qty>0){
                          dbHelper!.updateQuantity(
                              CartItem(
                                  id: widget.id,
                                  quantity:qty,
                                  price: widget.price,
                                  title:widget.title,
                                  image: widget.image,
                                  totalPrice: total
                              )
                          ).then((value) {
                            total =0;
                            qty=0;
                            print('-----');
                            cartProvider.removeTotalPrice(double.parse(widget.price.toString()));

                          }).onError((error, stackTrace) {
                            logger.e(error);
                          });
                        }
                      },
                      text: widget.quantity.toString()),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(widget.price.toString() +
                          ' FCFA',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child:IconButton(
            onPressed: () async{
              print(widget.id);
              dbHelper!.delete(widget.id);
              cartProvider.removeTotalPrice(widget.price.toDouble());
              cartProvider.removeCounter();
            },
            icon: const Icon(Icons.delete_rounded),
          ),

        ),
        const Divider(
          thickness: 1.5,
        ),
      ],
    );
  }
}
/*
ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blueGrey.shade200,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                              height: 80,
                              width: 80,
                              image:
                              NetworkImage(provider.cart[index].image),
                            ),
                            SizedBox(
                              width: 130,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text:
                                              '${provider.cart[index].title!}\n',
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Price: ' r"$",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text:
                                              '${provider.cart[index].unitPrice!}\n',
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder<int>(
                                valueListenable:
                                provider.cart[index].quantity!,
                                builder: (context, val, child) {
                                  return PlusMinusButtons(
                                    addQuantity: () {
                                      cartProvider.addQuantity(
                                          provider.cart[index].id!);
                                      dbHelper!
                                          .updateQuantity(CartItem1(
                                        id: index,
                                        quantity:
                                        ValueNotifier(provider.cart[index].quantity!.value),
                                        price: provider.cart[index].unitPrice,
                                        title: provider.cart[index].title,
                                        image: provider.cart[index].image,
                                      ))
                                          .then((value) {
                                        setState(() {
                                          cartProvider.addTotalPrice(double.parse(
                                              provider
                                                  .cart[index].unitPrice
                                                  .toString()));
                                        });
                                      });
                                    },
                                    deleteQuantity: () {
                                      cartProvider.deleteQuantity(
                                          provider.cart[index].id!);
                                      cartProvider.removeTotalPrice(double.parse(
                                          provider.cart[index].unitPrice
                                              .toString()));
                                    },
                                    text: val.toString(),
                                  );
                                }),
                            IconButton(
                                onPressed: () {
                                  dbHelper!.deleteCartItem(
                                      provider.cart[index].id!);
                                  provider
                                      .removeItem(provider.cart[index].id!);
                                  provider.removeCounter();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade800,
                                )),
                          ],
                        ),
                      ),
                    );
                  })
 */