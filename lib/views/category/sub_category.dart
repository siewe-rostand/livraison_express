import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:livraison_express/views/widgets/custom_sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../../model/category.dart';
import '../../model/module_color.dart';
import '../../provider/nav_view_model.dart';
import '../../service/shopService.dart';
import '../../utils/size_config.dart';
import '../custom-container.dart';
import '../super-market/cart-provider.dart';
import '../cart/cart.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/open_wrapper.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({Key? key,required this.shopId,required this.categoryId,required this.title,
    }) : super(key: key);
  final int shopId;
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
  void initState() {
     print('sub category page');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
      SystemUiOverlayStyle(statusBarColor:UserHelper.getColor()),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: UserHelper.getColor(),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: AppBar(
                elevation: 0,
                backgroundColor:UserHelper.getColor(),
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
              onNotification: (overScroll){
                overScroll.disallowIndicator();
                return true;
              },
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context,isScrolled){
                    return [CustomSliverAppBar(title: UserHelper.category.libelle!)];
                  },
                  body: FutureBuilder<List<Category>>(
                      future:
                      ShopServices.getSubCategoriesFromShopAndCategory(shopId: widget.shopId,categoryId: widget.categoryId),
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
                                    closedBuilder: (BuildContext c, VoidCallback openContainer){
                                      return InkWellOverlay(onTap: (){
                                        UserHelper.category = categoryList![index];
                                        openContainer();
                                      });
                                    },
                                    nextPage: const ProductPage());
                              },
                            ),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                )
            ),
            floatingActionButton: OpenContainerWrapper(
              closedBuilder: (BuildContext c, VoidCallback openContainer){
                return CustomFloatingButton(onTap: openContainer,);
              },
              nextPage: const CartPage(),
              onClosed:  (v) async => Future.delayed(
                  const Duration(milliseconds: 500)),
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
        )
    );
  }
}
