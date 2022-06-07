import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/service/shopService.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:livraison_express/views/main/sub_category.dart';
import 'package:provider/provider.dart';

import '../../model/module_color.dart';
import '../custom-container.dart';
import '../super-market/cart-provider.dart';
import '../super-market/cart.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {Key? key,
      required this.shopId,
      required this.shopName,
      required this.module,
      required this.moduleColor,
      required this.shopImage,})
      : super(key: key);
  final String module;
  final int shopId;
  final String shopName;
  final String shopImage;
  final ModuleColor moduleColor;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController controller = TextEditingController();
  bool isVisible = true;
  String name = '';
  @override
  void initState() {
    super.initState();
    isVisible = true;
  }

  getCategories() async {
    await ShopServices.getCategoriesFromShop(shopId: widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          SystemUiOverlayStyle(statusBarColor: widget.moduleColor.moduleColor),
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: AppBar(
                elevation: 0,
                backgroundColor: widget.moduleColor.moduleColor,
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () => controller.clear(),
                                icon: const Icon(Icons.clear))
                            : null),
                  ),
                ),
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: widget.moduleColor.moduleColor,
                    automaticallyImplyLeading: false,
                    floating: true,
                    expandedHeight: 70,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomContainer(
                                progress: 0.5,
                                size: 70,
                                backgroundColor: widget.moduleColor.moduleColor,
                                progressColor: Colors.white,
                              ),
                            ],
                          ),
                          Positioned(
                            top: isVisible == true ? null : -10,
                            left: 20,
                            right: 20,
                            child: SizedBox(
                              height: 70,
                              child: Card(
                                elevation: 10,
                                child: ElevatedButton(
                                  child: Text(
                                    widget.shopName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
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
                    ),
                  )
                ];
              },
              body: FutureBuilder<List<Category>>(
                future: ShopServices.getCategories(shopId: widget.shopId),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    List<Category>? categories =snapshot.data;
                    return Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: categories!.isNotEmpty?const Color(0xffF2F2F2):Colors.white,
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemCount:categories.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      bool? hasChildren =
                                         categories[index].hasChildren;
                                      debugPrint(
                                          'category id ${categories[index].id}');
                                      if (hasChildren == true) {
                                        var shopId = widget.shopId;
                                        var title = categories[index].libelle;
                                        var catId = categories[index].id;
                                        debugPrint(
                                            'shop id ${shopId}');
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubCategory(
                                                      shopId: shopId,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      categoryId: catId!,
                                                      title: title!,
                                                    )));
                                      } else {
                                        var shopId = widget.shopId;
                                        var title = categories[index].libelle;
                                        var catId = categories[index].id;
                                        debugPrint(
                                            'shop id ${shopId}');
                                        var parent = 'fromCategory';
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                      shopId: shopId,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      categoryId: catId!,
                                                      title: title!,
                                                      fromCategory: true,
                                                    )));
                                      }
                                    },
                                    child: Card(
                                      elevation: 8,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            categories[index].image!,
                                            height: 80,
                                            errorBuilder:
                                                (BuildContext context,
                                                Object exception,
                                                StackTrace?
                                                stackTrace) {
                                              return Image.asset(
                                                'img/no_image.png',height: 80,);
                                            },
                                          ),
                                          Text(
                                            categories[index].libelle!,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            // FutureBuilder<List<Category>>(
                            //     future:
                            //         ShopServices.getCategories(shopId: widget.shopId),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.hasData) {
                            //         var categoryList = snapshot.data;
                            //         debugPrint('shop category ${widget.shopId}');
                            //         return Container(
                            //           margin: const EdgeInsets.symmetric(
                            //               horizontal: 10, vertical: 5),
                            //           color: const Color(0xffF2F2F2),
                            //           child: GridView.builder(
                            //             shrinkWrap: true,
                            //             gridDelegate:
                            //                 const SliverGridDelegateWithFixedCrossAxisCount(
                            //                     crossAxisCount: 2),
                            //             itemCount: categoryList?.length,
                            //             physics: const ScrollPhysics(),
                            //             itemBuilder: (context, index) {
                            //               return InkWell(
                            //                 splashColor: Colors.grey,
                            //                 onTap: () {
                            //                   bool? hasChildren =
                            //                       categoryList![index].hasChildren;
                            //                   debugPrint(
                            //                       'category id ${categoryList[index].id}');
                            //                   if (hasChildren == true) {
                            //                     var shopId = widget.shopId;
                            //                     var title = categoryList[index].libelle;
                            //                     var catId = categoryList[index].id;
                            //                     Navigator.of(context).push(
                            //                         MaterialPageRoute(
                            //                             builder: (context) =>
                            //                                 SubCategory(
                            //                                   shopId: shopId,
                            //                                   moduleColor:
                            //                                       widget.moduleColor,
                            //                                   categoryId: catId!,
                            //                                   title: title!,
                            //                                 )));
                            //                   } else {
                            //                     var shopId = widget.shopId;
                            //                     var title = categoryList[index].libelle;
                            //                     var catId = categoryList[index].id;
                            //                     var parent = 'fromCategory';
                            //                     Navigator.of(context).push(
                            //                         MaterialPageRoute(
                            //                             builder: (context) =>
                            //                                 ProductPage(
                            //                                   shopId: shopId,
                            //                                   moduleColor:
                            //                                       widget.moduleColor,
                            //                                   categoryId: catId!,
                            //                                   title: title!,
                            //                                   fromCategory: true,
                            //                                 )));
                            //                   }
                            //                 },
                            //                 child: Card(
                            //                   elevation: 8,
                            //                   child: Column(
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.center,
                            //                     children: [
                            //                       Image.network(
                            //                         categoryList![index].image!,
                            //                         height: 80,
                            //                       ),
                            //                       Text(
                            //                         categoryList[index].libelle!,
                            //                       )
                            //                     ],
                            //                   ),
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         );
                            //       } else {
                            //         return const Center(
                            //             child: CircularProgressIndicator());
                            //       }
                            //     }),
                          ],
                        ),
                      ),
                    );
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            floatingActionButton: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: Badge(
                padding: const EdgeInsets.all(10),
                badgeColor: Colors.grey.shade400,
                animationType: BadgeAnimationType.scale,
                badgeContent: Consumer<CartProvider>(
                  builder: (_, cart, child) {
                    return Text(
                      (cart.getCounter()).toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12,color: Colors.white),
                    );
                  },
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CartPage(
                                  moduleColor: widget.moduleColor,
                                )));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: widget.moduleColor.moduleColor,
                  ),
                ),
              ),
            ),
            ),
      ),
    );
  }
}
