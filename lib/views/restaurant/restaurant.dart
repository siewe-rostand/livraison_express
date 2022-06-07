import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/constant/color-constant.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/views/MapView.dart';
import 'package:livraison_express/views/restaurant/delivery_address.dart';
import 'package:livraison_express/views/restaurant/map_page.dart';

import '../../model/magasin.dart';
import '../../service/shopService.dart';

class Restaurant extends StatefulWidget {
  const Restaurant(
      {Key? key, required this.moduleColor, this.moduleId, required this.city})
      : super(key: key);
  final ModuleColor moduleColor;
  final int? moduleId;
  final String city;

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = false;
  bool isToday= false;
  String currentTime='';
  late DateFormat dateFormat;
  late FToast fToast;
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.purpleAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Flexible(child: Text("Nous n'avons pas pu récupérer votre position")),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: const Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    //     });
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      return _showToast();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied. we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nous n'avons pas pu récupérer votre position"),
          ),
        );
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getMagasin()async{

  }

  bool isOpened(List<DayItem> items){
    bool juge = false;

    if(items.isNotEmpty){
      for(DayItem item in items){
        String? openTime = item.openedAt;
        String? closeTime = item.closedAt;
        if(openTime !=null && openTime.isNotEmpty && closeTime!=null && closeTime.isNotEmpty){
          DateTime now =DateTime.now();
          dateFormat = DateFormat.Hm();
          currentTime = dateFormat.format(now);
          try{
            var nw1 = currentTime.substring(0, 2);
            var a1 = currentTime.substring(3, 5);
            var nw = openTime.substring(0, 2);
            var a = openTime.substring(3, 5);
            var cnm = closeTime.substring(0, 2);
            var cla = closeTime.substring(3, 5);
            DateTime currentTimeStamp =
            DateTime(now.year, now.month, now.day, int.parse(nw1), int.parse(a1), 0);
            DateTime openTimeStamp = DateTime(
                now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
            DateTime closeTimeStamp = DateTime(
                now.year, now.month, now.day, int.parse(cnm), int.parse(cla), 0);
            if(currentTimeStamp.isAtSameMomentAs(openTimeStamp)&&currentTimeStamp.isAfter(openTimeStamp)&&currentTimeStamp.isBefore(closeTimeStamp)){
              juge=true;
              break;
            }
          }catch(e){
            debugPrint('restaurant today time exce// $e');
          }
        }
      }
    }
    return juge;
  }

  List addresses = [];
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    debugPrint('$isLoading');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: widget.moduleColor.moduleColorDark),
      child: Scaffold(
        backgroundColor: widget.moduleColor.moduleColor,
        appBar: AppBar(
          backgroundColor: widget.moduleColor.moduleColor,
          title: const Text('Restaurant'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 35, top: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "img/icon/svg/ic_cook.svg",
                      color: Colors.white,
                      height: 100,
                      width: 100,
                      semanticsLabel: 'cook',
                    ),
                    Expanded(
                      child: isLoading ==false
                          ? const Text(
                              'Bienvenue dans mon restaurant.'
                              'Commencez par choisir une adresse de livraison.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Center(child: CircularProgressIndicator()),
                                Text('Chargement')
                              ],
                            ),
                    )
                  ],
                ),
              ),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text('Veuillez choisir une addresse de livraison'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: const Divider(
                          thickness: 1.5,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        height: 30,
                        child: InkWell(
                          onTap: () async {
                            Position pos = await _determinePosition();

                            // debugPrint('pos ${pos.runtimeType}');
                            if (pos != null) {
                              latitude =pos.latitude;
                              longitude =pos.longitude;
                              setState(() {
                                isLoading=!isLoading;
                              });
                              // debugPrint('load $isLoading');
                              var moduleId = widget.moduleId;
                              List<Magasin> mags =await ShopServices.getShops(
                                  moduleId: widget.moduleId!,
                                  city: widget.city,
                                  latitude: latitude,
                                  longitude: longitude,
                                  inner_radius: 0,
                                  outer_radius: 5).then((value) {
                                debugPrint('restaurant current pos// $value');
                                return value;
                              }).catchError((onError){
                                debugPrint('///$onError');
                              });
                              if(mags.isNotEmpty){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (context) => DeliveryAddress(
                                              moduleId: widget.moduleId!,
                                              city: widget.city,
                                              latitude: latitude,
                                              longitude: longitude,
                                              moduleColor: widget.moduleColor,
                                          magasins: mags,)));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Nous n'avons pas pu récupérer votre position"),
                                ),
                              );
                              isLoading = false;
                            }
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "img/icon/svg/ic_current_position.svg",
                                semanticsLabel: 'current position',
                                color: Color(int.parse(ColorConstant.grey80)),
                                width: 20,
                                height: 25,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text('Ma position actuelle'),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      InkWell(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: AlertDialog(
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Align(
                                          child: Text(
                                            ' Choisir votre adresse: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          alignment: Alignment.topCenter,
                                        ),
                                        addresses.isEmpty
                                            ? const Text(
                                                ' Votre liste est vide ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : ListView.builder(
                                                itemBuilder: (context, index) {
                                                return Text('draw');
                                              }),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'FERMER',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black38),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "img/icon/svg/ic_address.svg",
                                semanticsLabel: 'address',
                                color: Color(int.parse(ColorConstant.grey80)),
                                width: 20,
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text("Consultez ma liste d'adresses"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 4, bottom: 4),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MapsView()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'img/icon/svg/ic_map_location.svg',
                                semanticsLabel: 'location',
                                color: Color(int.parse(ColorConstant.grey80)),
                                height: 20,
                                width: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child:
                                    Text('Choisir une adresse sur la carte '),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
