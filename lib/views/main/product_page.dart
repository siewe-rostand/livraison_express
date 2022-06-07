import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livraison_express/service/product_service.dart';
import 'package:provider/provider.dart';

import '../../data/local_db/db-helper.dart';
import '../../model/cart-model.dart';
import '../../model/module_color.dart';
import '../../model/product.dart';
import '../super-market/cart-provider.dart';
import '../super-market/cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {Key? key,
      required this.shopId,
      required this.title,
      required this.categoryId,
      required this.fromCategory,
      required this.moduleColor,
      this.subSubCategoryId,
      this.subCategoryId})
      : super(key: key);
  final int shopId;
  final String title;
  final int categoryId;
  final ModuleColor moduleColor;
  final bool fromCategory;
  final int? subCategoryId;
  final int? subSubCategoryId;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  DBHelper? dbHelper = DBHelper();
  TextEditingController controller = TextEditingController();
  List<Products> products = [];
  late Future<List<Products>> _future;
  List products1 = [];
  int page = 1;
  String perPage = '10';
  final ScrollController _controller = ScrollController();
  bool _loading = false;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _posts = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    Payload payload =await ProductService.getProducts1(categoryId: widget.categoryId, shopId: widget.shopId, page: page,perPage: perPage);
    _posts.insertAll(0, payload.data);

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      page += 1; // Increase _page by 1
      try {
        final res =
        await ProductService.getProducts1(categoryId: widget.categoryId, shopId: widget.shopId, page: page,perPage: perPage);

        List<Products> fetchedPosts=[];
        fetchedPosts.insertAll(0, res.data);
        if (fetchedPosts.length > 0) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }


  void _setListener() {
    _controller.addListener(() async {
      var max = _controller.position.maxScrollExtent;
      var offset = _controller.offset;
      if (_controller.offset >=
          _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          _loading = true;
        });
        getProduct(page);
      }
    });
  }

  getProduct(int page1) async {
    if (widget.fromCategory == true) {
      products = await ProductService.getProducts(
          categoryId: widget.categoryId,
          shopId: widget.shopId,
          page: page1,
          isLoading: false);
    } else {
      if (widget.subSubCategoryId == 0) {
        products = await ProductService.getProductsWithSubCat(
            categoryId: widget.categoryId,
            subCategoryId: widget.subCategoryId!,
            shopId: widget.shopId,
            page: page);
      } else {
        products = await ProductService.getProductsWithSubSubCat(
            categoryId: widget.categoryId,
            subSubCategoryId: widget.subSubCategoryId!,
            subCategoryId: widget.subCategoryId!,
            shopId: widget.shopId,
            page: page);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    // _setListener();
    // getProduct(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            elevation: 0,
            backgroundColor: widget.moduleColor.moduleColor,
            title: Container(
              margin: const EdgeInsets.only(
                top: 2,
              ),
              height: 45,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Rechercher',
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
        body:
        FutureBuilder<Payload>(
          future: ProductService.getProducts1(
              categoryId: widget.categoryId,
              shopId: widget.shopId,
              page: page,
              perPage: perPage,
              isLoading: false),
          builder: (context, snapshot) {
           if(snapshot.hasData) {
              Payload? payload = snapshot.data;
              if (payload != null) {
                products.insertAll(0, payload.data);
                perPage = payload.perPage!;
              }

              return
                  // Container();
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      color: const Color(0xffF2F2F2),
                      child: ListView.builder(
                          controller: _controller,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Material(
                              shadowColor: Colors.grey,
                              child: InkWell(
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
                                                      height: 100,
                                                      child: Image.network(
                                                        products[index].image!,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                              'img/no_image.png');
                                                        },
                                                      )),
                                                  subtitle: Center(
                                                    child: Text(
                                                      products[index]
                                                          .libelle
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20)),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  products[index]
                                                          .prixUnitaire
                                                          .toString() +
                                                      ' FCFA',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Consumer<CartProvider>(builder: (context,provider,child){
                                                //   return ;
                                                // })

                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                      widget.moduleColor
                                                          .moduleColor,
                                                    )),
                                                    onPressed: () {
                                                      print(products[index]
                                                              .libelle! +
                                                          ' ' +
                                                          products[index]
                                                              .prixUnitaire
                                                              .toString());
                                                      Navigator.of(context)
                                                          .pop();
                                                      // cart.addItem(products[index],products[index].id.toString());
                                                      dbHelper!
                                                          .insert(CartItem(
                                                              id: index,
                                                              title: products[
                                                                      index]
                                                                  .libelle!,
                                                              quantity: 1,
                                                              price: products[
                                                                      index]
                                                                  .prixUnitaire!,
                                                              image: products[
                                                                      index]
                                                                  .image!))
                                                          .then((value) {
                                                        print('====$value');
                                                        cartProvider
                                                            .addTotalPrice(double
                                                                .parse(products[
                                                                        index]
                                                                    .prixUnitaire
                                                                    .toString()));
                                                        cartProvider
                                                            .addCounter();
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print(' ---- $error');
                                                        print(
                                                            'stack $stackTrace');
                                                      });
                                                    },
                                                    child: const Text(
                                                      'AJOUTER AU PANIER',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.white,
                                        child: SizedBox(
                                          height: 60,
                                          child: Image.network(
                                            products[index].image!,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                  'img/no_image.png');
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        margin: const EdgeInsets.only(right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 4),
                                                  child: Text(
                                                    products[index]
                                                            .prixUnitaire
                                                            .toString() +
                                                        ' FCFA',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff00a117),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.bottomCenter,
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
                          }));
            }else{
             return const Center(child: CircularProgressIndicator());
           }
          },
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
        )
        );
  }
}
