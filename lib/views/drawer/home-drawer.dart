import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/service/fire-auth.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/order_confirmation/command_history.dart';
import 'package:livraison_express/views/main/about.dart';
import 'package:livraison_express/views/login/login.dart';
import 'package:livraison_express/views/main/profil.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:livraison_express/views/widgets/custom_alert_dialog.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/module_color.dart';
import '../../model/user.dart';

class MyHomeDrawer extends StatefulWidget {
  const MyHomeDrawer({Key? key}) : super(key: key);

  @override
  State<MyHomeDrawer> createState() => _MyHomeDrawerState();
}

class _MyHomeDrawerState extends State<MyHomeDrawer> {
  late SharedPreferences sharedPreferences;
  String name= '', tel1= '',email='';

  void showMessage({required String message, required String title}) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'img/icon/svg/ic_warning_yellow.svg',
                  color: const Color(0xffFFAE42),
                ),
                Text(title)
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Réessayer"),
                onPressed: () async {
                  Navigator.of(buildContext).pop();
                  getOrders();
                },
              ),
              TextButton(
                child: const Text("Annuler"),
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
              ),
            ],
          );
        });
  }

  getOrders() async {
    await CourseApi().getOrders().then((value) {
    }).catchError((onError) {
      showMessage(message: onError.toString(), title: 'Alerte');
    });
  }
  initView()async{
    sharedPreferences = await SharedPreferences.getInstance();
    String? userString =sharedPreferences.getString("userData");
    var extractedUserData =json.decode(userString!);
    AppUser1 user1=AppUser1.fromJson(extractedUserData);
    AppUser1? appUser1 = UserHelper.currentUser1??user1;
    setState(() {
      name=appUser1.fullname!;
      tel1=appUser1.telephone??appUser1.email!;

    });
  }
  @override
  void initState() {
    initView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Container(
                      height: getProportionateScreenHeight(186),
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          SvgPicture.asset('img/icon/svg/user_head.svg',height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(80),color: Colors.white,),
                          SizedBox(height: getProportionateScreenWidth(3),),
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: getProportionateScreenWidth(3),),
                          Text(
                            tel1,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    decoration: const BoxDecoration(color: Color(0xff2A5CA8)),
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 2500),
                  ),
                  drawerItem(Icons.home_rounded, 'Accueil', () {
                    Navigator.pop(context);
                  }),
                  drawerItem(Icons.list_rounded, 'Mes Commandes', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CommandLists()));
                  }),
                  drawerItem(Icons.location_city_rounded, 'Mes Adresses', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SelectedFavAddress(isDialog: false)));
                  }),
                  drawerItem(Icons.person_rounded, 'Mon Profil', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const Profile()));
                  }),
                  Builder(builder: (BuildContext context) {
                    return
                      drawerItem(Icons.share_rounded, 'Partager', () {
                        _onShare(context);
                      });
                  }),
                  drawerItem(Icons.power_settings_new, 'Deconnexion', () {
                    UserHelper.userExitDialog(
                        context,
                        false,
                        CustomAlertDialog(
                          svgIcon: "img/icon/svg/smiley_cry.svg",
                          title: "Déconnexion",
                          message:  "Voulez vous vraiment nous quitter?",
                          negativeText: "Quitter",
                          positiveText: 'Annuler',
                          height: SizeConfig.screenHeight!*0.3,
                          width: SizeConfig.screenWidth!*0.4,
                          onContinue: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          onCancel: () async {
                            Navigator.pop(context);
                            SharedPreferences pref = await SharedPreferences
                                .getInstance();
                            pref.clear();
                            Provider.of<CartProvider>(context,listen: false).clears();
                            FireAuth.signOutFromGoogle();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (    BuildContext contex
                                        ) =>
                                    const LoginScreen()));
                          }, ));
                  }),
                ],
              ),
            ),
            Container(
              color: const Color(0xffF3F3F3),
              width: double.infinity,
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                title: const Center(
                    child: Text(
                  'A propos',
                  style: TextStyle(color: Color(0xff263238), fontSize: 16),
                )),
                leading: Image.asset('img/icon/ic_about.png'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const AboutPage()));
                },
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: const [
              //     Icon(Icons.info_outline),
              //     Center(child: Text('A propos')),
              //   ],
              // )
            )
          ],
        ),
      ),
    );
  }

  void _onShare(BuildContext context) async {
    await Share.share(
        "Découvrez quelque chose de cool\n https://play.google.com/store/apps/details?id=com.mcs.livraison_express");
  }
  drawerItem(IconData icon, String title, VoidCallback press) {
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 0))
      ),
      onPressed: press,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700],),
        title: Text(
          title, style: TextStyle(fontSize: getProportionateScreenWidth(15)),),
      ),
    );
  }
}
