import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/service/shopService.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:livraison_express/views/main/sub_category.dart';
import 'package:livraison_express/views/widgets/search_Text_field.dart';
import 'package:provider/provider.dart';

import '../../constant/color-constant.dart';
import '../../model/module_color.dart';
import '../../utils/main_utils.dart';
import '../custom-container.dart';
import '../super-market/cart-provider.dart';
import '../super-market/cart.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {Key? key,
      required this.module,
      required this.moduleColor,
      required this.shops, required this.isOpenedToday, required this.isOpenedTomorrow,})
      : super(key: key);
  final String module;
  final Shops shops;
  final ModuleColor moduleColor;
  final bool isOpenedToday;
  final bool isOpenedTomorrow;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController controller = TextEditingController();
  List<Category> categories=[];
  final List<Category> _searchResult=[];
  FocusNode focusNode=FocusNode();
  bool isVisible = true;
  String name = '';
  @override
  void initState() {
    super.initState();
    isVisible = true;
    controller.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      setState(() {

      });
    });
  }
  getCategories() async {
    await ShopServices.getCategoriesFromShop(shopId: widget.shops.id);
  }
  onSearchTextChanged(String text){
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var productDetail in categories) {
      if (productDetail.libelle!.contains(text)) _searchResult.add(productDetail);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    focusNode.dispose();
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
                  height: getProportionateScreenHeight(40),
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: controller,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Rechercher',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none),
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: focusNode.hasFocus?UserHelper.getColor():null,
                          ),
                          onPressed: () {
                            onSearchTextChanged('');
                          },
                        ),
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                            color: UserHelper.getColor(),
                            onPressed: (){
                              controller.clear();
                              MainUtils.hideKeyBoard(context);
                            },
                            icon: const Icon(Icons.clear))
                            : null),
                    onChanged: onSearchTextChanged,
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
                                    widget.shops.nom!,
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
                future: ShopServices.getCategories(shopId: widget.shops.id!),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                     categories =snapshot.data!;
                    return Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: categories.isNotEmpty?const Color(0xffF2F2F2):Colors.white,
                              child:  _searchResult.isNotEmpty || controller.text.isNotEmpty?
                              GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                itemCount:_searchResult.length,
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
                                        var shopId = widget.shops.id;
                                        var title = categories[index].libelle;
                                        var catId = categories[index].id;
                                        debugPrint(
                                            'shop id $shopId');
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubCategory(
                                                      shopId: shopId!,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      categoryId: catId!,
                                                      title: title!,
                                                    )));
                                      } else {
                                        var shopId = widget.shops.id;
                                        var title = categories[index].slug;
                                        var catId = categories[index].id;
                                        debugPrint(
                                            'shop id ${shopId}');
                                        var parent = 'fromCategory';
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                      shopId: shopId!,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      category: categories[index],
                                                      title: title!,
                                                      fromCategory: true,
                                                    )));
                                      }
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        elevation: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      _searchResult[index].image!
                                                  )
                                              )
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: kShopForegroundGradient1),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  getProportionateScreenWidth(8)),
                                              child: Column(
                                                children: [
                                                  const Expanded(
                                                    child: SizedBox(),
                                                  ),
                                                  Text(
                                                    _searchResult[index].libelle!,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        getProportionateScreenWidth(
                                                            20)),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    getProportionateScreenHeight(10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      // Column(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment.center,
                                      //   children: [
                                      //     CachedNetworkImage(imageUrl: categories[index].image!,
                                      //       height: getProportionateScreenHeight(80),
                                      //     ),
                                      //     // Image.network(
                                      //     //   categories[index].image!,
                                      //     //   height: 80,
                                      //     //   errorBuilder:
                                      //     //       (BuildContext context,
                                      //     //       Object exception,
                                      //     //       StackTrace?
                                      //     //       stackTrace) {
                                      //     //     return Image.asset(
                                      //     //       'img/no_image.png',height: 80,);
                                      //     //   },
                                      //     // ),
                                      //     Text(
                                      //       categories[index].libelle!,
                                      //     )
                                      //   ],
                                      // ),
                                    ),
                                  );
                                },
                              ):
                              GridView.builder(
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
                                        var shopId = widget.shops.id;
                                        var title = categories[index].libelle;
                                        var catId = categories[index].id;
                                        debugPrint(
                                            'shop id $shopId');
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubCategory(
                                                      shopId: shopId!,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      categoryId: catId!,
                                                      title: title!,
                                                    )));
                                      } else {
                                        var shopId = widget.shops.id;
                                        var title = categories[index].slug;
                                        debugPrint(
                                            'shop id ${shopId}');
                                        var parent = 'fromCategory';
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(
                                                      shopId: shopId!,
                                                      moduleColor:
                                                      widget.moduleColor,
                                                      category: categories[index],
                                                      title: title!,
                                                      fromCategory: true,
                                                    )));
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      elevation: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                categories[index].image!
                                            )
                                          )
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: kShopForegroundGradient1),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                getProportionateScreenWidth(8)),
                                            child: Column(
                                              children: [
                                                const Expanded(
                                                  child: SizedBox(),
                                                ),
                                                Text(
                                                  categories[index].libelle!,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                      getProportionateScreenWidth(
                                                          20)),
                                                ),
                                                SizedBox(
                                                  height:
                                                  getProportionateScreenHeight(10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      // Column(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   mainAxisAlignment:
                                      //   MainAxisAlignment.center,
                                      //   children: [
                                      //     CachedNetworkImage(imageUrl: categories[index].image!,
                                      //       height: getProportionateScreenHeight(80),
                                      //     ),
                                      //     // Image.network(
                                      //     //   categories[index].image!,
                                      //     //   height: 80,
                                      //     //   errorBuilder:
                                      //     //       (BuildContext context,
                                      //     //       Object exception,
                                      //     //       StackTrace?
                                      //     //       stackTrace) {
                                      //     //     return Image.asset(
                                      //     //       'img/no_image.png',height: 80,);
                                      //     //   },
                                      //     // ),
                                      //     Text(
                                      //       categories[index].libelle!,
                                      //     )
                                      //   ],
                                      // ),
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
                badgeColor: widget.moduleColor.moduleColorDark!,
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
                                  slug: UserHelper.shops.slug!,
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
