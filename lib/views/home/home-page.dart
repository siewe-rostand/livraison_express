import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/horaire.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/drawer/home-drawer.dart';
import 'package:livraison_express/views/main/categoryPage.dart';
import 'package:livraison_express/views/main/magasin_page.dart';
import 'package:livraison_express/views/restaurant/restaurant.dart';
import 'package:livraison_express/views/home/select_city.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/city.dart';
import '../../model/day_item.dart';
import '../livraison/commande-coursier.dart';
import 'carousel_with_indicator.dart';
import 'custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.modules, this.city}) : super(key: key);
  final List<Modules>? modules;
  final String? city;
  static String routeName = "/home_screen";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //dop down menu initial value
  String initialDropValue = 'DOUALA';
  String currentTime = '';
  String saveCity = '';
  final logger = Logger();
  double heightBottom = getProportionateScreenHeight(110);
  int _currentIndex = 0;

  final _inactiveColor = Colors.grey;

  City city = City();
  int cityId = 0;
  List<City> cities = [];
  List<String> citiesListString = [];
  AppUser appUser = AppUser();
  AppUser1 appUser1 = AppUser1();
  Modules module = Modules();
  List<Modules> modules = [];
  bool isAvailableInCity = true;
  bool isActive = true;
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  final ScrollController _controller = ScrollController();
  List<String> ville = [];

  @override
  void initState() {
    initView();
    super.initState();
  }

  getModule(
      {required String module,
      required ModuleColor moduleColor,
      required bool isRestaurant}) {
    bool isAvailable = true;
    // print("module ");
    for (Modules modul in modules) {
      List<Shops>? shopsList = modul.shops;
      isAvailableInCity = modul.isActiveInCity == true;
      if (modul.isActiveInCity == false && mounted) {
        setState(() {
          isActive = false;
        });
      }

      if (modul.slug == module) {
        if (modul.isActive == 1) {
          Shops shops = modul.shops!.first;
          UserHelper.shops = shops;
          UserHelper.module = modul;

          if (isRestaurant) {
            ModuleColor moduleColor = ModuleColor(
              moduleColor: redDark,
              moduleColorLight: redDark,
              moduleColorDark: redDark,
            );
            var moduleId = modul.id;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Restaurant(
                      moduleColor: moduleColor,
                      moduleId: moduleId,
                      city: initialDropValue,
                    )));
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryPage(
                            module: module,
                            moduleColor: moduleColor,
                            shops: shops,
                            isOpenedToday: isTodayOpened,
                            isOpenedTomorrow: isTomorrowOpened,
                          )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MagasinPage(
                          moduleColor: moduleColor, shops: shopsList)));
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
    DBHelper dbHelper=DBHelper();
    Future.delayed(Duration.zero,()=>_showDialog(context));
    cities.clear();
    modules.clear();
    pref.remove('cart_item');
    pref.remove('total_price');
    dbHelper.deleteAlls();
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
          UserHelper.module=module;
          modules.add(module);
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
    Navigator.pop(context);
  }

  initView() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List moduleList =
        List<dynamic>.from(jsonDecode(pref.getString('modules')!));
    List cityList = List<dynamic>.from(jsonDecode(pref.getString('cities')!));
    for (var element in moduleList) {
      setState(() {
        modules.add(Modules.fromJson(element));
      });
    }
    for (var element in cityList) {
      setState(() {
        cities.add(City.fromJson(element));
        city = cities.first;
        UserHelper.city=city;
        ville.add(city.name!);
      });
    }
    debugPrint("cities // ${cities[0].toJson()}");
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
  _showDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
      return Dialog(
        child: Image.asset('img/load_modules.gif'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    MainUtils.hideKeyBoard(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff2a5ca8)),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              title: Center(
                  child: Image.asset(
                'img/logo_start.png',
                height: getProportionateScreenHeight(70),
                width: MediaQuery.of(context).size.width,
              )),
              iconTheme: const IconThemeData(color: Color(0xff2a5ca8)),
              backgroundColor: Colors.white,
              actions: [

                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 10,
                    right: 20,
                  ),
                  child: IconButton(
                    icon: Stack(
                      children: [
                          Positioned(
                            right: 1,
                            top: 1,
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              width: 20.0 / 2.5,
                              height: 20.0 / 2.5,
                            ),
                          ),
                        const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.black,
                          size: 30,
                        )
                      ],
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          drawer: const MyHomeDrawer(),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin:  EdgeInsets.fromLTRB(getProportionateScreenWidth(20), getProportionateScreenHeight(20), getProportionateScreenWidth(20), getProportionateScreenHeight(10)),
                    padding:  EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                    height: getProportionateScreenHeight(65),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(4),
                      shape: BoxShape.rectangle
                    ),
                    child:
                    SelectCity(
                      cities: cities,
                      citySelected: (city) {
                        getModulesOnCityChange(
                            cityString: city.name!.toLowerCase(),
                            context: context);
                      },
                    ),
                  ),
                  Positioned(
                    left: getProportionateScreenHeight(50),
                    top: getProportionateScreenHeight(12),
                    child: Container(
                      padding:  EdgeInsets.only(left: getProportionateScreenWidth(10),bottom: getProportionateScreenHeight(10),right: getProportionateScreenWidth(10)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const Text("Votre Localisation"),
                    ),
                  ),
                ],
              ),
              const CarouselWithIndicator(),
              Container(
                height: getProportionateScreenHeight(30),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                child:  Text("Nos Services",
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: getProportionateScreenWidth(22),
                      fontWeight: FontWeight.bold
                  ),),),
              Expanded(
                child: GridView.builder(
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
                                          CommandeCoursier(
                                            shops: modules[index]
                                                .shops![0], moduleColor: moduleColor,
                                          )));
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
          bottomNavigationBar: _buildBottomBar(),

          // Column(
          //   children: [
          //     Expanded(
          //       child: ListView(
          //         padding: const EdgeInsets.only(top: 15),
          //         shrinkWrap: true,
          //         children: [
          //           const Center(
          //               child: Text(
          //                 'services disponible a ',
          //                 style: TextStyle(fontSize: 18,color: primaryColor),
          //               )),
          //           Center(
          //             child: DropdownButton<City>(
          //               value: city,
          //               icon: const Icon(Icons.arrow_drop_down_outlined),
          //               elevation: 16,
          //               style:  const TextStyle(color:primaryColor,fontSize: 18,fontWeight: FontWeight.w500),
          //               onChanged: (City? newValue) async{
          //                 SharedPreferences pref= await SharedPreferences.getInstance();
          //                 setState(() {
          //                   city = newValue!;
          //                   pref.setInt('city_id', newValue.id!);
          //                   pref.setString("city", newValue.name!);
          //                 });
          //               },
          //               items:
          //               cities
          //                   .map<DropdownMenuItem<City>>((City value) {
          //                 return DropdownMenuItem<City>(
          //                   value: value,
          //                   child: Text(value.name!.toUpperCase()),
          //                 );
          //               }).toList(),
          //             ),
          //           ),
          //           Container(
          //             decoration: const BoxDecoration(
          //                 border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
          //             ),
          //             height: getProportionateScreenHeight(125),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: InkWell(
          //                     splashColor: Colors.black87,
          //                     onTap: () {
          //                       for (Modules m in modules) {
          //                         if (m.toString().isNotEmpty &&
          //                             m.slug != null &&
          //                             m.slug == 'delivery') {
          //                           if (m.shops != null &&
          //                               m.shops!.isNotEmpty) {
          //                             ModuleColor moduleColor = ModuleColor(
          //                               moduleColor: primaryColor,
          //                               moduleColorLight: primaryColor,
          //                               moduleColorDark: primaryColor,
          //                             );
          //                             // MySession.saveValue('selected_module', m.shops?.first);
          //                             Navigator.of(context).push(
          //                                 MaterialPageRoute(
          //                                     builder:
          //                                         (BuildContext context) =>
          //                                         Livraison(
          //                                           city:
          //                                           initialDropValue,
          //                                           moduleColor:
          //                                           moduleColor,
          //                                           shops: m.shops![0],
          //                                         )));
          //                           }
          //                         }
          //                       }
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/livraison.png',
          //                             height: getProportionateScreenHeight(80),
          //                             width: getProportionateScreenWidth(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Livraison',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold,
          //                                     color: Color(0xff37474F)),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 const VerticalDivider(thickness: 1.5,),
          //                 Expanded(
          //                   child: InkWell(
          //                     onTap: () {
          //                       // Navigator.of(context).push(MaterialPageRoute(
          //                       //     builder: (BuildContext context) =>
          //                       //         const SuperMarket()));
          //
          //                       ModuleColor color = ModuleColor(
          //                         moduleColor:primaryGreen,
          //                         moduleColorLight: primaryGreen,
          //                         moduleColorDark: primaryGreen,
          //                       );
          //                       getModule(
          //                           module: 'market',
          //                           moduleColor: color,
          //                           isRestaurant: false);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         Image.asset(
          //                           'img/supermarché.png',
          //                           height: getProportionateScreenHeight(80),
          //                         ),
          //                         Container(
          //                             margin: const EdgeInsets.only(top: 5),
          //                             child: const Text(
          //                               'supermarché',
          //                               style: TextStyle(
          //                                   color: Color(0xff37474F),
          //                                   fontSize: 15,
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             decoration: const BoxDecoration(
          //                 border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
          //             ),
          //             height: getProportionateScreenHeight(125),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: InkWell(
          //                     onTap: () {
          //                       ModuleColor moduleColor = ModuleColor(
          //                         moduleColor: redDark,
          //                         moduleColorLight: redDark,
          //                         moduleColorDark:redDark,
          //                       );
          //                       getModule(
          //                           module: 'restaurant',
          //                           moduleColor: moduleColor,
          //                           isRestaurant: true);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/restaurant.png',
          //                             height: getProportionateScreenHeight(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Restaurant',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 const VerticalDivider(
          //                   thickness: 1.5,
          //                 ),
          //                 Expanded(
          //                   child: InkWell(
          //                     onTap: () {
          //                       ModuleColor moduleColor = ModuleColor(
          //                         moduleColor: gazOrange,
          //                         moduleColorLight: gazOrange,
          //                         moduleColorDark: gazOrange,
          //                       );
          //                       getModule(
          //                           module: 'gas',
          //                           moduleColor: moduleColor,
          //                           isRestaurant: false);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/gaz.png',
          //                             height: getProportionateScreenHeight(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Gaz',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             decoration: const BoxDecoration(
          //                 border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
          //             ),
          //             height: getProportionateScreenHeight(125),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       ModuleColor moduleColor = ModuleColor(
          //                         moduleColor:pharmacyGreen,
          //                         moduleColorLight: pharmacyGreen,
          //                         moduleColorDark: pharmacyGreenDark,
          //                       );
          //                       getModule(
          //                           module: 'pharmacy',
          //                           moduleColor: moduleColor,
          //                           isRestaurant: false);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/pharmacie.png',
          //                             height: getProportionateScreenHeight(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Pharmacie',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 const VerticalDivider(
          //                   thickness: 1.5,
          //                 ),
          //                 Expanded(
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       ModuleColor moduleColor = ModuleColor(
          //                         moduleColor: redDark,
          //                         moduleColorLight: redDark,
          //                         moduleColorDark: redDark,
          //                       );
          //                       getModule(
          //                           module: 'librairie',
          //                           moduleColor: moduleColor,
          //                           isRestaurant: false);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/librairie.jpg',
          //                             height: getProportionateScreenHeight(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Librairie',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             decoration: const BoxDecoration(
          //                 border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
          //             ),
          //             height: getProportionateScreenHeight(125),
          //             child:Row(
          //               children: [
          //                 Expanded(
          //                   child: InkWell(
          //                     splashColor: Colors.black87,
          //                     onTap: () {
          //                       print('////');
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: ColorFiltered(
          //                             colorFilter: const ColorFilter.mode(
          //                               Colors.grey,
          //                               BlendMode.saturation,
          //                             ),
          //                             child: Image.asset(
          //                               'img/fleuriste.png',
          //                               height: getProportionateScreenHeight(80),
          //                               fit: BoxFit.contain,
          //                             ),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Fleuriste',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 const VerticalDivider(thickness: 1.5,),
          //                 Expanded(
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       ModuleColor moduleColor = ModuleColor(
          //                         moduleColor:cadeauGold,
          //                         moduleColorLight: cadeauGold,
          //                         moduleColorDark: cadeauGold,
          //                       );
          //                       getModule(
          //                           module: 'gift',
          //                           moduleColor: moduleColor,
          //                           isRestaurant: false);
          //                     },
          //                     child: Column(
          //                       children: [
          //                         ListTile(
          //                           title: Image.asset(
          //                             'img/cadeau.png',
          //                             height: getProportionateScreenHeight(80),
          //                           ),
          //                           subtitle: const Center(
          //                               child: Text(
          //                                 'Cadeau',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          //     SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.8,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Center(
          //           child: Text(
          //         'services disponible a ',
          //         style: TextStyle(fontSize: 18, color: Color(0xff37474F)),
          //       )),
          //       Center(
          //         child: DropdownButton<String>(
          //           value: initialDropValue,
          //           icon: const Icon(Icons.arrow_drop_down_outlined),
          //           elevation: 16,
          //           style: const TextStyle(
          //               color: Color(0xff1A237E),
          //               fontSize: 18,
          //               fontWeight: FontWeight.w500),
          //           onChanged: (String? newValue) {
          //             setState(() {
          //               initialDropValue = newValue!;
          //             });
          //           },
          //           items: quarter.city
          //               .map<DropdownMenuItem<String>>((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(value),
          //             );
          //           }).toList(),
          //         ),
          //       ),
          //       Expanded(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Container(
          //               decoration: const BoxDecoration(
          //                   border: Border(
          //                       bottom: BorderSide(
          //                           color: Colors.black12, width: 1.5))),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: InkWell(
          //                       splashColor: Colors.black87,
          //                       onTap: () {
          //                         for (Modules m in modules) {
          //                           if (m != null &&
          //                               m.slug != null &&
          //                               m.slug == 'delivery') {
          //                             if (m.shops != null &&
          //                                 m.shops!.isNotEmpty) {
          //                               ModuleColor moduleColor = ModuleColor(
          //                                 moduleColor: Color(int.parse(
          //                                     ColorConstant.colorPrimary)),
          //                                 moduleColorLight: Color(int.parse(
          //                                     ColorConstant.colorPrimary)),
          //                                 moduleColorDark: Color(int.parse(
          //                                     ColorConstant.primaryBleuDark)),
          //                               );
          //                               Navigator.of(context).push(
          //                                   MaterialPageRoute(
          //                                       builder:
          //                                           (BuildContext context) =>
          //                                               Livraison(
          //                                                 city:
          //                                                     initialDropValue,
          //                                                 moduleColor:
          //                                                     moduleColor,
          //                                                 shops: m.shops![0],
          //                                               )));
          //                             }
          //                           }
          //                         }
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/livraison.png',
          //                               height: 80,
          //                               width: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Livraison',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Color(0xff37474F)),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   const VerticalDivider(
          //                     thickness: 1.5,
          //                   ),
          //                   Expanded(
          //                     child: InkWell(
          //                       onTap: () {
          //                         // Navigator.of(context).push(MaterialPageRoute(
          //                         //     builder: (BuildContext context) =>
          //                         //         const SuperMarket()));
          //
          //                         ModuleColor color = ModuleColor(
          //                           moduleColor: Color(int.parse(
          //                               ColorConstant.primaryGreen)),
          //                           moduleColorLight: Color(int.parse(
          //                               ColorConstant.primaryGreen)),
          //                           moduleColorDark: Color(
          //                               int.parse(ColorConstant.darkGreen)),
          //                         );
          //                         getModule(
          //                             module: 'market',
          //                             moduleColor: color,
          //                             isRestaurant: false);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           Image.asset(
          //                             'img/supermarché.png',
          //                             height: 80,
          //                           ),
          //                           Container(
          //                               margin: const EdgeInsets.only(top: 5),
          //                               child: const Text(
          //                                 'supermarché',
          //                                 style: TextStyle(
          //                                     color: Color(0xff37474F),
          //                                     fontSize: 15,
          //                                     fontWeight: FontWeight.bold),
          //                               )),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Container(
          //               decoration: const BoxDecoration(
          //                   border: Border(
          //                       bottom: BorderSide(
          //                           color: Colors.black12, width: 1.5))),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: InkWell(
          //                       onTap: () {
          //                         ModuleColor moduleColor = ModuleColor(
          //                           moduleColor: Color(
          //                               int.parse(ColorConstant.redDark)),
          //                           moduleColorLight: Color(
          //                               int.parse(ColorConstant.redDark)),
          //                           moduleColorDark: Color(
          //                               int.parse(ColorConstant.redDarker)),
          //                         );
          //                         getModule(
          //                             module: 'restaurant',
          //                             moduleColor: moduleColor,
          //                             isRestaurant: true);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/restaurant.png',
          //                               height: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Restaurant',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   const VerticalDivider(
          //                     thickness: 1.5,
          //                   ),
          //                   Expanded(
          //                     child: InkWell(
          //                       onTap: () {
          //                         ModuleColor moduleColor = ModuleColor(
          //                           moduleColor: Color(
          //                               int.parse(ColorConstant.gazOrange)),
          //                           moduleColorLight: Color(
          //                               int.parse(ColorConstant.gazOrange)),
          //                           moduleColorDark: Color(int.parse(
          //                               ColorConstant.gazOrangeDark)),
          //                         );
          //                         getModule(
          //                             module: 'gas',
          //                             moduleColor: moduleColor,
          //                             isRestaurant: false);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/gaz.png',
          //                               height: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Gaz',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Container(
          //               decoration: const BoxDecoration(
          //                   border: Border(
          //                       bottom: BorderSide(
          //                           color: Colors.black12, width: 1.5))),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         ModuleColor moduleColor = ModuleColor(
          //                           moduleColor: Color(int.parse(
          //                               ColorConstant.pharmacyGreen)),
          //                           moduleColorLight: Color(int.parse(
          //                               ColorConstant.pharmacyGreen)),
          //                           moduleColorDark: Color(int.parse(
          //                               ColorConstant.pharmacyGreenDark)),
          //                         );
          //                         getModule(
          //                             module: 'pharmacy',
          //                             moduleColor: moduleColor,
          //                             isRestaurant: false);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/pharmacie.png',
          //                               height: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Pharmacie',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   const VerticalDivider(
          //                     thickness: 1.5,
          //                   ),
          //                   Expanded(
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         ModuleColor moduleColor = ModuleColor(
          //                           moduleColor: Color(
          //                               int.parse(ColorConstant.redDark)),
          //                           moduleColorLight: Color(
          //                               int.parse(ColorConstant.redDark)),
          //                           moduleColorDark: Color(
          //                               int.parse(ColorConstant.redDarker)),
          //                         );
          //                         getModule(
          //                             module: 'librairie',
          //                             moduleColor: moduleColor,
          //                             isRestaurant: false);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/librairie.jpg',
          //                               height: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Librairie',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Container(
          //               decoration: const BoxDecoration(
          //                   border: Border(
          //                 bottom:
          //                     BorderSide(color: Colors.black12, width: 1.5),
          //               )),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: InkWell(
          //                       splashColor: Colors.black87,
          //                       onTap: () {
          //                         print('////');
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: ColorFiltered(
          //                               colorFilter: const ColorFilter.mode(
          //                                 Colors.grey,
          //                                 BlendMode.saturation,
          //                               ),
          //                               child: Image.asset(
          //                                 'img/fleuriste.png',
          //                                 height: 80,
          //                                 fit: BoxFit.contain,
          //                               ),
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Fleuriste',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         ModuleColor moduleColor = ModuleColor(
          //                           moduleColor: Color(
          //                               int.parse(ColorConstant.cadeauGold)),
          //                           moduleColorLight: Color(
          //                               int.parse(ColorConstant.cadeauGold)),
          //                           moduleColorDark: Color(int.parse(
          //                               ColorConstant.cadeauGoldDark)),
          //                         );
          //                         getModule(
          //                             module: 'gift',
          //                             moduleColor: moduleColor,
          //                             isRestaurant: false);
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             title: Image.asset(
          //                               'img/cadeau.png',
          //                               height: 80,
          //                             ),
          //                             subtitle: const Center(
          //                                 child: Text(
          //                               'Cadeau',
          //                               style: TextStyle(
          //                                   fontWeight: FontWeight.bold),
          //                             )),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
  Widget _buildBottomBar(){
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.apps),
          title: const Text('Home'),
          activeColor: Colors.green,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.people),
          title: const Text('Users'),
          activeColor: Colors.purpleAccent,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.message),
          title: const Text(
            'Messages ',
          ),
          activeColor: Colors.pink,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.settings),
          title: const Text('Settings'),
          activeColor: Colors.blue,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
