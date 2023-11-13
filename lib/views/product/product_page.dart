import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/product_service.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/product/product-shimmer-card.dart';
import 'package:livraison_express/views/widgets/floating_action_button.dart';
import 'package:livraison_express/views/widgets/open_wrapper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local_db/db-helper.dart';
import '../../model/cart-model.dart';
import '../../model/module.dart';
import '../../model/product.dart';
import '../../model/shop.dart';
import '../../provider/nav_view_model.dart';
import '../../utils/main_utils.dart';
import '../../provider/cart-provider.dart';
import '../cart/cart.dart';
import '../widgets/custom_alert_dialog.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  DBHelper? dbHelper = DBHelper();
  final logger = Logger();
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  List<Products> products = [];
  final List<Products> _searchResult = [];
  late FToast fToast;
  int page = 1, lastPage = 1;
  int perPage = 10;
  final ScrollController _controller = ScrollController();
  bool _loading = false;
  bool _loadingBottom = false;
  bool _show = false;
  bool showFab = true;
  bool isSearch = false;
  late Category category;
  late Shops shops;
  late Modules modules;
  loader() {
    return Positioned(
      bottom: 20,
      child: Visibility(
        visible: _loadingBottom,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(blurRadius: 30, offset: Offset(0, -2))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(UserHelper.getColorDark()),
              strokeWidth: 2.5,
            ),
          ),
        ),
      ),
    );
  }

  getProduct() async {
    _loading = page == 1;
    if (fromCategory == true) {
      await ProductService.getProducts(
        categoryId: category.id!,
        shopId: shops.id!,
        page: page,
      ).then((response) {
        setState(() {
          _loading = _loadingBottom = false;
          lastPage = response['last_page'];
          products.addAll(response['products']);
        });
      }).catchError((onError) {
        UserHelper.userExitDialog(
            context,
            false,
            CustomAlertDialog(
              svgIcon: "assets/images/smiley_sad.svg",
              title: "Oops!",
              positiveText: 'Réessayer',
              onCancel: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              message:
                  " Si l'érreur persiste veuillez contacter le service client.",
              onContinue: () => getProduct(),
            ));
        logger.e("from get product ${onError.toString()}");
      });
    } else {
      if (sousSousCategoryId == 0) {
        await ProductService.getProductsWithSubCat(
                categoryId: category.id!,
                subCategoryId: sousCategoryId!,
                shopId: shops.id!,
                page: page)
            .then((response) {
          var body = json.decode(response.body);
          var rest = body['data'] as List;
          products =
              rest.map<Products>((json) => Products.fromJson(json)).toList();
        });
      } else {
        await ProductService.getProductsWithSubSubCat(
                categoryId: category.id!,
                subSubCategoryId: sousSousCategoryId!,
                subCategoryId: sousCategoryId!,
                shopId: shops.id!,
                page: page)
            .then((response) {
          var body = json.decode(response.body);
          var rest = body['data'] as List;

          products =
              rest.map<Products>((json) => Products.fromJson(json)).toList();
          logger.e("rest only from get product from sub sub category ");
        });
      }
    }
  }

  addToCart(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString("userData");
    final extractedUserData = json.decode(userString!);
    AppUser1 user = AppUser1.fromJson(extractedUserData);

    dbHelper
        ?.insert(
      CartItem(
          id: index,
          productId: int.parse(products[index].id!.toString()),
          title: products[index].libelle!,
          quantity: 1,
          price: products[index].prixUnitaire!,
          unitPrice: products[index].prixUnitaire!,
          totalPrice: products[index].prixUnitaire!,
          quantityMax: products[index].quantiteDispo!,
          categoryId: products[index].categorieId!,
          preparationTime: products[index].tempsPreparation,
          moduleSlug: modules.slug,
          image: products[index].image!,
          userId: user.id),
    )
        .then((value) {
      Provider.of<CartProvider>(context, listen: false)
          .addTotalPrice(products[index].prixUnitaire!.toDouble());
      Provider.of<CartProvider>(context, listen: false).addCounter();
      Navigator.of(context).pop();
      showToast(
          context: context,
          text: "${products[index].libelle} a ete bien ajouter au panier",
          iconData: Icons.check,
          color: Colors.green);
    }).onError((error, stackTrace) {
      logger.e(error);
      _show = false;
      showFab = true;
      Navigator.of(context).pop();
      showToast(
          context: context,
          text: productAlreadyInCart,
          iconData: Icons.check,
          color: Colors.redAccent);
      // logger.e(' ---- ${error.toString()}');
    });
  }

  _showBottomSheet({required int index, required BuildContext context}) {
    if (_show) {
      return showModalBottomSheet(
          context: context,
          transitionAnimationController: animationController,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              height: SizeConfig.screenHeight! * 0.7,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Container(
                      height: SizeConfig.screenHeight! * 0.3,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                products[index].image!,
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey[300]!,
                                spreadRadius: 5)
                          ]),
                    ),
                    subtitle: Center(
                      child: Text(
                        products[index].libelle.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 3),
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black38,
                  ),
                  Text(
                    products[index].prixUnitaire.toString() + ' FCFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black45),
                  ),
                  MaterialButton(
                      padding: const EdgeInsets.all(20),
                      minWidth: double.infinity,
                      height: getProportionateScreenHeight(45),
                      color: UserHelper.getColor(),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () async {
                        _show = false;
                        showFab = true;
                        setState(() {
                          addToCart(index);
                        });
                      },
                      child: const Text(
                        'AJOUTER AU PANIER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))
                ],
              ),
            );
          }).then((value) {
        setState(() {
          showFab = true;
        });
      });
    } else {
      return Container();
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in products) {
      if (userDetail.libelle!.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    shops = UserHelper.shops;
    modules = UserHelper.module;
    category = UserHelper.category;
    controller.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      setState(() {});
    });
    getProduct();
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (page < lastPage) {
          page++;
          setState(() {
            _loadingBottom = true;
          });
          getProduct();
        }
      }
    });
    animationController = BottomSheet.createAnimationController(this);
    animationController.duration = const Duration(seconds: 1);
    animationController.reverseDuration = const Duration(seconds: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    animationController.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            elevation: 0,
            backgroundColor: colorFromHex(UserHelper.module.moduleColor!),
            title: Container(
                margin: const EdgeInsets.only(
                  top: 2,
                ),
                height: getProportionateScreenHeight(45),
                child: isSearch == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(category.libelle.toString().toUpperCase()),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearch = true;
                                });
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 28,
                                color: Color(0xFF89dad0),
                              ))
                        ],
                      )
                    : ListTile(
                        title: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Rechercher',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: focusNode.hasFocus
                                      ? UserHelper.getColor()
                                      : null,
                                ),
                                onPressed: () {
                                  onSearchTextChanged('');
                                },
                              ),
                              suffixIcon: controller.text.isNotEmpty
                                  ? IconButton(
                                      color: UserHelper.getColor(),
                                      onPressed: () {
                                        controller.clear();
                                        MainUtils.hideKeyBoard(context);
                                      },
                                      icon: const Icon(Icons.clear))
                                  : null),
                          onChanged: onSearchTextChanged,
                        ),
                      )),
          ),
        ),
        body: _loading
            ? const Center(child: ProductShimmerCard())
            : Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      color: const Color(0xffF2F2F2),
                      child: _searchResult.isEmpty && controller.text.isEmpty
                          ? ListView.builder(
                              controller: _controller,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  shadowColor: Colors.grey,
                                  child: InkWell(
                                    autofocus: true,
                                    onTap: () {
                                      setState(() {
                                        _show = true;
                                        showFab = false;
                                      });
                                      _showBottomSheet(
                                          index: index, context: context);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            child: SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        60),
                                                child: Image.network(
                                                  products[index].image!,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Container();
                                                  },
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    80),
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        products[index]
                                                            .libelle
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text(
                                                        products[index]
                                                                .prixUnitaire
                                                                .toString() +
                                                            ' FCFA',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: UserHelper
                                                              .getColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  height: 1,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.black38,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : ListView.builder(
                              controller: _controller,
                              itemCount: _searchResult.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  shadowColor: Colors.grey,
                                  child: InkWell(
                                    autofocus: true,
                                    onTap: () {
                                      setState(() {
                                        _show = true;
                                        showFab = false;
                                      });
                                      _showBottomSheet(
                                          index: index, context: context);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            child: SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        60),
                                                child: Image.network(
                                                  _searchResult[index].image!,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Container();
                                                  },
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    80),
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        _searchResult[index]
                                                            .libelle
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 4),
                                                      child: Text(
                                                        _searchResult[index]
                                                                .prixUnitaire
                                                                .toString() +
                                                            ' FCFA',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: UserHelper
                                                              .getColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  height: 1,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.black38,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                  loader()
                ],
              ),
        floatingActionButton: showFab
            ? OpenContainerWrapper(
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return CustomFloatingButton(onTap: openContainer);
                },
                onClosed: (v) async =>
                    Future.delayed(const Duration(milliseconds: 500)),
                nextPage: const CartPage())
            : Container());
  }
}
