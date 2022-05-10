import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/views/custom-container.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/views/super-market/cart.dart';
import 'package:livraison_express/views/super-market/chocolate.dart';
import 'package:provider/provider.dart';

class SuperMarket extends StatefulWidget {
  const SuperMarket({Key? key}) : super(key: key);

  @override
  State<SuperMarket> createState() => _SuperMarketState();
}

class _SuperMarketState extends State<SuperMarket> {
  TextEditingController controller = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    isVisible =true;
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff00a117),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff00a117),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75),
            child: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xff00a117),
              title: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                height: 40,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Recherche',
                    border:
                        OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none
                        ),
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
          body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  [
                          CustomContainer(
                            progress: 0.5,
                            size: 70,
                            backgroundColor: const Color(0xff00a117),
                            progressColor: Colors.white,
                          ),
                        ],
                      ),
                      Positioned(
                        top: isVisible == true ? null : -10,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          height: 65,
                          child: Card(
                            elevation: 10,
                            child: ElevatedButton(
                              child: const Text("SuperMarche Express Douala",style: TextStyle(fontWeight: FontWeight.bold),),
                              onPressed: null,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    color: const Color(0xffF2F2F2),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Chocolate()));
                            },
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/whisky_chanceler.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Chocolate',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xffF2F2F2),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/mayonnaise.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Mayonnaise',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/farine.jpg',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Farine',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    color: const Color(0xffF2F2F2),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/huile-mayor-min.jpg',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Huile-Mayor',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/lait_en_sachet.jpg',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Lait en Sachet',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xffF2F2F2),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                              elevation: 8,
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/beurre.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Beurre',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/riz_bijou_parfum_.jpg',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Riz bijou parfumer',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/whisky_chanceler.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Beurre',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: ListTile(
                                title: Image.asset(
                                  'img/supermarche/vin.png',
                                  height: 90,
                                ),
                                subtitle: const Center(
                                    child: Text(
                                  'Vin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton:CircleAvatar(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const CartPage()));

                },
                icon: const Icon(Icons.shopping_cart,color: Colors.green,),
              ),
            ),
          )
          // FloatingActionButton(
          //   backgroundColor: Colors.white,
          //   tooltip: 'panier',
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) =>
          //             const CartPage()));
          //   },
          //   child: Stack(
          //     children: [
          //       const Icon(
          //         Icons.shopping_cart,
          //         color: Colors.green,
          //       ),
          //       // if (cartItems.isNotEmpty)
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15),
          //         child: CircleAvatar(
          //           radius: 10.0,
          //           backgroundColor: Colors.grey,
          //           foregroundColor: Colors.white,
          //           child:
          //           Consumer<CartProvider>(
          //             builder: (_, cart, child)
          //             {
          //               return Text(
          //                 (cart.getCounter()).toString(),
          //                 style: const TextStyle(
          //                     fontWeight: FontWeight.bold, fontSize: 12),
          //               );
          //             },
          //           ),
          //
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
