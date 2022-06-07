
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/service/main_api_call.dart';
import 'package:livraison_express/views/home-drawer.dart';
import 'package:livraison_express/views/livraison/livraison.dart';
import 'package:livraison_express/views/main/categoryPage.dart';
import 'package:livraison_express/views/restaurant/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/_module.dart';
import '../model/category.dart';
import '../model/city.dart';
import '../model/day_item.dart';
import '../model/quartier.dart';
import 'expand-fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.modules, this.cities, this.city}) : super(key: key);
  final List<Modules>? modules;
  final List<City>? cities;
  final String? city;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //dop down menu initial value
  String initialDropValue='';
  String currentTime = '';
  String saveCity='';

  bool _view = true;
  City city=City();
  int cityId=0;
  List<City> cities =[];
  List<String> citiesListString=[];
  AppUser appUser = AppUser();
  AppUser1 appUser1 = AppUser1();
  Module module = Module();
  List<Modules> modules = [];
  List<Modules> moduleList = [];
  List<Category> categoryList = [];
  bool isAvailableInCity = true;
  bool? isActive;

  @override
  void initState() {
    _view = true;
    initView();
    // getModule();
    // initCardView();
    // print(token);
    super.initState();
  }
  getUserInfo(bool fromFb) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    appUser1 = await ApiAuthService.getUser();
    debugPrint("login user ${appUser1.emailVerifiedAt}");
    String fullName = appUser.fullName ?? '';
    String phone = appUser.telephone ?? '';
    String? phoneVerifiedAt =appUser1.phoneVerifiedAt;
    String? emailVerifiedAt =appUser1.emailVerifiedAt;
    if(!fromFb && phoneVerifiedAt!.isNotEmpty && emailVerifiedAt!.isNotEmpty){

    }
  }
  showCityMenu()async{
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    for (int i=0; i<cities.length;i++){
      City c = cities[i];
      citiesListString.add(c.name!.toUpperCase());
    }
  }
  initCardView() async {
   await MainApi.getModuleConfigs(city: initialDropValue).then((response){
     var body=json.decode(response.body);
     var rest = body['data']['modules'] as List;
     moduleList= rest.map<Modules>((json) =>Modules.fromJson(json)).toList();
   });
    for (Modules modul in moduleList) {
      isAvailableInCity = modul.isActiveInCity!;
      debugPrint('dd ${modul.isActiveInCity}  // ${modul.slug}');
    }
  }

  getModule(
      {required String module,
      required ModuleColor moduleColor,
      required bool isRestaurant}) {
    bool isAvailable = true;
    // print("module ");
    var moc = widget.modules;
    for (Modules modul in modules) {
      List<Shops>? shopsList = modul.shops;
      isAvailableInCity = modul.isActiveInCity!;

      if (modul.slug == module) {
        if (modul.isActive == 1) {
          var selectedModule = modul.slug;
          var moduleColors = modul.moduleColor;

          if (isRestaurant) {
            // categoryList = await ShopServices.getCategories(shopId: shopsList![0].id!);

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
                if (shopsList.length == 1 &&
                    shopsList[0] != null &&
                    shopsList[0].horaires != null &&
                    shopsList[0].horaires?.today != null &&
                    isOpened(shopsList[0].horaires?.today?.items)) {
                  debugPrint('from home page ${shopsList[0].slug}');
                  Shops shops = modul.shops!.first;

                  var shopId = shops.id;
                  var shopName = shops.nom;
                  var shopImage = shops.image;
                  // categoryList = await ShopServices.getCategories(shopId: shopId!);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        module: module,
                        moduleColor: moduleColor,
                        shopId: shopId!,
                        shopImage: shopImage!,
                        shopName: shopName!,
                      )));
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

  initView() async{
    modules = widget.modules!;
    SharedPreferences pref= await SharedPreferences.getInstance();
    saveCity=pref.getString('cities')!;
    var moduleString=pref.getString('modules');
    final extrD=json.decode(moduleString!);
    print(extrD.runtimeType);

    cities = widget.cities!;
    List cb = json.decode(saveCity);
    for(int i=0;i<cities.length;i++){
      City c=cities[i];
      City ic=cities[0];
      var name =c.name?.toUpperCase();
      citiesListString.add(name!);
      setState(() {
        initialDropValue =ic.name!.toUpperCase();
        cityId=ic.id!;
        city=ic;
      });
      pref.setInt('cityId', cityId);
      debugPrint('city $cityId name $citiesListString');
    }
    pref.setString('city', initialDropValue);
  }
  bool isOpened(List<DayItem>? items) {
    DateFormat dateFormat = DateFormat.Hm();
    bool juge = false;

    if (items!.isNotEmpty) {
      for (DayItem item in items) {
        String? openTime = item.openedAt;
        String? closeTime = item.closedAt;
        if (openTime != null &&
            openTime.isNotEmpty &&
            closeTime != null &&
            closeTime.isNotEmpty) {
          DateTime now = DateTime.now();
          int hr = now.hour;
          int min = now.minute;
          currentTime = dateFormat.format(now);
          try {
            var currentTimeStamp = dateFormat.parse(currentTime);
            var openTimeStamp = dateFormat.parse(openTime);
            var closeTimeStamp = dateFormat.parse(closeTime);
            if (currentTimeStamp.isAfter(openTimeStamp) &&
                currentTimeStamp.isBefore(closeTimeStamp)) {
              juge = true;
              break;
            }
          } catch (e) {
            debugPrint('is opened error // $e');
          }
        }
      }
    }
    return juge;
  }

  getCurrentTime() {
    DateTime now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xff2a5ca8)),
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("img/index_page.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                title: Center(
                    child: Image.asset(
                  'img/logo_start.png',
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                )),
                iconTheme: const IconThemeData(color: Color(0xff2a5ca8)),
                backgroundColor: Colors.white,
              ),
            ),
            drawer: const MyHomeDrawer(),
            body:
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Center(
                //         child: Text(
                //           'services disponible a ',
                //           style: TextStyle(fontSize: 18, color: Color(0xff37474F)),
                //         )),
                //     Center(
                //       child: DropdownButton<String>(
                //         value: initialDropValue,
                //         icon: const Icon(Icons.arrow_drop_down_outlined),
                //         elevation: 16,
                //         style: const TextStyle(
                //             color: Color(0xff1A237E),
                //             fontSize: 18,
                //             fontWeight: FontWeight.w500),
                //         onChanged: (String? newValue) {
                //           setState(() {
                //             initialDropValue = newValue!;
                //           });
                //         },
                //         items:
                //         quarter.city.map<DropdownMenuItem<String>>((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child: Text(value),
                //           );
                //         }).toList(),
                //       ),
                //     ),
                //     Expanded(
                //       child: GridView.builder(
                //         shrinkWrap: true,
                //         itemCount: widget.modules?.length,
                //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                //           itemBuilder: (context,index){
                //         return Expanded(
                //           child: Container(
                //             margin: EdgeInsets.zero,
                //             decoration: const BoxDecoration(
                //               border: Border(
                //                 bottom: BorderSide()
                //               )
                //             ),
                //             height: 100,
                //             child: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Image.network(widget.modules![index].image!,height: 80,),
                //                 Text(widget.modules![index].libelle!)
                //               ],
                //             ),
                //           ),
                //         );
                //       }),
                //     ),
                //   ],
                // ),
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 15),
                    shrinkWrap: true,
                    children: [
                       Center(
                          child: Text(
                            'services disponible a ',
                            style: TextStyle(fontSize: 18,color: Color(int.parse(ColorConstant.colorPrimary))),
                          )),
                      Center(
                        child: DropdownButton<City>(
                          value: city,
                          icon: const Icon(Icons.arrow_drop_down_outlined),
                          elevation: 16,
                          style:  TextStyle(color: Color(int.parse(ColorConstant.colorPrimary)),fontSize: 18,fontWeight: FontWeight.w500),
                          onChanged: (City? newValue) async{
                            SharedPreferences pref= await SharedPreferences.getInstance();
                            setState(() {
                              city = newValue!;
                              pref.setInt('city_id', newValue.id!);
                              var id= pref.getInt('city_id');
                              print('city_id $id ?? $newValue');
                            });
                          },
                          items:
                          cities
                              .map<DropdownMenuItem<City>>((City value) {
                            return DropdownMenuItem<City>(
                              value: value,
                              child: Text(value.name!.toUpperCase()),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        height: 110,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.black87,
                                onTap: () {
                                  for (Modules m in modules) {
                                    if (m.toString().isNotEmpty &&
                                        m.slug != null &&
                                        m.slug == 'delivery') {
                                      if (m.shops != null &&
                                          m.shops!.isNotEmpty) {
                                        ModuleColor moduleColor = ModuleColor(
                                          moduleColor: Color(int.parse(
                                              ColorConstant.colorPrimary)),
                                          moduleColorLight: Color(int.parse(
                                              ColorConstant.colorPrimary)),
                                          moduleColorDark: Color(int.parse(
                                              ColorConstant.primaryBleuDark)),
                                        );
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                    Livraison(
                                                      city:
                                                      initialDropValue,
                                                      moduleColor:
                                                      moduleColor,
                                                      shops: m.shops![0],
                                                    )));
                                      }
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/livraison.png',
                                        height: 80,
                                        width: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Livraison',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff37474F)),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(thickness: 1.5,),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         const SuperMarket()));

                                  ModuleColor color = ModuleColor(
                                    moduleColor: Color(int.parse(
                                        ColorConstant.primaryGreen)),
                                    moduleColorLight: Color(int.parse(
                                        ColorConstant.primaryGreen)),
                                    moduleColorDark: Color(
                                        int.parse(ColorConstant.darkGreen)),
                                  );
                                  getModule(
                                      module: 'market',
                                      moduleColor: color,
                                      isRestaurant: false);
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'img/supermarché.png',
                                      height: 80,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: const Text(
                                          'supermarché',
                                          style: TextStyle(
                                              color: Color(0xff37474F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        height: 110,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  ModuleColor moduleColor = ModuleColor(
                                    moduleColor: Color(
                                        int.parse(ColorConstant.redDark)),
                                    moduleColorLight: Color(
                                        int.parse(ColorConstant.redDark)),
                                    moduleColorDark: Color(
                                        int.parse(ColorConstant.redDarker)),
                                  );
                                  getModule(
                                      module: 'restaurant',
                                      moduleColor: moduleColor,
                                      isRestaurant: true);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/restaurant.png',
                                        height: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Restaurant',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1.5,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  ModuleColor moduleColor = ModuleColor(
                                    moduleColor: Color(
                                        int.parse(ColorConstant.gazOrange)),
                                    moduleColorLight: Color(
                                        int.parse(ColorConstant.gazOrange)),
                                    moduleColorDark: Color(int.parse(
                                        ColorConstant.gazOrangeDark)),
                                  );
                                  getModule(
                                      module: 'gas',
                                      moduleColor: moduleColor,
                                      isRestaurant: false);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/gaz.png',
                                        height: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Gaz',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        height: 110,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ModuleColor moduleColor = ModuleColor(
                                    moduleColor: Color(int.parse(
                                        ColorConstant.pharmacyGreen)),
                                    moduleColorLight: Color(int.parse(
                                        ColorConstant.pharmacyGreen)),
                                    moduleColorDark: Color(int.parse(
                                        ColorConstant.pharmacyGreenDark)),
                                  );
                                  getModule(
                                      module: 'pharmacy',
                                      moduleColor: moduleColor,
                                      isRestaurant: false);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/pharmacie.png',
                                        height: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Pharmacie',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1.5,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ModuleColor moduleColor = ModuleColor(
                                    moduleColor: Color(
                                        int.parse(ColorConstant.redDark)),
                                    moduleColorLight: Color(
                                        int.parse(ColorConstant.redDark)),
                                    moduleColorDark: Color(
                                        int.parse(ColorConstant.redDarker)),
                                  );
                                  getModule(
                                      module: 'librairie',
                                      moduleColor: moduleColor,
                                      isRestaurant: false);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/librairie.jpg',
                                        height: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Librairie',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                        ),
                        height: 110,
                        child:Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.black87,
                                onTap: () {
                                  print('////');
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        ),
                                        child: Image.asset(
                                          'img/fleuriste.png',
                                          height: 80,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Fleuriste',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(thickness: 1.5,),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ModuleColor moduleColor = ModuleColor(
                                    moduleColor: Color(
                                        int.parse(ColorConstant.cadeauGold)),
                                    moduleColorLight: Color(
                                        int.parse(ColorConstant.cadeauGold)),
                                    moduleColorDark: Color(int.parse(
                                        ColorConstant.cadeauGoldDark)),
                                  );
                                  getModule(
                                      module: 'gift',
                                      moduleColor: moduleColor,
                                      isRestaurant: false);
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Image.asset(
                                        'img/cadeau.png',
                                        height: 80,
                                      ),
                                      subtitle: const Center(
                                          child: Text(
                                            'Cadeau',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 75,
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
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

            floatingActionButton: const FancyFab(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    );
  }
}
