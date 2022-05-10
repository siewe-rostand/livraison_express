import 'package:flutter/material.dart';
import 'package:livraison_express/views/main/about.dart';
import 'package:livraison_express/views/main/login.dart';
import 'package:livraison_express/views/main/profil.dart';
import 'package:share_plus/share_plus.dart';

class MyHomeDrawer extends StatelessWidget {
  const MyHomeDrawer({Key? key}) : super(key: key);

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
                          builder: (BuildContext context) =>
                              const LoginScreen()));
                    },
                    title: const Text('Accueil'),
                    leading: const Icon(Icons.home),
                  ),
                  const ListTile(
                    title: Text('Mes Commandes'),
                    leading: Icon(Icons.list),
                  ),
                  const ListTile(
                    title: Text('Mes Adresses'),
                    leading: Icon(Icons.import_contacts),
                  ),
                  ListTile(
                    title: const Text('Mon Profil'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Profile()));
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen()));
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
                title: const Center(child: Text('A propos',style: TextStyle(color: Color(0xff263238),fontSize: 16),)),
                leading:  Image.asset('img/icon/ic_about.png'),
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
