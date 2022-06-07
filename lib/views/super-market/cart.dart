
import 'package:flutter/material.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/views/home-page.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:livraison_express/views/super-market/valider-panier.dart';
import 'package:livraison_express/views/widgets/cart-item-view.dart';
import 'package:livraison_express/views/widgets/show-dialog.dart';
import 'package:provider/provider.dart';

import '../../model/cart-model.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key, required this.moduleColor,
  }) : super(key: key);
  final ModuleColor moduleColor;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController controller = TextEditingController();
  bool isClick = false;
  bool isButtonActive=false;
  Map<String, dynamic> info = {};
  Map<String, dynamic> info1 = {};
  DBHelper? dbHelper = DBHelper();
  @override
  void initState() {
    isClick = false;
    isButtonActive=false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: widget.moduleColor.moduleColor,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>HomePage()));
              },
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                String title ='Attention';
                String message ='Votre panier sera vidé';
                String non='ANNULER';
                String oui='VALIDER';
                ShowDialog.showCartDialog(context, title, message,non,oui);

              },
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,
              )),
        ],
      ),
      body: FutureBuilder(
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
                            return CartItemView(
                                id: snapshot.data![index].id,
                                title: snapshot.data![index].title,
                                image: snapshot.data![index].image,
                                quantity: snapshot.data![index].quantity,
                                price: snapshot.data![index].price);
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

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Prix total:'),
                Consumer<CartProvider>(builder: (context,cartProvide,child){
                  return Text(cartProvider.getTotalPrice().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  );
                },)
                ,
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(widget.moduleColor.moduleColorDark)),
                  onPressed: () async{
                    List cartList=await cartProvider.getData();
                    // await ApiAuthService.getUser();
                    print(cartList.isEmpty);
                    String text ='Veuillez remplir votre panier avant de le valider';
                    bool cartLength=cartList.isEmpty;
                    !cartLength?Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const ValiderPanier())):ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content:
                        Text(text),
                      ),
                    );


                  },
                  child: const Text('VALIDER LE PANIER')),
            )
          ],
        ),
      ),
    ) ;
      ;
  }
}
