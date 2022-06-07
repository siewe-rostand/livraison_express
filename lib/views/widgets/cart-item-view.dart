import 'package:flutter/material.dart';
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
  const CartItemView({Key? key,required this.id,required this.title,
    required this.image,required this.quantity, required this.price}) : super(key: key);

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
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
                                  )
                              ).then((value) {
                                total =0;
                                qty=0;
                                cartProvider.removeTotalPrice(double.parse(widget.price.toString()));
                              }).onError((error, stackTrace) {
                                // print(error);
                              });
                            }
                          },
                          icon: const Icon(Icons.remove)),
                      Text(widget.quantity.toString()),
                      IconButton(
                          onPressed: () {
                            int qty =  widget.quantity ;
                            int px = widget.price;
                            qty++;
                            int? newPrice = px * widget.quantity ;
                            dbHelper!.updateQuantity(
                                CartItem(
                                  id: widget.id,
                                  quantity:qty,
                                  price:widget.price,
                                  title: widget.title,
                                  image: widget.image,
                                )
                            ).then((value) {
                              newPrice =0;
                              qty=0;
                              cartProvider.addTotalPrice(double.parse(widget.price.toString()));
                            }).onError((error, stackTrace) {
                              // print(error);
                            });
                          },
                          icon: const Icon(Icons.add)),
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
