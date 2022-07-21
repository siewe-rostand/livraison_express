import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/views/main/categoryPage.dart';

import '../../constant/color-constant.dart';
import '../../model/category.dart';
import '../../model/day_item.dart';
import '../../model/module_color.dart';
import '../../service/shopService.dart';
import '../../utils/size_config.dart';

class MagasinPage extends StatefulWidget {
  final ModuleColor moduleColor;
  final List<Shops> shops;
  const MagasinPage({Key? key, required this.moduleColor, required this.shops}) : super(key: key);

  @override
  State<MagasinPage> createState() => _MagasinPageState();
}

class _MagasinPageState extends State<MagasinPage> {
  List<Shops> shops = [];
  List<Category> categoryList = [];
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
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
              statusBarColor: widget.moduleColor.moduleColor),
          backgroundColor: widget.moduleColor.moduleColor,
          title: Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            height: getProportionateScreenHeight(40),
            child: Text(UserHelper.module.libelle!),
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
                    // var nw1 = currentTime.substring(0, 2);
                    // var a1 = currentTime.substring(3, 5);
                    var nw = openTime?.substring(0, 2);
                    var a = openTime?.substring(3, 5);
                    var cnm = closeTime?.substring(0, 2);
                    var cla = closeTime?.substring(3, 5);
                    DateTime openTimeStamp = DateTime(now.year, now.month,
                        now.day, int.parse(nw!), int.parse(a!), 0);
                    DateTime closeTimeStamp = DateTime(now.year, now.month,
                        now.day, int.parse(cnm!), int.parse(cla!), 0);
                    debugPrint('close time // $closeTimeStamp');
                    if ((now.isAtSameMomentAs(openTimeStamp) ||
                        now.isAfter(openTimeStamp)) &&
                        now.isBefore(closeTimeStamp)) {
                      isTodayOpened = true;
                    }
                    print(isTodayOpened);
                    // if(isShopOpen(i.openedAt!, i.closedAt!)){
                    //   isTodayOpened =true;
                    // }
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
                      isTomorrowOpened = true;
                    }
                    log('$isTomorrowOpened');
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
                  UserHelper.isTodayOpen=isTodayOpened;
                  UserHelper.isTomorrowOpen=isTomorrowOpened;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        module: 'delivery',
                        moduleColor: widget.moduleColor,
                        shops: shops[index],
                        isOpenedTomorrow: isTomorrowOpened,
                        isOpenedToday: isTodayOpened,
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
                                      MaterialStateProperty.all(widget
                                          .moduleColor.moduleColorDark)),
                                  onPressed: () {
                                    UserHelper.isTodayOpen=isTodayOpened;
                                    UserHelper.isTomorrowOpen=isTomorrowOpened;
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                          module: UserHelper.module.slug!,
                                          moduleColor: widget.moduleColor,
                                          shops: shops[index],
                                          isOpenedTomorrow: isTomorrowOpened,
                                          isOpenedToday: isTodayOpened,
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
          }),
    );
  }
}
