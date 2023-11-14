import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/widgets/plus-minus-button.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../model/cart-model.dart';
import '../../provider/cart-provider.dart';
import '../../data/local_db/db-helper.dart';

class CartItemView extends StatefulWidget {
  final CartItem cartItem;
  const CartItemView({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItemView> createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  final logger = Logger();
  DBHelper? dbHelper = DBHelper();
  int? newPrice;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: getProportionateScreenWidth(90),
                height: getProportionateScreenHeight(90),
                color: Colors.white38,
                child: SizedBox(
                    height: getProportionateScreenHeight(85),
                    child: Image.network(
                      widget.cartItem.image,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'img/no-images.jpeg',
                          height: getProportionateScreenHeight(70),
                        );
                      },
                    )),
              ),
              flex: 2,
            ),
            const SizedBox(
              width: 10,
            ),
            // Padding(padding: EdgeInsets.all(4)),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cartItem.title!),
                  PlusMinusButtons(
                      addQuantity: () {
                        int qty = widget.cartItem.quantity!;
                        int px = widget.cartItem.price!;
                        qty++;
                        newPrice = px * qty;
                        // dbHelper!
                        //     .updateQuantity(CartItem(
                        //   id: widget.cartItem.id,
                        //   quantity: qty,
                        //   price: newPrice,
                        //   title: widget.cartItem.title,
                        //   image: widget.cartItem.image,
                        //   unitPrice: widget.cartItem.price,
                        //   productId: widget.cartItem.productId,
                        //   moduleSlug: UserHelper.module.slug,
                        // ))
                        //     .then((value) {
                        //   cartProvider.addTotalPrice(
                        //       double.parse(widget.cartItem.price.toString()));
                        // }).onError((error, stackTrace) {
                        //   logger.e('error message', error);
                        // });
                        CartItem cart = widget.cartItem.copyWith(quantity: qty,totalPrice: newPrice);
                        cartProvider.updateQuantity(cart);
                      },
                      deleteQuantity: () {
                        int qty = widget.cartItem.quantity!;
                        int px = widget.cartItem.price!;
                        qty--;
                        newPrice = px * qty;
                        int total = qty * px;
                        if (qty > 0) {
                          // dbHelper!
                          //     .updateQuantity(
                          //   CartItem(
                          //     id: widget.cartItem.id,
                          //     quantity: qty,
                          //     price: newPrice,
                          //     title: widget.cartItem.title,
                          //     image: widget.cartItem.image,
                          //     totalPrice: total,
                          //     unitPrice: widget.cartItem.price,
                          //     productId: widget.cartItem.productId,
                          //     moduleSlug: UserHelper.module.slug,
                          //   ),
                          // )
                          //     .then((value) {
                          //       logger.i(value);
                          //   cartProvider.removeTotalPrice(
                          //       double.parse(widget.cartItem.price.toString()));
                          // }).onError((error, stackTrace) {
                          //   logger.e(error);
                          // });
                          CartItem cart = widget.cartItem.copyWith(quantity: qty,totalPrice: newPrice);
                          cartProvider.updateQuantity(cart).then((value){
                            logger.w(value.toJson());
                          }).catchError((onError){
                            logger.e(onError);
                          });
                        }
                      },
                      text: widget.cartItem.quantity.toString()),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.cartItem.unitPrice.toString() + ' FCFA',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            onPressed: () async {
              logger.i(widget.cartItem.toJson());
              dbHelper!
                  .delete(widget.cartItem.productId!, UserHelper.module.slug!);
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
