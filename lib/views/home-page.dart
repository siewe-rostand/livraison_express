import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/service/fire-auth.dart';
import 'package:livraison_express/views/home-drawer.dart';
import 'package:livraison_express/views/livraison/livraison.dart';
import 'package:livraison_express/views/restaurant/restaurant.dart';
import 'package:livraison_express/views/super-market/super-market.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/quartier.dart';
import 'expand-fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //dop down menu initial value
  String initialDropValue = 'DOUALA';

  bool _view =true;
  AppUser appUser=AppUser();

  @override
  void initState() {
    _view =true;
    getUserInfo();
    super.initState();
  }


  getUserInfo()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    appUser = await ApiAuthService.getUser();
    String fullName=appUser.fullName??'';
    String phone=appUser.telephone??'';
    String email=appUser.email??'';
    sharedPreferences.setString('fullName', fullName);
    sharedPreferences.setString('phone', phone);
    sharedPreferences.setString('email', email);
    var a=sharedPreferences.getString('phone');
    print(appUser.providerName);
  }

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("img/index_page.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
            title: Center(
                child: Image.asset(
              'img/logo_start.png',
              height: 70,
              width: MediaQuery.of(context).size.width,
            )),
            iconTheme: const IconThemeData(color: Color(0xff1A237E)),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: ()async{
                    setState(() {
                      _view=!_view;
                    });
                    await FireAuth.signOutFromGoogle();
                  },
                  icon: const Icon(Icons.pix)
              ),
            ],
          ),
        ),
        drawer: const MyHomeDrawer(),
        body:
        // _view? Column(
        //   children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //   const Text('Ville'),
        //    DropdownButton<String>(
        //     underline: Container(),
        //     value: initialDropValue,
        //     icon: const Icon(Icons.arrow_drop_down_outlined),
        //     elevation: 16,
        //     style: const TextStyle(color: Color(0xA31236BD)),
        //     onChanged: (String? newValue) {
        //       setState(() {
        //         initialDropValue = newValue!;
        //       });
        //     },
        //     items: <String>['DOUALA', 'YAOUNDE']
        //         .map<DropdownMenuItem<String>>((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Text(value),
        //       );
        //     }).toList(),
        //   ),
        // ],),
        //     Expanded(
        //       child: GridView(
        //         shrinkWrap: true,
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: 2),
        //         children: [
        //           Card(
        //             color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child:Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/livraison.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Livraison',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               ) ),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/supermarché.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'supermarché',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/restaurant.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Restaurant',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/gaz.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Gaz',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/pharmacie.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Pharmacie',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/librairie.jpg'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Librairie',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/fleuriste.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Fleuriste',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //           Card(
        //               color: Colors.grey.shade300,
        //               shadowColor: Colors.blue,
        //               child: Container(
        //                 decoration: const BoxDecoration(
        //                     image:
        //                     DecorationImage(image: AssetImage('img/cadeau.png'))),
        //                 child: Container(
        //                     width: double.maxFinite,
        //                     margin: const EdgeInsets.only(top: 120),
        //                     child: const Center(
        //                         child: Text(
        //                           'Cadeau',
        //                           style: TextStyle(
        //                               color: Colors.blue,
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 20),
        //                         ))),
        //               )),
        //         ],
        //       ),
        //     ),
        //   ],
        // ):
        ListView(
          padding: const EdgeInsets.only(top: 15),
            children: [
              const Center(
                  child: Text(
                'services disponible a ',
                style: TextStyle(fontSize: 18,color: Color(0xff37474F)),
              )),
              Center(
                child: DropdownButton<String>(
                  value: initialDropValue,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  elevation: 16,
                  style: const TextStyle(color: Color(0xff1A237E),fontSize: 18,fontWeight: FontWeight.w500),
                  onChanged: (String? newValue) {
                    setState(() {
                      initialDropValue = newValue!;
                    });
                  },
                  items: quarter.city
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12,width: 1.5))
                ),
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.black87,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                               Livraison(city: initialDropValue,)));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/livraison.png',
                                height: 100,
                                width: 80,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Livraison',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff37474F)),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SuperMarket()));
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'img/supermarché.png',
                              height: 100,
                            ),
                             Container(
                               margin: const EdgeInsets.only(top: 5),
                                child: const Text(
                                  'supermarché',
                                  style: TextStyle(color: Color(0xff37474F),fontSize: 15,fontWeight: FontWeight.bold),
                                )),
                            // ListTile(
                            //   title: Image.asset(
                            //     'img/supermarché.png',
                            //     height: 100,
                            //   ),
                            //   subtitle: const Center(
                            //       child: Text(
                            //     'supermarché',
                            //     style: TextStyle(color: Color(0xff37474F)),
                            //   )),
                            // ),
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
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => const Restaurant()));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/restaurant.png',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Restaurant',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(thickness: 1.5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/gaz.png',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Gaz',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/pharmacie.png',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Pharmacie',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(thickness: 1.5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/librairie.jpg',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Librairie',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 130,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.black87,
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/fleuriste.png',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Fleuriste',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(thickness: 1.5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              title: Image.asset(
                                'img/cadeau.png',
                                height: 100,
                              ),
                              subtitle: const Center(
                                  child: Text(
                                'Cadeau',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
        floatingActionButton: const FancyFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
