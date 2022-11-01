import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/service/shopService.dart';
import 'package:livraison_express/views/main/categoryPage.dart';

import '../../data/user_helper.dart';
import '../../model/category.dart';
import '../../model/day_item.dart';
import '../../model/shop.dart';
import '../../utils/size_config.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress(
      {Key? key,
      required this.moduleId,
      required this.city,
      required this.latitude,
      required this.longitude,
      required this.shops})
      : super(key: key);
  final int moduleId;
  final String city;
  final double latitude;
  final double longitude;
  final List<Shops> shops;

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  TextEditingController controller = TextEditingController();
  bool isVisible = true;
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  List<Category> categoryList = [];
  List<Shops> shops = [];


  @override
  void initState() {
    super.initState();

    shops = widget.shops;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: UserHelper.getColor()),
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
        body: ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              var shopId = shops[index].id;
              if (shops[index].horaires != null) {
                if (shops[index].horaires!.today != null) {
                  List<DayItem>? itemsToday =
                      shops[index].horaires?.today?.items;
                  for (DayItem i in itemsToday!) {
                    try {
                      DateTime now = DateTime.now();
                      String? openTime = i.openedAt;
                      String? closeTime = i.closedAt;
                      var nw = openTime?.substring(0, 2);
                      var a = openTime?.substring(3, 5);
                      var cnm = closeTime?.substring(0, 2);
                      var cla = closeTime?.substring(3, 5);
                      DateTime openTimeStamp = DateTime(now.year, now.month,
                          now.day, int.parse(nw!), int.parse(a!), 0);
                      DateTime closeTimeStamp = DateTime(now.year, now.month,
                          now.day, int.parse(cnm!), int.parse(cla!), 0);
                      if ((now.isAtSameMomentAs(openTimeStamp) ||
                              now.isAfter(openTimeStamp)) &&
                          now.isBefore(closeTimeStamp)) {
                        setState(() {
                          isTodayOpened = true;
                        });
                      }
                    } catch (e) {
                      debugPrint('shop get time error $e');
                    }
                  }
                }
                if (shops[index].horaires!.tomorrow != null) {
                  List<DayItem>? itemsToday =
                      shops[index].horaires?.tomorrow?.items;
                  for (DayItem i in itemsToday!) {
                    try {
                      DateTime now = DateTime.now();
                      String? openTime = i.openedAt;
                      String? closeTime = i.closedAt;
                      if (openTime!.isNotEmpty && closeTime!.isNotEmpty) {
                        setState(() {
                          isTomorrowOpened = true;
                        });
                      }
                      log('isTomorrowOpened $isTomorrowOpened');
                    } catch (e) {
                      debugPrint('shop get time error $e');
                    }
                  }
                }
              }
              return InkWell(
                  onTap: () async {
                    categoryList =
                        await ShopServices.getCategories(shopId: shopId!);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoryPage(
                            )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(4),
                            horizontal: getProportionateScreenHeight(8)),
                        height: getProportionateScreenHeight(200),
                        width: SizeConfig.screenWidth,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: kShopBackgroundGradient),
                            child: Container(
                              height: getProportionateScreenHeight(200),
                              width: SizeConfig.screenWidth,
                              margin: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(4)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      shops[index].image!),
                                  colorFilter: !isTodayOpened
                                      ? const ColorFilter.mode(
                                          Colors.white, BlendMode.saturation)
                                      : null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: kShopForegroundGradient),
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
                                        shops[index].nom!,
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
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isTodayOpened && isTomorrowOpened,
                        child: Positioned(
                            left: 0,
                            right: 0,
                            top: getProportionateScreenHeight(70),
                            bottom: getProportionateScreenHeight(70),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenHeight(19.5)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: kOverlay40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('FERMER'),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 10)),
                                        backgroundColor:
                                            MaterialStateProperty.all(UserHelper.getColorDark())),
                                    onPressed: () {
                                      !isTomorrowOpened?Fluttertoast.showToast(msg: 'Service indisponible demain'):Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => CategoryPage(
                                          )));
                                    },
                                    child: const Text(
                                      'Précommander',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      Visibility(
                        visible: !isTodayOpened && !isTomorrowOpened,
                        child: Positioned(
                            left: 0,
                            right: 0,
                            top: getProportionateScreenHeight(70),
                            bottom: getProportionateScreenHeight(70),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                  getProportionateScreenHeight(19.5)),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              color: kOverlay40,
                              child: const Text('FERMER',style: TextStyle(color: Colors.white70,fontSize: 20,fontWeight: FontWeight.bold),),
                            )),
                      )
                    ],
                  )
                  // Container(
                  //   margin: const EdgeInsets.all(8),
                  //   height: 150,
                  //   width: double.infinity,
                  //   decoration: const BoxDecoration(
                  //       gradient: LinearGradient(
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter,
                  //           colors: [
                  //         Color(0XFF666666),
                  //         Color(0XFFFFFFFF),
                  //         Color(0XFF666666),
                  //       ])),
                  //   child: Card(
                  //     child: Stack(
                  //       children: [
                  //         Image.network(
                  //           magasins[index].image!,
                  //           errorBuilder: (BuildContext context, Object exception,
                  //               StackTrace? stackTrace) {
                  //             return Container(
                  //               width: double.infinity,
                  //               decoration: const BoxDecoration(
                  //                   gradient: LinearGradient(
                  //                       begin: Alignment.topCenter,
                  //                       end: Alignment.bottomCenter,
                  //                       colors: [
                  //                     Color(0xffb3000000),
                  //                     Color(0xff1A000000),
                  //                     Color(0xffB3000000)
                  //                   ])),
                  //               child: SvgPicture.asset(
                  //                 'img/icon/svg/bg_image_magasin_fore.svg',
                  //                 fit: BoxFit.fitWidth,
                  //                 width: double.infinity,
                  //                 height: 150,
                  //               ),
                  //             );
                  //           },
                  //           height: 150,
                  //           width: double.infinity,
                  //           fit: BoxFit.fitWidth,
                  //         ),
                  //         Positioned(
                  //             top: 12,
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Center(
                  //                     child: Text(
                  //                   magasins[index].nom!,
                  //                   style: const TextStyle(
                  //                       color: Colors.white,
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 24),
                  //                 )),
                  //                 isTodayOpened ==false
                  //                     ? Container(
                  //                   margin: EdgeInsets.symmetric(
                  //                       horizontal: getProportionateScreenHeight(19.5)
                  //                   ),
                  //                   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                   color: kOverlay40,
                  //                       child: Row(
                  //                           mainAxisSize: MainAxisSize.min,
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.spaceBetween,
                  //                           children: [
                  //                             const Text('Fermé'),
                  //                             ElevatedButton(
                  //                                 style: ButtonStyle(
                  //                                     padding:
                  //                                         MaterialStateProperty.all(
                  //                                             const EdgeInsets
                  //                                                     .symmetric(
                  //                                                 horizontal: 10)),
                  //                                     backgroundColor:
                  //                                         MaterialStateProperty.all(
                  //                                             widget.moduleColor
                  //                                                 .moduleColorDark)),
                  //                                 onPressed: () async {},
                  //                                 child: const Text(
                  //                                   'Précommander',
                  //                                   style: TextStyle(
                  //                                       color: Color(0xffF3F3F3)),
                  //                                 ))
                  //                           ],
                  //                         ),
                  //                     )
                  //                     : Container()
                  //               ],
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  );
            }));
  }
}
