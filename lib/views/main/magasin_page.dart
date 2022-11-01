

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/views/main/categoryPage.dart';
import 'package:logger/logger.dart';

import '../../constant/color-constant.dart';
import '../../model/category.dart';
import '../../model/day_item.dart';
import '../../model/shop.dart';
import '../../utils/size_config.dart';
import '../widgets/open_wrapper.dart';

class MagasinPage extends StatefulWidget {
  const MagasinPage({Key? key}) : super(key: key);

  @override
  State<MagasinPage> createState() => _MagasinPageState();
}

class _MagasinPageState extends State<MagasinPage> {
  List<Shops> shops = [];
  List<Category> categoryList = [];
  bool isTodayOpened = false;
  bool isTomorrowOpened = false;
  Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    shops = UserHelper.module.shops!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor:
              UserHelper.getColor(),),
          backgroundColor: UserHelper.getColor(),
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
            Shops shop = shops[index];
            if (shop.horaires != null) {
              if (shop.horaires!.today != null) {
                List<DayItem>? itemsToday =
                    shop.horaires?.today?.items;
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
                      isTodayOpened = true;
                    }
                  } catch (e) {
                    logger.e('shop get time error $e');
                  }
                }
              }
              if (shop.horaires!.tomorrow != null) {
                List<DayItem>? itemsToday =
                    shop.horaires?.tomorrow?.items;
                for (DayItem i in itemsToday!) {
                  try {
                    String? openTime = i.openedAt;
                    String? closeTime = i.closedAt;
                    if (openTime!.isNotEmpty && closeTime!.isNotEmpty) {
                      isTomorrowOpened = true;
                    }
                  } catch (e) {
                    logger.e('shop get time error $e');
                  }
                }
              }
            }
            return OpenContainerWrapper(
              transitionType: ContainerTransitionType.fade,
              nextPage: const CategoryPage(),
              closedBuilder: (BuildContext _, VoidCallback openContainer){
                return InkWellOverlay(
                  onTap: (){
                    if(isTodayOpened){
                      UserHelper.shops = shop;
                      openContainer();
                    }
                  },
                  child: item(shop, isTodayOpened, isTomorrowOpened, context),
                );
              },
            );
          }),
    );
  }

  Widget item(Shops shop, bool isTodayOpened, bool isTomorrowOpened, context){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(4),
              horizontal: getProportionateScreenHeight(8)
          ),
          height: getProportionateScreenHeight(200),
          width: SizeConfig.screenWidth,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            elevation: 8.0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: kShopBackgroundGradient
              ),
              child: Container(
                height: getProportionateScreenHeight(200),
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(shop.image!),
                    colorFilter: !isTodayOpened
                        ? const ColorFilter.mode(
                        Colors.white,
                        BlendMode.saturation
                    )
                        : null,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: kShopForegroundGradient
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
                    child: Column(
                      children: [
                        const Expanded(child: SizedBox(),),
                        Text(
                          shop.nom!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(20)
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10),)
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
                    horizontal: getProportionateScreenHeight(19.5)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: kOverlay40,
                child: Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: (){
                        UserHelper.shops = shop;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CategoryPage()));
                      },
                      child: const Text(
                        'Précommander',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}
