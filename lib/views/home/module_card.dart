import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:livraison_express/views/widgets/progress_bar.dart';
import 'package:livraison_express/views/home/select_city.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color-constant.dart';
import '../../data/local_db/db-helper.dart';
import '../../data/user_helper.dart';
import '../../model/city.dart';
import '../../model/day_item.dart';
import '../../model/horaire.dart';
import '../../model/module.dart';
import '../../model/module_color.dart';
import '../../model/shop.dart';
import '../../service/auth_service.dart';
import '../../utils/size_config.dart';
import '../expand-fab.dart';
import '../livraison/commande-coursier.dart';
import 'home-page.dart';
import '../category/categoryPage.dart';
import '../main/magasin_page.dart';
import '../restaurant/restaurant.dart';

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.modules, required this.isAvailableInCity, required this.onTap}) : super(key: key);
  final Modules modules;
  final bool isAvailableInCity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.5),
              left: BorderSide(
                  color: Colors.black12,
                  width: 1.5))),
      height:
      getProportionateScreenHeight(80),
      child: InkWell(
        splashColor: Colors.black87,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height:
              getProportionateScreenHeight(
                  80),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                      CachedNetworkImageProvider(
                          modules
                              .image!),
                      colorFilter:
                      isAvailableInCity ==
                          false
                          ? const ColorFilter
                          .mode(
                          Colors
                              .white,
                          BlendMode
                              .saturation)
                          : null)),
            ),
            Text(
              modules.libelle!,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class ModuleCard extends StatefulWidget {
  const ModuleCard({Key? key, required this.modules, required this.cities}) : super(key: key);
  final List<Modules> modules;
  final List<City> cities;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  final ScrollController _controller = ScrollController();
  bool _loading = false;
  bool _scrolling = false;
  double heightBottom = getProportionateScreenHeight(110);
  bool isAvailableInCity = true;
  bool isActive = true;
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  String city = "DOUALA";
  List<City> cities=[];
  List<Modules> modules=[];

  init()async{
    if(widget.cities.isNotEmpty)city = widget.cities[0].name!;
    city =await UserHelper.getCity();
    cities=widget.cities;
    modules=widget.modules;
  }
  getModule(
      {required String module,
        required ModuleColor moduleColor,
        required bool isRestaurant}) {
    bool isAvailable = true;
    // print("module ");
    for (Modules modul in widget.modules) {
      List<Shops>? shopsList = modul.shops;
      isAvailableInCity = modul.isActiveInCity == true;
      if (modul.isActiveInCity == false) {
        setState(() {
          isActive = false;
        });
      }

      if (modul.slug == module) {
        if (modul.isActive == 1) {
          Shops shops = modul.shops!.first;
          UserHelper.shops=shops;
          UserHelper.module=modul;

          if (isRestaurant) {
            // categoryList = await ShopServices.getCategories(shopId: shopsList![0].id!);
            var moduleId = modul.id;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Restaurant()));
          } else {
            try {
              if (shopsList!.isNotEmpty) {
                print("++++--=${isOpened(shopsList[0].horaires!)}");
                if (shopsList.length == 1 &&
                    shopsList[0].toString().isNotEmpty &&
                    shopsList[0].horaires != null &&
                    shopsList[0].horaires?.today != null &&
                    isOpened1(shopsList[0].horaires?.today!.items)) {
                  debugPrint('from home page ${shopsList[0].slug}');

                  final shopData = json.encode(shops);
                  // pref.setString('magasin', shopData);
                  // MySession.saveValue('magasin', shopData);
                  // categoryList = await ShopServices.getCategories(shopId: shopId!);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CategoryPage(
                      )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MagasinPage()));
                }
              } else {
                isAvailable = false;
              }
            } catch (e) {
              debugPrint('error $e');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      'Ce service est indisponnible pour l\'instant. Veuillez contactez le service client.'),
                ),
              );
            }
          }
          if (isAvailable) {
            isAvailableInCity = true;
            const HomePage();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Ce service est momentanément indisponible.'),
              ),
            );
          }
        }
      }

      // debugPrint('shop length${shopsList?.length}');
    }
  }

  getModulesOnCityChange({String cityString = "douala",required BuildContext context}) async {
    SharedPreferences pref = await SharedPreferences
        .getInstance();
    DBHelper1 dbHelper=DBHelper1();
    _loading = true;
    cities.clear();
    modules.clear();
    pref.remove('cart_item');
    pref.remove('total_price');
    dbHelper.deleteAll();
    String url = "$baseUrl/modules?city=$cityString";
    final response = await get(Uri.parse(url)).catchError((e) {
      print(e.toString());
    });
    if (response.statusCode == 200) {
      List moduleList = jsonDecode(response.body)['data']['modules'] as List;
      List cityList = jsonDecode(response.body)['data']['cities'] as List;
      setState(() {
        for (var element in moduleList) {
          Modules module = Modules.fromJson(element);
          modules.add(module);
          UserHelper.module=module;
        }
        for (var element in cityList) {
          City city = City.fromJson(element);
          cities.add(city);
          city = cities.first;
          if (city.name?.toLowerCase() == cityString.toLowerCase()) {
            UserHelper.city = city;
          }
        }
      });
    }
    _loading = false;
  }


  bool isOpened1(List<DayItem>? itemsToday) {
    bool juge = false;
    if(itemsToday!.isNotEmpty) {
      for (DayItem i in itemsToday) {
        try {
          DateTime now = DateTime.now();
          String? openTime = i.openedAt;
          String? closeTime = i.closedAt;
          var nw = openTime?.substring(0, 2);
          var a = openTime?.substring(3, 5);
          var cnm = closeTime?.substring(0, 2);
          var cla = closeTime?.substring(3, 5);
          DateTime openTimeStamp = DateTime(
              now.year, now.month, now.day, int.parse(nw!), int.parse(a!), 0);
          DateTime closeTimeStamp = DateTime(now.year, now.month, now.day,
              int.parse(cnm!), int.parse(cla!), 0);
          debugPrint('close time // $closeTimeStamp');
          if ((now.isAtSameMomentAs(openTimeStamp) ||
              now.isAfter(openTimeStamp)) &&
              now.isBefore(closeTimeStamp)) {
            setState(() {
              isTodayOpened = true;
              juge = true;
            });
            break;
          }
          log('from home page today', error: isTodayOpened.toString());
        } catch (e) {
          debugPrint('shop get time error $e');
        }
      }
    }
    return juge;
  }
  bool isOpened(Horaires horaires) {
    bool juge = false;
    if(horaires.toString().isNotEmpty){
      if(horaires.today!=null){
        List<DayItem>? itemsToday =
            horaires.today?.items;
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
            debugPrint('close time // $closeTimeStamp');
            if ((now.isAtSameMomentAs(openTimeStamp) ||
                now.isAfter(openTimeStamp)) &&
                now.isBefore(closeTimeStamp)) {
              isTodayOpened = true;
              juge=true;
              break;
            }
            log('from home page today',error: isTodayOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
      if (horaires.tomorrow != null) {
        List<DayItem>? itemsToday =
            horaires.tomorrow?.items;
        for (DayItem i in itemsToday!) {
          try {
            String? openTime = i.openedAt;
            String? closeTime = i.closedAt;
            if (openTime!.isNotEmpty && closeTime!.isNotEmpty) {
              isTomorrowOpened = true;
              juge=true;
              break;
            }
            log('from home page',error: isTomorrowOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
    }
    return juge;
  }
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollConfiguration(
          behavior: const ScrollBehavior()
            ..buildOverscrollIndicator(
                context,
                Stack(),
                ScrollableDetails(
                    direction: AxisDirection.down,
                    controller: _controller)),
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                BoxConstraints(maxHeight: SizeConfig.screenHeight!),
                child: Column(
                  children: [
                    SelectCity(
                      cities: cities,
                      citySelected: (city) {
                        getModulesOnCityChange(
                            cityString: city.name!.toLowerCase(),
                            context: context);
                      },
                    ),
                    Expanded(
                      child: _loading
                          ?  const Center(
                        child: ProgressBar(),
                      )
                          : GridView.builder(
                          controller: _controller,
                          shrinkWrap: true,
                          itemCount: modules.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                              SizeConfig.screenWidth! /
                                  (SizeConfig.screenHeight! /
                                      2.5)),
                          itemBuilder: (context, index) {
                            isAvailableInCity =
                            modules[index].isActiveInCity!;
                            return Container(
                              margin: EdgeInsets.zero,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black12,
                                          width: 1.5),
                                      left: BorderSide(
                                          color: Colors.black12,
                                          width: 1.5))),
                              height:
                              getProportionateScreenHeight(80),
                              child: InkWell(
                                splashColor: Colors.black87,
                                onTap: () {
                                  if (modules[index].slug ==
                                      'delivery') {
                                    UserHelper.module =
                                    modules[index];
                                    UserHelper.shops =
                                        modules[index].shops!.first;
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: primaryColor,
                                      moduleColorLight: primaryColor,
                                      moduleColorDark: primaryColor,
                                    );
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext
                                            context) =>
                                            const CommandeCoursier()));
                                  }
                                  if (modules[index].slug ==
                                      'market') {
                                    UserHelper.module =
                                    modules[index];
                                    UserHelper.shops =
                                        modules[index].shops!.first;
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: primaryGreen,
                                      moduleColorLight: darkGreen,
                                      moduleColorDark: pharmacyGreenDark,
                                    );
                                    getModule(
                                        module:modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: false);
                                  }
                                  if (modules[index].slug == 'gas') {
                                    UserHelper.module =
                                    modules[index];
                                    UserHelper.shops =
                                        modules[index].shops!.first;
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: gazOrange,
                                      moduleColorLight: gazOrange,
                                      moduleColorDark: gazOrange,
                                    );
                                    getModule(
                                        module: modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: false);
                                  }
                                  if (modules[index].slug ==
                                      'pharmacy') {
                                    UserHelper.module =
                                    modules[index];
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: pharmacyGreen,
                                      moduleColorLight: pharmacyGreen,
                                      moduleColorDark:
                                      pharmacyGreenDark,
                                    );
                                    getModule(
                                        module: modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: false);
                                  }
                                  if (modules[index].slug ==
                                      'librairie') {
                                    UserHelper.module =
                                    modules[index];
                                    print('mod col ${modules[index].moduleColor}');
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: libModCol,
                                      moduleColorLight: libModCol,
                                      moduleColorDark: libModCol,
                                    );
                                    getModule(
                                        module: modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: false);
                                  }
                                  if (modules[index].slug == 'gift') {
                                    UserHelper.module =
                                    modules[index];
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: cadeauGold,
                                      moduleColorLight: cadeauGold,
                                      moduleColorDark: cadeauGold,
                                    );
                                    getModule(
                                        module: modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: false);
                                  }
                                  if (modules[index].slug ==
                                      'restaurant') {
                                    UserHelper.module =
                                    modules[index];
                                    ModuleColor moduleColor =
                                    ModuleColor(
                                      moduleColor: redDark,
                                      moduleColorLight: redDark,
                                      moduleColorDark: redDark,
                                    );
                                    getModule(
                                        module: modules[index].slug!,
                                        moduleColor: moduleColor,
                                        isRestaurant: true);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height:
                                      getProportionateScreenHeight(
                                          80),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                              CachedNetworkImageProvider(
                                                  modules[index]
                                                      .image!),
                                              colorFilter:
                                              isAvailableInCity ==
                                                  false
                                                  ? const ColorFilter
                                                  .mode(
                                                  Colors
                                                      .white,
                                                  BlendMode
                                                      .saturation)
                                                  : null)),
                                    ),
                                    Text(
                                      modules[index].libelle!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/semi_circle.png"),
                      fit: BoxFit.cover)),
              height: heightBottom,
              child: Visibility(
                visible: !_scrolling,
                child: ListView(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    const FancyFab(),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        if (notification.direction == ScrollDirection.forward) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              heightBottom = getProportionateScreenHeight(110);
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  _scrolling = false;
                });
              });
            });
          });
        } else if (notification.direction == ScrollDirection.reverse) {
          setState(() {
            _scrolling = true;
            heightBottom = 0;
          });
        }
      }
    }
    return false;
  }
}