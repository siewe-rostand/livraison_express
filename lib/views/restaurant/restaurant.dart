import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/city.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/MapView.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';
import 'package:livraison_express/views/main/magasin_page.dart';
import 'package:livraison_express/views/restaurant/resto_home.dart';
import 'package:logger/logger.dart';

import '../../model/module.dart';
import '../../service/shopService.dart';
import '../../utils/main_utils.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({Key? key}) : super(key: key);

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  double latitude = 0.0;
  Logger logger = Logger();
  Modules modules = Modules();
  bool isLoading = false;
  double longitude = 0.0;
  bool isToday = false;
  String currentText = "";
  String currentTime = '';
  double? placeLat, placeLon;
  String? location;
  List addresses = [];
  String message = '';
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
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.checkPermission();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        return _showToast();
      }
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

  getShops(
    double latitude,
    double longitude,
  ) async {
    City city = UserHelper.city;
    await ShopServices(
            context: context,
            progressDialog: getProgressDialog(context: context))
        .getShops(
            moduleId: modules.id!,
            city: city.name!,
            latitude: latitude,
            longitude: longitude,
            inner_radius: 0,
            outer_radius: 5)
        .then((value) {
      // UserHelper.shops =value;
      UserHelper.module.shops = value;
      if (value.isNotEmpty) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MagasinPage()));
      } else {
        logger.e("====$value");
        showError(
            title: "Oops!!",
            message: "Désolé nous ne livrons pas encore dans cette zone.",
            context: context);
      }
    }).catchError((onError) {
      logger.e('///$onError');
      showError(title: "Oops!!", message: onErrorMessage, context: context);
    });
  }

  @override
  void initState() {
    super.initState();
    modules = UserHelper.module;
    fToast = FToast();
    fToast.init(context);
    message = 'Bienvenue dans mon restaurant.'
        'Commencez par choisir une adresse de livraison.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: UserHelper.getColor()),
        backgroundColor: UserHelper.getColor(),
        title: const Text('Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight! * 0.05,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "img/icon/svg/ic_cook.svg",
                  color: Colors.black45,
                  height: getProportionateScreenHeight(120),
                  width: getProportionateScreenWidth(120),
                  semanticsLabel: 'cook',
                ),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.grey[700], fontSize: 18),
                  ),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.05,
            ),
            RestauHome((option) async {
              switch (option) {
                case 0:
                  await _determinePosition().then((pos) async {
                    latitude = pos.latitude;
                    longitude = pos.longitude;
                    print('${pos.latitude}  $longitude');
                    getShops(latitude, longitude);
                  }).catchError((onError) {
                    showError(
                        title: "Alerte!!",
                        message:
                            "Nous n'avons pas pu récupérer votre position. Veuillez nous accorder l'accès a votre position puis réessayez.",
                        context: context);
                  });
                  break;
                case 1:
                  MainUtils.hideKeyBoard(context);
                  showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: SelectedFavAddress(
                              isDialog: true,
                              onTap: (a) {
                                latitude = double.parse(a.latitude!);
                                longitude = double.parse(a.longitude!);
                                getShops(latitude, longitude);
                              },
                            ),
                          ),
                        );
                      });
                  break;
                case 2:
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const MapsView()))
                      .then((result) {
                    placeLon = result['Longitude'] ?? 0.0;
                    placeLat = result['Latitude'] ?? 0.0;
                    location = result['location'];
                    getShops(placeLat!, placeLon!);
                    print('_RestaurantState.build$placeLon');
                    print(placeLon);
                  }).catchError((onError) {
                    showError(
                        title: "Oops!!",
                        message: "Nous N'avons pas pu avoir votre localisation",
                        context: context);
                  });
              }
            }),
          ],
        ),
      ),
    );
  }
}
