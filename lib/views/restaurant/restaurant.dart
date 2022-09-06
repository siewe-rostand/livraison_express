import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/address-favorite.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/MapView.dart';
import 'package:livraison_express/views/address_detail/selected_fav_address.dart';
import 'package:livraison_express/views/restaurant/delivery_address.dart';
import 'package:livraison_express/views/restaurant/resto_home.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../model/magasin.dart';
import '../../service/shopService.dart';
import '../widgets/custom_alert_dialog.dart';

class Restaurant extends StatefulWidget {
  const Restaurant(
      {Key? key, this.moduleId, })
      : super(key: key);
  final int? moduleId;

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  double latitude = 0.0;
  late ProgressDialog progressDialog;
  double longitude = 0.0;
  bool isLoading = false, canDeliver = false;
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

  bool isOpened(List<DayItem> items) {
    bool juge = false;

    if (items.isNotEmpty) {
      for (DayItem item in items) {
        String? openTime = item.openedAt;
        String? closeTime = item.closedAt;
        if (openTime != null &&
            openTime.isNotEmpty &&
            closeTime != null &&
            closeTime.isNotEmpty) {
          DateTime now = DateTime.now();
          dateFormat = DateFormat.Hm();
          currentTime = dateFormat.format(now);
          try {
            var nw1 = currentTime.substring(0, 2);
            var a1 = currentTime.substring(3, 5);
            var nw = openTime.substring(0, 2);
            var a = openTime.substring(3, 5);
            var cnm = closeTime.substring(0, 2);
            var cla = closeTime.substring(3, 5);
            DateTime currentTimeStamp = DateTime(
                now.year, now.month, now.day, int.parse(nw1), int.parse(a1), 0);
            DateTime openTimeStamp = DateTime(
                now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
            DateTime closeTimeStamp = DateTime(now.year, now.month, now.day,
                int.parse(cnm), int.parse(cla), 0);
            if (currentTimeStamp.isAtSameMomentAs(openTimeStamp) &&
                currentTimeStamp.isAfter(openTimeStamp) &&
                currentTimeStamp.isBefore(closeTimeStamp)) {
              juge = true;
              break;
            }
          } catch (e) {
            debugPrint('restaurant today time exce// $e');
          }
        }
      }
    }
    return juge;
  }

  showError(String title, String message,
      {String icon = 'img/icon/svg/alert_round.svg'}) {
    UserHelper.userExitDialog(
        context,
        false,
        CustomAlertDialog(
          title: title,
          message: message,
          svgIcon: icon,
          positiveText: 'Fermer',
          onContinue: () {
            Navigator.pop(context);
          },
        ));
  }

  getShops(
    double latitude,
    double longitude,
  ) async {
    await progressDialog.show();
    String city = await UserHelper.getCity();
    List<Shops> shops = await ShopServices()
        .getShops(
            moduleId: widget.moduleId!,
            city: city,
            latitude: latitude,
            longitude: longitude,
            inner_radius: 0,
            outer_radius: 5)
        .then((value) async{
          await progressDialog.hide();
      debugPrint('restaurant current pos// ${value[0].adresseFavorite}');
      AddressFavorite? addressFav = value[0].adresseFavorite;
      var avf = json.encode(addressFav);
      // MySession.saveValue('delivery_address', avf);
      return value;
    }).catchError((onError) {
      debugPrint('///$onError');
      showError("Oops!!", "Désolé nous ne livrons pas encore dans cette zone.");
    });
    if (shops.isNotEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DeliveryAddress(
                moduleId: widget.moduleId!,
                city: city,
                latitude: latitude,
                longitude: longitude,
                shops: shops,
              )));
    }
  }
  addressOnMap()async{
    String city =
    await UserHelper.getCity();
    var result =
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
            const MapsView()));
    setState(() {
      placeLon =
          result['Longitude'] ?? 0.0;
      placeLat =
          result['Latitude'] ?? 0.0;
      location = result['location'];
      print(
          '//received from map $placeLon / $placeLat');
    });
    if (placeLon != null &&
        placeLon != 0.0 &&
        placeLat != null &&
        placeLat != 0.0) {
      setState(() {
        isLoading = !isLoading;
        message = 'chargement ...';
      });
  }
    getShops(placeLat!, placeLon!);
  }

  @override
  void initState() {
    progressDialog = getProgressDialog(context: context);
    super.initState();
    fToast = FToast();
    fToast.init(context);
    debugPrint('$isLoading');
    message = 'Bienvenue dans mon restaurant.'
        'Commencez par choisir une adresse de livraison.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: UserHelper.getColor()),
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
                    getShops(latitude, longitude);
                  }).catchError((onError) {
                    showError("Alerte",
                        "Nous n'avons pas pu récupérer votre position. Veuillez nous accorder l'accès a votre position puis réessayez.");
                  });
                  break;
                case 1:

                  showDialog<void>(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: SelectedFavAddress(isDialog: true,onTap: (a){
                              latitude=double.parse(a.latitude!);
                              longitude=double.parse(a.longitude!);
                              getShops(latitude, longitude);
                              },),
                          ),
                        );
                      });
                  break;
                case 2:
                  await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                          const MapsView())).then((result) {
                    placeLon = result['Longitude'] ?? 0.0;
                    placeLat = result['Latitude'] ?? 0.0;
                    location = result['location'];
                    getShops(placeLat!, placeLon!);
                    print(placeLon);
                  }).catchError((onError){
                    showError("Nous N'avons pas pu avoir votre localisation", message);
                  });
              }
            }),
          ],
        ),
      ),
    );
  }

}
