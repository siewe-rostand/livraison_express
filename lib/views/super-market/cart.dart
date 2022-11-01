

import 'package:flutter/material.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:livraison_express/views/super-market/valider-panier.dart';
import 'package:livraison_express/views/widgets/cart-item-view.dart';
import 'package:livraison_express/views/widgets/reusable-widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../data/user_helper.dart';
import '../../model/cart-model.dart';
import '../widgets/custom_dialog.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin{
  TextEditingController controller = TextEditingController();
  late AnimationController animationController;
  final logger = Logger();
  bool isClick = false;
  bool isButtonActive=false;
  double amount = 0.0;
  bool listen = false;
  Map<String, dynamic>? paymentIntentData;
  @override
  void initState() {
    isClick = false;
    isButtonActive=false;
    animationController=BottomSheet.createAnimationController(this);
    animationController.duration=const Duration(seconds: 1);
    animationController.reverseDuration=const Duration(seconds: 1);
    context.read<CartProvider>().getData();
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: UserHelper.getColor(),
        actions: [
          IconButton(
              onPressed: () {
                String title ='Attention';
                String message ='Votre panier sera vidé';
                String non='ANNULER';
                String oui='VALIDER';
                showGenDialog(context, false, CustomDialog(
                  title: 'Ooooops',
                  content:
                  message,
                  positiveBtnText: "OK",
                  positiveBtnPressed: () {
                    cartProvider.clearPrefItems();
                    Navigator.of(context).pop();
                  },
                  negativeBtnText: non,
                ));
              },
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,
              )),
        ],
      ),
      body:Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
                builder: (BuildContext context,provider,_){
                  if(provider.cart.isEmpty){
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage('img/empty_cart.png'),
                          ),
                          const SizedBox(height: 20,),
                          Text('Votre panier est vide 😌' ,style: Theme.of(context).textTheme.headline5),
                          const SizedBox(height: 20,),
                          Text('Explore products and shop your\nfavourite items' , textAlign: TextAlign.center ,style: Theme.of(context).textTheme.subtitle2)

                        ],
                      ),
                    );
                  }else{
                    return
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:provider.cart.length + 1,
                          itemBuilder: (context, index) {
                            if (index == provider.cart.length) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.file_copy),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isClick = true;
                                            });
                                          },
                                          child:  Text('Ajouter une instruction',style: TextStyle(color: UserHelper.getColorDark()),))
                                    ],
                                  ),
                                  Visibility(
                                    visible: isClick,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: 'Ajouter une instruction',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6)),
                                          suffixIcon: controller.text.isEmpty
                                              ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isClick = false;
                                                });
                                              },
                                              icon: const Icon(Icons.clear))
                                              : null),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              );
                            }
                            return
                              CartItemView(
                                id: provider.cart[index].id!,
                                title: provider.cart[index].title!,
                                image: provider.cart[index].image,
                                quantity: provider.cart[index].quantity!,
                                price: provider.cart[index].price!,
                              );
                          });
                  }
                }),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              final ValueNotifier<int?> totalPrice = ValueNotifier(null);
              for (var element in value.cart) {
                totalPrice.value =
                    (element.unitPrice! * element.quantity!.value) +
                        (totalPrice.value ?? 0);
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                      valueListenable: totalPrice,
                      builder: (context, val, child) {
                        amount =double.parse(val.toString());
                        return ReusableWidget(
                            title: 'Prix total:',
                            value: r'$' + (val?.toStringAsFixed(2) ?? '0'));
                      }),
                ],
              );
            },
          )
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child:
          MaterialButton(
              height: getProportionateScreenHeight(45),
              color: UserHelper.getColor(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              onPressed: () async{
                List cartList=await cartProvider.getData();
                // await ApiAuthService.getUser();
                String text ='Veuillez remplir votre panier avant de le valider';
                bool cartLength=cartList.isEmpty;
                !cartLength?Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ValiderPanier(
                          totalAmount: amount,
                        ))):ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content:
                    Text(text),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('VALIDER LE PANIER',style: TextStyle(color: Colors.white,fontSize: 18),),
                  Icon(Icons.shopping_cart_checkout,color: Colors.white,size: 23,)
                ],
              )),
        ),
      ),
    ) ;
  }
}