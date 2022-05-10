import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/views/livraison/commande-coursier.dart';

class Livraison extends StatefulWidget {
  final String city;
  const Livraison({Key? key, required this.city}) : super(key: key);

  @override
  State<Livraison> createState() => _LivraisonState();
}

class _LivraisonState extends State<Livraison> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              shadowColor: Color(0xffBBD4EF),
              title: Center(
                  child: Image.asset(
                'img/logo_start.png',
                height: 70,
                width: MediaQuery.of(context).size.width,
              )),
              iconTheme: const IconThemeData(color: Colors.blue),
              backgroundColor: Colors.white,
            ),
          ),
          body: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("img/landing_coursier_4.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*.45,
                      child: Image.asset(
                        'img/livreur2.png',
                        fit: BoxFit.fitHeight,
                        height: 200,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                             const SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  "Hello, je suis Bibip votre coursier de Livraison Express. Je me chargerai de vous livrer tous vos colis et plis dans votre ville en moins de 90 min. Le service vous tente? Cliquez sur le bouton ci-dessous pour démarrer une course",
                                  style: TextStyle(fontSize: 16, color: Colors.black45),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: double.maxFinite,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          const Color(0xff2a5ca8))),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CommandeCoursier(
                                              city: widget.city,
                                            )));
                                  },
                                  child: const Text(
                                    'COMMANDER',
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
              Positioned(
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        color: Colors.white,
                      ),
                      Container(
                        height: 6,
                        color: Colors.red,
                      ),
                      Container(
                        height: 50,
                        color: Colors.white,
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
