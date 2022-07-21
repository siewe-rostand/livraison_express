import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
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
   bool listen;
   CartItemView({Key? key,required this.id,required this.title,
    required this.image,required this.quantity, required this.price, required this.listen}) : super(key: key);

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final logger = Logger();
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
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
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
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
                                setState(() {
                                  widget.listen=true;
                                });
                              }).onError((error, stackTrace) {
                                logger.e(error);
                              });
                            }
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: UserHelper.getColor()
                            ),
                              child: const Icon(Icons.remove,color: Colors.white70,)),
                      ),
                      Text(widget.quantity.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      IconButton(
                          onPressed: () {
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
                              setState(() {
                                widget.listen=true;
                              });
                              print('///');
                            }).onError((error, stackTrace) {
                              logger.e('error message',
                              error);
                            });
                          },
                          icon: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: UserHelper.getColor()
                              ),
                              child: const Icon(Icons.add,color: Colors.white70,)),
                      ),
                    ],
                  )
                  ,
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
              cartProvider.removerCounter();
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
