import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/horaire.dart';
import 'package:livraison_express/model/quarter.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/service/main_api_call.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/drawer/home-drawer.dart';
import 'package:livraison_express/views/expand-fab.dart';
import 'package:livraison_express/views/category/categoryPage.dart';
import 'package:livraison_express/views/main/magasin_page.dart';
import 'package:livraison_express/views/restaurant/restaurant.dart';
import 'package:livraison_express/views/home/select_city.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/city.dart';
import '../../model/day_item.dart';
import '../../model/module.dart';
import '../../model/shop.dart';
import '../livraison/commande-coursier.dart';
import '../../provider/cart-provider.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/open_wrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  //dop down menu initial value
  String initialDropValue = 'DOUALA';
  String currentTime = '';
  String saveCity = '';
  bool _scrolling = false, _showFab = true;
  final logger = Logger();
  double heightBottom = getProportionateScreenHeight(110);

  City city = City();
  int cityId = 0;
  List<City> cities = [];
  List<String> citiesListString = [];
  AppUser1 appUser1 = AppUser1();
  Modules module = Modules();
  List<Modules> modules = [];
  bool isAvailableInCity = true;
  bool isActive = true;
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  final ScrollController controller = ScrollController();
  List<String> ville = [];
  List<String> quarters = [];
  DateTime currentBackPressTime = DateTime.now();
  List<Quarter> quarter = [];

  @override
  void initState() {
    initView();
    super.initState();
  }

  void toast({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ));
  }

  Future<bool> _onBackButtonDoubleClicked(BuildContext context) async {
    final difference = DateTime.now().difference(currentBackPressTime);
    currentBackPressTime = DateTime.now();
    if (difference >= const Duration(seconds: 2)) {
      toast(context: context, text: "Cliquez 2 fois pour sortir");
      return false;
    } else {
      SystemNavigator.pop(animated: true);
      return true;
    }
  }

  getModulesOnCityChange(
      {String cityString = "douala", required BuildContext context}) async {
    Future.delayed(Duration.zero, () => _showDialog(context));
    cities.clear();
    modules.clear();
    Provider.of<CartProvider>(context, listen: false).clears();
    String url = "$baseUrl/preload?city=$cityString";
    try {
      final response = await get(Uri.parse(url)).catchError((e) {
        logger.e(e.toString());
      });
      if (response.statusCode == 200) {
        List moduleList = jsonDecode(response.body)['data']['modules'] as List;
        List cityList = jsonDecode(response.body)['data']['cities'] as List;
        if (mounted) {
          setState(() {
            for (var element in moduleList) {
              Modules module = Modules.fromJson(element);
              UserHelper.module = module;
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
      } else {
        Navigator.pop(context);
        showGenDialog(
            context,
            true,
            CustomDialog(
                title: 'Ooooops',
                content: onErrorMessage,
                positiveBtnText: "OK",
                positiveBtnPressed: () {
                  Navigator.of(context).pop();
                }));
        print(response.body);
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onFailureMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e('socket error');
    } on HttpException catch (_) {
      Navigator.pop(context);
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('http error');
    } on FormatException catch (_) {
      Navigator.pop(context);
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));

      print('format error');
    } catch (e) {
      Navigator.pop(context);
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('eer error');
    }
  }

  initView() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List moduleList =
        List<dynamic>.from(jsonDecode(pref.getString('modules')!));
    List cityList = List<dynamic>.from(jsonDecode(pref.getString('cities')!));
    for (var element in moduleList) {
      if (mounted) {
        setState(() {
          modules.add(Modules.fromJson(element));
        });
      }
    }
    for (var element in cityList) {
      if (mounted) {
        setState(() {
          cities.add(City.fromJson(element));
          city = cities.first;
          UserHelper.city = city;
          ville.add(city.name!);
        });
      }
    }
  }

  bool isOpened(List<DayItem>? itemsToday) {
    bool juge = false;
    if (itemsToday!.isNotEmpty) {
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
            if (mounted) {
              setState(() {
                isTodayOpened = true;
                juge = true;
              });
            }
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

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Image.asset('img/load_modules.gif'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MainUtils.hideKeyBoard(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              title: Center(
                  child: Image.asset(
                'img/logo_start.png',
                height: getProportionateScreenHeight(70),
                width: double.infinity,
              )),
              iconTheme: const IconThemeData(color: primaryColor),
              backgroundColor: Colors.white.withOpacity(.3),
              shadowColor: const Color(0xff4084baff),
              elevation: 40,
              actions: [
                IconButton(
                    onPressed: () {
                      getModulesOnCityChange(context: context);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          ),
          drawer: const MyHomeDrawer(),
          body: WillPopScope(
            onWillPop: () => _onBackButtonDoubleClicked(context),
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: const ScrollBehavior()
                    ..buildOverscrollIndicator(
                        context,
                        Container(),
                        ScrollableDetails(
                            direction: AxisDirection.down,
                            controller: controller)),
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      final ScrollDirection direction = notification.direction;
                      setState(() {
                        if (direction == ScrollDirection.reverse) {
                          _showFab = false;
                        } else if (direction == ScrollDirection.forward) {
                          _showFab = true;
                        }
                      });
                      return true;
                    },
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
                              child: GridView.builder(
                                  controller: controller,
                                  shrinkWrap: true,
                                  itemCount: modules.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: SizeConfig
                                                  .screenWidth! /
                                              (SizeConfig.screenHeight! / 2.5)),
                                  itemBuilder: (context, index) {
                                    isAvailableInCity =
                                        modules[index].isActiveInCity!;
                                    List<Shops> shopsList =
                                        modules[index].shops!;
                                    return OpenContainerWrapper(
                                      transitionType:
                                          ContainerTransitionType.fade,
                                      nextPage: modules[index].slug ==
                                              'delivery'
                                          ? const CommandeCoursier()
                                          : modules[index].slug == 'restaurant'
                                              ? const Restaurant()
                                              : (shopsList.length == 2 &&
                                                      shopsList[0]
                                                          .toString()
                                                          .isNotEmpty &&
                                                      shopsList[0].horaires !=
                                                          null &&
                                                      shopsList[0]
                                                              .horaires
                                                              ?.today !=
                                                          null &&
                                                      isOpened(shopsList[0]
                                                          .horaires
                                                          ?.today!
                                                          .items))
                                                  ? const CategoryPage()
                                                  : const MagasinPage(),
                                      closedBuilder: (BuildContext _,
                                          VoidCallback openContainer) {
                                        return InkWellOverlay(
                                            onTap: () {
                                              if (modules[index]
                                                      .isActiveInCity ==
                                                  true) {
                                                UserHelper.module =
                                                    modules[index];
                                                if (modules[index].slug ==
                                                    'delivery') {
                                                  UserHelper.shops =
                                                      modules[index]
                                                          .shops!
                                                          .first;
                                                }
                                                openContainer();
                                              } else {
                                                showToast(
                                                    context: context,
                                                    text:
                                                        "Service Pas disponible dans cette ville",
                                                    iconData: Icons.close,
                                                    color: Colors.red);
                                              }
                                            },
                                            child: item(
                                                modules[index],
                                                modules[index]
                                                    .isActiveInCity!));
                                      },
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
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    offset: _showFab ? Offset.zero : const Offset(0, 2),
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/semi_circle.png"),
                                fit: BoxFit.cover)),
                        height: heightBottom,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: getProportionateScreenHeight(10)),
                            const FancyFab(),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget item(Modules module, bool isAvailableInCity) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(color: grey40),
              bottom: BorderSide(color: grey40),
              top: BorderSide(color: grey40))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: getProportionateScreenHeight(80),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(module.image!),
                    colorFilter: isAvailableInCity == false
                        ? const ColorFilter.mode(
                            Colors.white, BlendMode.saturation)
                        : null)),
          ),
          Text(
            module.libelle!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          )
        ],
      ),
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
