

import 'package:flutter/material.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/views/super-market/valider-panier.dart';
import 'package:livraison_express/views/cart/cart-item-view.dart';
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
  final logger = Logger();
  bool isClick = false;
  bool isButtonActive=false;
  double amount = 0.0;
  bool listen = false;
  Map<String, dynamic>? paymentIntentData;
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
      body:  FutureBuilder<List<CartItem>>(
        future: cartProvider.getData(),
        builder: (context ,AsyncSnapshot<List<CartItem>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:snapshot.data!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == snapshot.data!.length) {
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
                                          child: const Text('Ajouter une instruction',style: TextStyle(color: Color(0xff00a117)),))
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
                              CartItemView(cartItem: snapshot.data![index],);
                          }),
                    ),
                  ],
                ),
              );
            }
          }
          return const Text('') ;
        },
      ),

      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Prix total:',style: TextStyle(color: Colors.grey.withOpacity(0.86),fontSize: 20),),
                Consumer<CartProvider>(builder: (context,cartProvide,child){
                  amount =cartProvide.getTotalPrice();
                  return Text(cartProvider.getTotalPrice().toStringAsFixed(0)+' FCFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                },)
                ,
              ],
            ),
            SizedBox(
              width: double.infinity,
              child:
              MaterialButton(
                  height: getProportionateScreenHeight(45),
                  color: UserHelper.getColorDark(),
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
            )
          ],
        ),
      ),
    ) ;
  }
}