import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/model/magasin.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/service/shopService.dart';
import 'package:livraison_express/views/main/categoryPage.dart';
import 'package:livraison_express/views/restaurant/restaurant.dart';

import '../../model/category.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress(
      {Key? key,
      required this.moduleId,
      required this.city,
      required this.latitude,
      required this.longitude,
      required this.moduleColor,
      required this.magasins})
      : super(key: key);
  final int moduleId;
  final String city;
  final double latitude;
  final double longitude;
  final ModuleColor moduleColor;
  final List<Magasin> magasins;

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  TextEditingController controller = TextEditingController();
  bool isVisible = true;
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  List<Category> categoryList = [];
  List<Magasin> magasins = [];

  bool isShopOpen(String openTime, String closeTime) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat.Hm();
    var nw = openTime.substring(0, 2);
    var a = openTime.substring(3, 5);
    var cnm = closeTime.substring(0, 2);
    var cla = closeTime.substring(3, 5);
    DateTime startTime =
        DateTime(now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
    DateTime endTime = DateTime(
        now.year, now.month, now.day, int.parse(cnm), int.parse(cla), 0);
    debugPrint('open $startTime');
    // String today = dateFormat.format(now);
    // DateTime open = DateTime.parse(openTime);
    // DateTime close = DateTime.parse(closeTime);
    return now.isAfter(startTime) &&
        now.isAtSameMomentAs(startTime) &&
        now.isBefore(endTime);
  }

  @override
  void initState() {
    super.initState();

    magasins = widget.magasins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  magasins = [];
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Restaurant(
                              moduleColor: widget.moduleColor,
                              city: widget.city,
                              moduleId: widget.moduleId,
                            )));
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: widget.moduleColor.moduleColor),
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
        body: ListView.builder(
            itemCount: magasins.length,
            itemBuilder: (context, index) {
              var shopId = magasins[index].id;
              String? shopName = magasins[index].nom;
              var shopImage = magasins[index].image;
              if(magasins[index].horaires != null){
                if(magasins[index].horaires!.today != null){
                  List<DayItem>? itemsToday = magasins[index].horaires?.today?.items;
                  for(DayItem i in itemsToday!){
                    try{
                      DateTime now =DateTime.now();
                      String? openTime=i.openedAt;
                      String? closeTime =i.closedAt;
                      // var nw1 = currentTime.substring(0, 2);
                      // var a1 = currentTime.substring(3, 5);
                      var nw = openTime?.substring(0, 2);
                      var a = openTime?.substring(3, 5);
                      var cnm = closeTime?.substring(0, 2);
                      var cla = closeTime?.substring(3, 5);
                      DateTime openTimeStamp = DateTime(
                          now.year, now.month, now.day, int.parse(nw!), int.parse(a!), 0);
                      DateTime closeTimeStamp = DateTime(
                          now.year, now.month, now.day, int.parse(cnm!), int.parse(cla!), 0);
                      debugPrint('close time // $closeTimeStamp');
                        if((now.isAtSameMomentAs(openTimeStamp) || now.isAfter(openTimeStamp)) && now.isBefore(closeTimeStamp)){
                          isTodayOpened =true;
                        }
                        print(isTodayOpened);
                      // if(isShopOpen(i.openedAt!, i.closedAt!)){
                      //   isTodayOpened =true;
                      // }
                    }catch(e){
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
                          shopId: shopId,
                          shopName: shopName!,
                          module: 'delivery',
                          moduleColor: widget.moduleColor,
                          shopImage: shopImage!,)));
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0XFF666666),
                        Color(0XFFFFFFFF),
                        Color(0XFF666666),
                      ])),
                  child: Card(
                    child: Stack(
                      children: [
                        Image.network(
                          magasins[index].image!,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Color(0xffb3000000),
                                    Color(0xff1A000000),
                                    Color(0xffB3000000)
                                  ])),
                              child: SvgPicture.asset(
                                'img/icon/svg/bg_image_magasin_fore.svg',
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                                height: 150,
                              ),
                            );
                          },
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned(
                            top: 12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                    child: Text(
                                  magasins[index].nom!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                )),
                                isTodayOpened ==false
                                    ? Container(
                                  color: Colors.black38,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Fermé'),
                                            Container(
                                              margin: const EdgeInsets.only(left: 15),
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty.all(
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 10)),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              widget.moduleColor
                                                                  .moduleColorDark)),
                                                  onPressed: () async {},
                                                  child: const Text(
                                                    'Précommander',
                                                    style: TextStyle(
                                                        color: Color(0xffF3F3F3)),
                                                  )),
                                            )
                                          ],
                                        ),
                                    )
                                    : Container()
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            })
        // FutureBuilder<List<Magasin>>(
        //   future: ShopServices.getShops(
        //       moduleId: widget.moduleId,
        //       city: widget.city,
        //       latitude: widget.latitude,
        //       longitude: widget.longitude,
        //       inner_radius: 0,
        //       outer_radius: 5),
        //   builder: (context, snapshot) {
        //     if(snapshot.hasData){
        //       List<Magasin> magasins = snapshot.data!;
        //       // debugPrint('get shops snap shot ${magasins}');
        //       for(Magasin magasin in magasins){
        //         if(magasin.horaires != null){
        //           if(magasin.horaires?.today != null) {
        //             List<DayItem>? itemsToday = magasin.horaires?.today?.items;
        //             for(DayItem dayItem in itemsToday!){
        //               debugPrint('get shops snap shot dayItem ${dayItem.openedAt}');
        //               try{
        //                 if(isShopOpen(dayItem.openedAt!, dayItem.closedAt!)){
        //                   isTodayOpened=true;
        //                 }
        //               }catch(e){
        //                 debugPrint('get today time error $e');
        //                 debugPrint('////${isShopOpen(dayItem.openedAt!, dayItem.closedAt!)}');
        //               }
        //             }
        //           }
        //           if(magasin.horaires?.tomorrow !=null){
        //             List<DayItem>? items = magasin.horaires?.tomorrow?.items;
        //             for(DayItem dayItem in items!){
        //               if(dayItem.openedAt !=null && dayItem.closedAt !=null){
        //                 isTomorrowOpened = true;
        //               }
        //             }
        //           }
        //         }
        //       }
        //       return ListView.builder(
        //           itemCount: magasins.length,
        //           itemBuilder: (context, index) {
        //             var shopId =magasins[index].id;
        //             String? shopName =magasins[index].nom;
        //             var shopImage =magasins[index].image;
        //             return InkWell(
        //               onTap: ()async{
        //                 categoryList = await ShopServices.getCategories(shopId: shopId!);
        //                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
        //                 CategoryPage(shopId: shopId, shopName: shopName!, module: 'delivery', moduleColor: widget.moduleColor,
        //                     shopImage: shopImage!, categories: categoryList)));
        //               },
        //               child: Container(
        //                 margin: const EdgeInsets.all(8),
        //                 height: 150,
        //                 width: double.infinity,
        //                 decoration: const BoxDecoration(
        //                     gradient: LinearGradient(
        //                         begin: Alignment.topCenter,
        //                         end: Alignment.bottomCenter,
        //                         colors: [
        //                           Color(0XFF666666),
        //                           Color(0XFFFFFFFF),
        //                           Color(0XFF666666),
        //                         ]
        //                     )
        //                 ),
        //                 child: Card(
        //                   child: Stack(
        //                     children: [
        //                       Image.network(
        //                         magasins[index].image!,
        //                         errorBuilder: (BuildContext context,
        //                             Object exception, StackTrace? stackTrace) {
        //                           return Container(
        //                             width: double.infinity,
        //                             decoration:  const BoxDecoration(
        //                                 gradient: LinearGradient(
        //                                     begin: Alignment.topCenter,
        //                                     end: Alignment.bottomCenter,
        //                                     colors: [
        //                                       Color(0XFFB3000000),
        //                                       Color(0xff1A000000),
        //                                       Color(0xffB3000000)
        //                                     ]
        //                                 )
        //                             ),
        //                             child: SvgPicture.asset(
        //                               'img/icon/svg/bg_image_magasin_fore.svg',
        //                               fit: BoxFit.fitWidth,
        //                               width: double.infinity,
        //                               height: 150,
        //                             ),
        //                           );
        //                         },
        //                         height: 150,
        //                         width: double.infinity,
        //                         fit: BoxFit.fitWidth,
        //                       ),
        //                       Positioned(
        //                           top: 12,
        //                           child: Column(
        //                             mainAxisAlignment: MainAxisAlignment.center,
        //                             mainAxisSize: MainAxisSize.min,
        //                             children: [
        //                               Center(
        //                                   child: Text(
        //                                     magasins[index].nom!,
        //                                     style: const TextStyle(
        //                                         color: Colors.white,
        //                                         fontWeight: FontWeight.bold, fontSize: 24),
        //                                   )),
        //                               isTodayOpened?Row(
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   const Text('Fermé'),
        //                                   ElevatedButton(
        //                                       style: ButtonStyle(
        //                                           backgroundColor: MaterialStateProperty.all(widget.moduleColor.moduleColorLight)),
        //                                       onPressed: () async{
        //                                       },
        //                                       child: const Text('VALIDER LE PANIER'))
        //                                 ],
        //                               ):Container()
        //                             ],
        //                           ))
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             );
        //           });
        //     }else{
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //
        //   },
        // ),
        );
  }
}
