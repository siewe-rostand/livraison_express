import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/provider/nav_view_model.dart';
import 'package:livraison_express/service/shopService.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/main/product_page.dart';
import 'package:livraison_express/views/main/sub_category.dart';
import 'package:livraison_express/views/widgets/floating_action_button.dart';
import 'package:livraison_express/views/widgets/search_Text_field.dart';
import 'package:provider/provider.dart';

import '../../constant/color-constant.dart';
import '../../model/module_color.dart';
import '../../utils/main_utils.dart';
import '../custom-container.dart';
import '../super-market/cart-provider.dart';
import '../super-market/cart.dart';
import '../widgets/open_wrapper.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {Key? key,})
      : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController controller = TextEditingController();
  List<Category> categories=[];
  final List<Category> _searchResult=[];
  FocusNode focusNode=FocusNode();
  late Shops shops;
  bool? hasChildren;
  bool isVisible = true;
  String name = '';
  @override
  void initState() {
    super.initState();
    isVisible = true;
    shops=UserHelper.shops;
    controller.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      setState(() {

      });
    });
  }
  getCategories() async {
    await ShopServices.getCategoriesFromShop(shopId: shops.id);
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
          SystemUiOverlayStyle(statusBarColor: UserHelper.getColor()),
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: AppBar(
                elevation: 0,
                backgroundColor: UserHelper.getColor(),
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
                    backgroundColor: UserHelper.getColor(),
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
                                backgroundColor: UserHelper.getColor(),
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
                                    shops.nom!,
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
                future: ShopServices.getCategories(shopId: shops.id!),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                     categories =snapshot.data!;
                     fromCategory =true;
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
                                  print('_CategoryPageState.build');
                                      return
                                    OpenContainerWrapper(
                                        closedBuilder:(BuildContext c, openContainer){
                                          return InkWellOverlay(
                                            onTap:(){
                                              UserHelper.category=categories[index];
                                              openContainer();
                                            },
                                            child: items(category: categories[index]),
                                          );
                                        },
                                        onClosed: (v) async => Future.delayed(
                                            const Duration(milliseconds: 500)),
                                        nextPage: categories[index].hasChildren==true?SubCategory(
                                          shopId: shops.id!,
                                          categoryId: categories[index].id!,
                                          title: shops.slug!,
                                        ):const ProductPage());
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
                                  return OpenContainerWrapper(
                                      closedBuilder:(BuildContext c, openContainer){
                                        return InkWell(
                                          onTap:(){
                                            UserHelper.category=categories[index];
                                            openContainer();
                                          },
                                          child: items(category: categories[index]),
                                        );
                                      },
                                      onClosed: (v) async => Future.delayed(
                                          const Duration(milliseconds: 500)),
                                      nextPage: categories[index].hasChildren==true?SubCategory(
                                        shopId: shops.id!,
                                        categoryId: categories[index].id!,
                                        title: shops.slug!,
                                      ):const ProductPage());
                                },
                              ),
                            )
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
            floatingActionButton: OpenContainerWrapper(
              closedBuilder: (BuildContext c, VoidCallback openContainer){
                return CustomFloatingButton(onTap: openContainer,);
              },
              nextPage: CartPage(),
              onClosed:  (v) async => Future.delayed(
                  const Duration(milliseconds: 500)),
            ),
            ),
      ),
    );
  }
  items({required Category category}){
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      category.image!
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
                    category.libelle!,
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
    );
  }
}
