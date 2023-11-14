import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/views/product/product_page.dart';
import 'package:livraison_express/views/widgets/custom_sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../../data/local_db/db-helper.dart';
import '../../model/category.dart';
import '../../provider/cart-provider.dart';
import '../../service/shopService.dart';
import '../../utils/size_config.dart';
import '../cart/cart.dart';
import '../widgets/open_wrapper.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({
    Key? key,
    required this.shopId,
    required this.categoryId,
    required this.title,
  }) : super(key: key);
  final int shopId;
  final String title;
  final int categoryId;

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  DBHelper? dbHelper = DBHelper();

  TextEditingController controller = TextEditingController();
  bool isVisible = true;
  String name = '';
  int parentCategoryId = 0;
  int grandParentCategoryId = 0;

  int cartCount = 0;
  getCounter() async {
    await dbHelper!.getCartList(UserHelper.module.slug!).then((value) {
      setState(() {
        cartCount = value.length;
      });
    });
  }

  @override
  void initState() {
    print('sub category page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCounter();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: UserHelper.getColor()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: UserHelper.getColor(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75),
            child: AppBar(
              elevation: 0,
              backgroundColor: UserHelper.getColor(),
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
          body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, isScrolled) {
                  return [
                    CustomSliverAppBar(title: UserHelper.category.libelle!)
                  ];
                },
                body: FutureBuilder<List<Category>>(
                    future: ShopServices.getSubCategoriesFromShopAndCategory(
                        shopId: widget.shopId, categoryId: widget.categoryId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Category>? categoryList = snapshot.data;
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
                              return OpenContainerWrapper(
                                  closedBuilder: (BuildContext c,
                                      VoidCallback openContainer) {
                                    return InkWellOverlay(onTap: () {
                                      UserHelper.category =
                                          categoryList![index];
                                      openContainer();
                                    });
                                  },
                                  nextPage: const ProductPage());
                            },
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              )),
          floatingActionButton: OpenContainerWrapper(
            closedBuilder: (BuildContext c, VoidCallback openContainer) {
              return Container(
                margin: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 32,
                  child: badge.Badge(
                    padding: const EdgeInsets.all(10),
                    badgeColor: UserHelper.getColorDark(),
                    animationType: badge.BadgeAnimationType.scale,
                    badgeContent: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Text(
                          cartCount.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        );
                      },
                    ),
                    child: IconButton(
                      onPressed: openContainer,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: UserHelper.getColor(),
                      ),
                    ),
                  ),
                ),
              );
            },
            nextPage: const CartPage(),
            onClosed: (v) async =>
                Future.delayed(const Duration(milliseconds: 500)),
          ),
        ),
      ),
    );
  }

  Widget item(Category category) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          elevation: 5.0,
          child: SizedBox(
            height: getProportionateScreenHeight(115),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: category.image!,
                  fit: BoxFit.cover,
                  width: getProportionateScreenWidth(80),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    category.libelle!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(15)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
