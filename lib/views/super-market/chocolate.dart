
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_express/model/cart-model.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/model/product.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/views/super-market/cart.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:provider/provider.dart';


class Chocolate extends StatefulWidget {
  const Chocolate({Key? key}) : super(key: key);

  @override
  State<Chocolate> createState() => _ChocolateState();
}

class _ChocolateState extends State<Chocolate> {
  DBHelper? dbHelper =DBHelper();
  List<Product> products = [];
  TextEditingController controller = TextEditingController();
  // List<CartModel> cartItems = [];

  @override
  void initState() {
    populateChocolate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen:false);
    final cartProvider = Provider.of<CartProvider>(context,listen:false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff00a117),
          title: Container(
            margin: const EdgeInsets.only(
              top: 2,
            ),
            height: 45,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: Colors.white,
                filled: true,
                hintText: 'Rechercher',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () => controller.clear(),
                        icon: const Icon(Icons.clear))
                    : null
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    splashColor: Colors.grey,
                    autofocus: true,
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: SizedBox(
                                          height: 100, child:Image.asset(products[index].image)),
                                      subtitle: Center(
                                        child: Text(
                                          products[index].name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20)),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                      products[index].unitPrice.toString() + ' FCFA',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Consumer<CartProvider>(builder: (context,provider,child){
                                    //   return ;
                                    // })

                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                              const Color(0xff00a117),)),
                                        onPressed: () {
                                          print(products[index].name + ' ' + products[index].unitPrice.toString());
                                          Navigator.of(context).pop();
                                            // cart.addItem(products[index],products[index].id.toString());
                                          dbHelper!.insert(
                                            CartItem(id: index,
                                                title: products[index].name,
                                                quantity: 1,
                                                price: products[index].unitPrice,
                                                image: products[index].image)
                                          ).then((value) {
                                            print('====$value');
                                            cartProvider.addTotalPrice(double.parse(products[index].unitPrice.toString()));
                                            cartProvider.addCounter();
                                          }).onError((error, stackTrace) {
                                            print(' ---- $error');
                                            print('stack $stackTrace');
                                          });
                                        },
                                        child: const Text(
                                          'AJOUTER AU PANIER',
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child:
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white70,
                          child: SizedBox(height: 60, child: Image.asset(products[index].image)),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Text(
                                      products[index].name.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Positioned(
                                      right: 8,
                                      child: Text(
                                        products[index].unitPrice.toString() + ' FCFA',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff00a117),),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black38,
                  )
                ],
              ),
            );
          }),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 32,
        child: Badge(
          padding: const EdgeInsets.all(10),
          badgeColor: Colors.grey,
          animationType: BadgeAnimationType.scale,
          badgeContent: Consumer<CartProvider>(
                    builder: (_, cart, child)
                    {
                return Text(
                  (cart.getCounter()).toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                );
              },
                    ),
          child: IconButton(
            onPressed: (){
              ModuleColor moduleColor=ModuleColor();
              // Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     CartPage(
              //                       moduleColor: moduleColor,
              //                       slug,
              //                     )));

            },
            icon: const Icon(Icons.shopping_cart,color:  Color(0xff00a117),),
          ),
        ),
      )
      // FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (BuildContext context) =>
      //                 const CartPage()));
      //   },
      //   child: Stack(
      //     children: [
      //       const Icon(
      //         Icons.shopping_cart,
      //         color: Colors.green,
      //       ),
      //       // if (cartItems.isNotEmpty)
      //         Padding(
      //           padding: const EdgeInsets.only(left: 15),
      //           child: CircleAvatar(
      //             radius: 10.0,
      //             backgroundColor: Colors.grey,
      //             foregroundColor: Colors.white,
      //             child:
      //             Consumer<Cart>(
      //               builder: (_, cart, child) => Text(cart.itemCount.toString(),
      //                 style: const TextStyle(
      //                     fontWeight: FontWeight.bold, fontSize: 12),
      //               ),
      //               ),
      //
      //           ),
      //         )
      //     ],
      //   ),
      // ),
    );
  }

  void populateChocolate() {
    var list = <Product>[
      Product(
        id: 1,
          name: 'mambo lait 25g',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/mambo_lait_25g.jpg'),
      Product(
        id: 2,
          name: 'mambo lait',
          unitPrice: 750,
          image: 'img/supermarche/chocolate/mambo_lait.jpg'),
      Product(
        id: 3,
          name: 'mambo noir 25g',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/mambo_noir_25g.jpg'),
      Product(
        id: 4,
          name: 'mambo noir ',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/mambo_noir.jpg'),
      Product(
        id: 5,
          name: 'mambo Intense noir ',
          unitPrice: 150,
          image:
              'img/supermarche/chocolate/mambo_intense_noir.jpg' ),
      Product(
        id: 6,
          name: 'mambo au riz 25g',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/mambo_riz_25g.jpg'),
      Product(
        id: 7,
          name: 'mambo au riz',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/mambo_riz.jpg'),
      Product(
        id: 8,
          name: 'Kinder bueno',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/kinder_bueno.jpg'),
      Product(
        id: 9,
          name: 'kinder noir 25g',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/kinder_noir_25g.jpg'),
      Product(
        id: 10,
          name: 'coffret kinder',
          unitPrice: 150,
          image: 'img/supermarche/chocolate/coffret_kinder.jpg'),
    ];

    setState(() {
      products = list;
    });
  }
}
