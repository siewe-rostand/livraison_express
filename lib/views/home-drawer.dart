import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/service/fire-auth.dart';
import 'package:livraison_express/views/home-page.dart';
import 'package:livraison_express/views/main/about.dart';
import 'package:livraison_express/views/main/login.dart';
import 'package:livraison_express/views/main/profil.dart';
import 'package:share_plus/share_plus.dart';

class MyHomeDrawer extends StatefulWidget {
  const MyHomeDrawer({Key? key}) : super(key: key);

  @override
  State<MyHomeDrawer> createState() => _MyHomeDrawerState();
}

class _MyHomeDrawerState extends State<MyHomeDrawer> {
  bool _isProcessing = false;

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
    await CourseApi.getOrders().then((value) {
      var body = json.decode(value.body);
      var res = body['data'];
      debugPrint('commends // $res');
    }).catchError((onError) {
      showMessage(message: onError.toString(), title: 'Alerte');
    });
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
                    child: SizedBox(
                      height: 176,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 80,
                            color: Colors.white,
                          ),
                          Text(
                            '678312256',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'Rostand',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    decoration: const BoxDecoration(color: Color(0xff2A5CA8)),
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 2500),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const HomePage()));
                    },
                    title: const Text('Accueil'),
                    leading: const Icon(Icons.home),
                  ),
                  ListTile(
                    title: const Text('Mes Commandes'),
                    leading:
                        SvgPicture.asset('img/icon/svg/ic_view_list_black.svg'),
                    onTap: () async {
                      getOrders();
                    },
                  ),
                  ListTile(
                    title: const Text('Mes Adresses'),
                    leading: SvgPicture.asset(
                      'img/icon/svg/ic_address.svg',
                      height: 24,
                    ),
                  ),
                  ListTile(
                    title: const Text('Mon Profil'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const Profile()));
                    },
                  ),
                  Builder(builder: (BuildContext context) {
                    return ListTile(
                      title: const Text('Partager'),
                      leading: const Icon(Icons.share),
                      onTap: () => _onShare(context),
                    );
                  }),
                  ListTile(
                    title: const Text('Deconnexion'),
                    leading: const Icon(Icons.power_settings_new),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'img/icon/svg/ic_warning_yellow.svg',
                                    color: const Color(0xffFFAE42),
                                  ),
                                  const Text('Attention')
                                ],
                              ),
                              content: const Text(
                                  'Vous allez être déconnecté et toute vos informations non-enregistrée seront supprimé.'),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () async {
                                    await FireAuth.signOut()
                                        .then((value) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (    BuildContext context
                                                  ) =>
                                                  const LoginScreen()));
                                    });
                                  },
                                ),
                                TextButton(
                                  child: const Text("Annuler"),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
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
}
