import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:provider/provider.dart';

import '../../model/category.dart';
import '../../model/module_color.dart';
import '../../service/shopService.dart';
import '../custom-container.dart';
import '../super-market/cart-provider.dart';
import '../super-market/cart.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({Key? key,required this.shopId,required this.categoryId,required this.title,
    required this.moduleColor,}) : super(key: key);
  final int shopId;
  final ModuleColor moduleColor;
  final String title;
  final int categoryId;

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {

  TextEditingController controller = TextEditingController();
  bool isVisible = true;
  String name = '';
   int parentCategoryId = 0;
   int grandParentCategoryId = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
      SystemUiOverlayStyle(statusBarColor: widget.moduleColor.moduleColor),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: widget.moduleColor.moduleColor,
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
            body: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
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
                            height: 65,
                            child: Card(
                              elevation: 10,
                              child: ElevatedButton(
                                child: Text(
                                  'widget.shopName',
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
                    const SizedBox(
                      height: 12,
                    ),
                    FutureBuilder<List<Category>>(
                        future:
                        ShopServices.getCategories(shopId: widget.shopId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var categoryList = snapshot.data;
                            debugPrint('shop category ${widget.shopId}');
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: const Color(0xffF2F2F2),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemCount: categoryList?.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      bool? hasChildren =
                                          categoryList![index].hasChildren;
                                      debugPrint(
                                          'category id ${categoryList[index].id}');
                                      if (hasChildren == true) {
                                        var shopId = widget.shopId;
                                        var title = categoryList[index].libelle;
                                        var catId = categoryList[index].id;
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
                                        var title = categoryList[index].libelle;
                                        var catId = categoryList[index].id;
                                        bool fromCategory =false;
                                        int categoryId = grandParentCategoryId == 0 ? parentCategoryId : grandParentCategoryId;
                                        int? sousCategoryId = grandParentCategoryId == 0 ?catId:parentCategoryId;
                                        int? sousSousCategoryId = sousCategoryId == catId ? 0 : catId;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                      shopId: shopId,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      category: categoryList[index],
                                                      title: title!,
                                                      fromCategory: false,
                                                      subCategoryId: sousCategoryId,
                                                      subSubCategoryId: sousSousCategoryId,
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
                                            categoryList![index].image!,
                                            height: 80,
                                          ),
                                          Text(
                                            categoryList[index].libelle!,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ),
            ),
            floatingActionButton: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: Badge(
                padding: const EdgeInsets.all(10),
                badgeColor: Colors.grey,
                animationType: BadgeAnimationType.scale,
                badgeContent: Consumer<CartProvider>(
                  builder: (_, cart, child) {
                    return Text(
                      (cart.getCounter()).toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    );
                  },
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CartPage(
                              moduleColor: widget.moduleColor,
                              slug: UserHelper.shops.slug!,
                            )));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: widget.moduleColor.moduleColor,
                  ),
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
