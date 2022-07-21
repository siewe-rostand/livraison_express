import 'dart:convert';
import 'dart:developer';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'as stripe;
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/articles.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/cart-model.dart';
import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/model/day.dart';
import 'package:livraison_express/model/day_item.dart';
import 'package:livraison_express/model/infos.dart';
import 'package:livraison_express/model/payment.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/super-market/widget/step1.dart';
import 'package:livraison_express/views/super-market/widget/step2.dart';
import 'package:livraison_express/views/widgets/custom_button.dart';
import 'package:livraison_express/views/widgets/custom_dialog.dart';
import 'package:livraison_express/views/widgets/stripe_checkout.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color-constant.dart';
import '../../model/address-favorite.dart';
import '../../model/address.dart';
import '../../model/distance_matrix.dart';
import '../../model/horaire.dart';
import '../../model/module_color.dart';
import '../../model/order.dart';
import '../../model/quartier.dart';
import '../../service/course_service.dart';
import '../../service/main_api_call.dart';
import '../MapView.dart';
import 'cart-provider.dart';

enum DeliveryType { express, heure_livraison }

class ValiderPanier extends StatefulWidget {
  const ValiderPanier({Key? key, required this.moduleColor, required this.totalAmount}) : super(key: key);
  final ModuleColor moduleColor;
  final double totalAmount;

  @override
  State<ValiderPanier> createState() => _ValiderPanierState();
}

class _ValiderPanierState extends State<ValiderPanier> {
  MainUtils mainUtils =MainUtils();

  final logger = Logger();
  int radioSelected = 1;
  DeliveryType? _deliveryType;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  List addresses = [];
  bool isChecked = false;
  bool isChecked1 = false;
  bool isToday = false;
  String chooseTime = '';
  List<String> timeSlots = [];
  List<String> todayTime = [];
  DateTime now = DateTime.now();
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  late DateFormat dateFormat;
  late String selectTodayTime;
  Duration step = const Duration(minutes: 10);
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  GlobalKey<AutoCompleteTextFieldState<Contact>> key = GlobalKey();
  DBHelper dbHelper =DBHelper();

  //some variables
  String fullName = '';
  String telephone = '';
  String telephone1 = '';
  String email = '';
  int duration = 0;
  int distance = 0;
  int delay = 0;
  int deliveryPrice = 0;
  int initialDeliveryPrice = 0;
  int total = 0;
  String durationText = '';
  String distanceText = '';
  String totalPrice = '';
  String currentTime = '';
  String currentDate = '';
  bool isMeDepart = true;
  int? payOption;
  String payMode='';
  String codePromo='';
  String express='';

  //step1 variables

  Client senderClient = Client();
  Client originalClient = Client();
  Client receiverClient = Client();
  Address senderAddress = Address();
  Address addressReceiver = Address();
  AddressFavorite selectedFavoriteAddress = AddressFavorite();
  TextEditingController quarterTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController phone2DepartTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TextEditingController cityDepartTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  AddressFavorite selectedAddressDepart = AddressFavorite();
  double? placeLat;
  double? placeLon;
  String? location;
  String? city;
  String? slug;
  String? moduleSlug,paymentIntentClientSecret;
  int? idChargement;
  List<Article> productList =[];
  List<Contact> contacts=[];
  late AutoCompleteTextField searchTextField;
  late bool isTodayOpened,isTomorrowOpened,_saveCard;

  TextEditingController controller = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void initState() {
    isChecked = false;
    isChecked1 = false;
    isToday = false;
    initView();

    // TODO: implement initState
    super.initState();
  }

  initView()async{
    city =await UserHelper.getCity();
    cityDepartTextController = TextEditingController(text: city);
    isOpened(UserHelper.shops.horaires!);
    print("city $city");
  }
  showToday() {
    Navigator.of(context).pop();
    Days today =UserHelper.shops.horaires!.today!;
    if(today.toString().isNotEmpty){
      List<DayItem>? item = today.items;
      if(item!.isNotEmpty){
        item.forEach((i) {
          String? openTime=i.openedAt;
          String? closeTime = i.closedAt;
          var nw = openTime?.substring(0, 2);
          var a = openTime?.substring(3, 5);
          var cnm = closeTime?.substring(0, 2);
          var cla = closeTime?.substring(3, 5);
          DateTime openTimeStamp = DateTime(now.year, now.month,
              now.day, int.parse(nw!), int.parse(a!), 0);
          DateTime closeTimeStamp = DateTime(now.year, now.month,
              now.day, int.parse(cnm!), int.parse(cla!), 0);
          if (openTime!.isNotEmpty && closeTime!.isNotEmpty){
            if ((now.isAtSameMomentAs(openTimeStamp) ||
                now.isAfter(openTimeStamp)) && now.isBefore(closeTimeStamp)){
              while (now1.isBefore(closeTimeStamp)) {
                now1;
                DateTime incr = now1.add(step);
                todayTime.add(DateFormat.Hm().format(incr));
                now1 = incr;
              }
            }
            }
        });
      }
    }
    showDialog<void>(
        context: context,
        builder: (context) {
          dateFormat = DateFormat.Hm();
          selectTodayTime = dateFormat.format(t);
          var selectTime;
          return StatefulBuilder(builder: (context, setStateSB) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 6),
                        height: 35,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(5)),
                          color: Color(0xff00a117),
                        ),
                        child: const Text(
                          'A quel heure svp ?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /**
                                   * today's today time
                                   */
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xff00a117))),
                                  onPressed: () {
                                    print("Today's today");
                                    isToday = true;
                                    showToday();
                                  },
                                  child: const Text(
                                    "AUJOUD'HUI",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Ou'),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                /**
                                   * today's tomorrow time
                                   */
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xff00a117))),
                                    onPressed: () {
                                      print("today's tomorrow");
                                      isToday == false;
                                      showTomorrow();
                                    },
                                    child: const Text(
                                      "DEMAIN",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              value: selectTodayTime,
                              icon: const Icon(Icons.arrow_drop_down_outlined),
                              elevation: 16,
                              style: const TextStyle(color: Color(0xA31236BD)),
                              onChanged: (String? newValue) {
                                print(selectTodayTime);
                                setStateSB(() {
                                  selectTodayTime = newValue!;
                                });
                                var nw = selectTodayTime.substring(0, 2);
                                var a = selectTodayTime.substring(3, 5);
                                DateTime startTime2 = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    int.parse(nw),
                                    int.parse(a),
                                    0);
                                selectTime = DateFormat('dd-MM-yyyy  k:mm')
                                    .format(startTime2);
                              },
                              items: todayTime.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          var nw = selectTodayTime.substring(0, 2);
                          var a = selectTodayTime.substring(3, 5);
                          DateTime startTime2 = DateTime(now.year, now.month,
                              now.day, int.parse(nw), int.parse(a), 0);
                          var selectTime1 =
                              DateFormat('dd-MM-yyyy  k:mm').format(startTime2);
                          Navigator.of(context).pop();
                          setState(() {
                            chooseTime = selectTime ?? selectTime1;
                          });
                          print(chooseTime);
                        },
                        child: const Text('VALIDER'),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Color(0xff00a117),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }

  showTomorrow() {
    Navigator.of(context).pop();
    Days tomorrow =UserHelper.shops.horaires!.tomorrow!;
    if(tomorrow.toString().isNotEmpty){
      List<DayItem>? item=tomorrow.items;
      if(item!.isNotEmpty){
        for (var i in item) {
          String? openTime=i.openedAt;
          String? closeTime = i.closedAt;
          var nw = openTime?.substring(0, 2);
          var a = openTime?.substring(3, 5);
          var cnm = closeTime?.substring(0, 2);
          var cla = closeTime?.substring(3, 5);
          DateTime openTimeStamp = DateTime(now.year, now.month,
              now.day, int.parse(nw!), int.parse(a!), 0);
          DateTime closeTimeStamp = DateTime(now.year, now.month,
              now.day, int.parse(cnm!), int.parse(cla!), 0);
          if (openTime!.isNotEmpty && closeTime!.isNotEmpty){
            dateFormat = DateFormat.Hm();
            String currentTime=dateFormat.format(now);
            while (openTimeStamp.isBefore(closeTimeStamp)) {
              DateTime timeIncrement = openTimeStamp.add(step);
              openTimeStamp = timeIncrement;
              timeSlots.add(DateFormat.Hm().format(timeIncrement));
            }
            showDialog<void>(
                context: context,
                builder: (context) {
                  dateFormat = DateFormat.Hm();
                  DateTime startTime1 =
                  DateTime(now.year, now.month, now.day, 8, 30, 0);
                  String nextStart = dateFormat.format(startTime1);
                  var selectTime;
                  return StatefulBuilder(builder: (context, setStateSB) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      elevation: 0.0,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 10, left: 6),
                                height: 35,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(5)),
                                  color: Color(0xff00a117),
                                ),
                                child: const Text(
                                  'A quel heure svp ?',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /**
                                         * tomorrow's today time
                                         */
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff00a117))),
                                          onPressed: () {
                                            print("Tomorrow's today");
                                            isToday = true;
                                            showToday();
                                          },
                                          child: const Text(
                                            "AUJOUD'HUI",
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Row(
                                          children: const [
                                            Expanded(child: Divider()),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Ou'),
                                            ),
                                            Expanded(child: Divider()),
                                          ],
                                        ),
                                        /**
                                         * tomorrow's tomorrow time
                                         */
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xff00a117))),
                                            onPressed: () {
                                              print("tomorrow's tomorrow");
                                              showTomorrow();
                                            },
                                            child: const Text(
                                              "DEMAIN",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: nextStart,
                                      icon: const Icon(Icons.arrow_drop_down_outlined),
                                      elevation: 16,
                                      style: const TextStyle(color: Color(0xA31236BD)),
                                      onChanged: (String? newValue) {
                                        setStateSB(() {
                                          nextStart = newValue!;
                                        });
                                        var nw = nextStart.substring(0, 2);
                                        var a = nextStart.substring(3, 5);
                                        DateTime startTime2 = DateTime(
                                            now.year,
                                            now.month,
                                            now.day + 1,
                                            int.parse(nw),
                                            int.parse(a),
                                            0);
                                        selectTime = DateFormat('dd-MM-yyyy  k:mm')
                                            .format(startTime2);
                                        // print(selectTime);
                                      },
                                      items: timeSlots.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  var nw = nextStart.substring(0, 2);
                                  var a = nextStart.substring(3, 5);
                                  DateTime startTime2 = DateTime(now.year, now.month,
                                      now.day, int.parse(nw), int.parse(a), 0);
                                  var selectTime1 =
                                  DateFormat('dd-MM-yyyy k:mm').format(startTime2);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    chooseTime = selectTime ?? selectTime1;
                                  });
                                },
                                child: const Text('VALIDER'),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Color(0xff00a117),
                                    child: Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    );
                  });
                });
          }
        }
      }
    }
  }


  setSenderAndReceiverInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? mags = sharedPreferences.getString("magasin");
    debugPrint('//${UserHelper.shops.slug}');
    Shops shops=UserHelper.shops;
    var cityId = sharedPreferences.getInt('city_id');
    var providerName = "livraison-express";
    senderClient.id = shops.client?.id;
    senderClient.providerId = shops.client?.providerId;
    senderClient.providerName = shops.client?.providerName;
    senderClient.fullName = shops.client?.fullName;
    senderClient.telephone = shops.client?.telephone;
    senderClient.email = shops.client?.email;

    slug = shops.slug;
    idChargement = shops.id;

    senderAddress.id = shops.adresseFavorite?.id;
    senderAddress.titre = shops.adresseFavorite?.surnom;
    senderAddress.villeId = cityId;
    senderAddress.pays = "Cameroun";
    senderAddress.quarter = shops.adresse?.quartier;
    senderAddress.description = shops.adresse?.description;
    senderAddress.latitude = shops.adresse?.latitude;
    senderAddress.longitude = shops.adresse?.longitude;
    senderAddress.providerId = shops.adresse?.providerId;
    senderAddress.providerName = shops.adresse?.providerName;

    receiverClient.fullName = nameTextController.text;
    receiverClient.telephone = phoneTextController.text;
    receiverClient.email = emailTextController.text;
    addressReceiver.address = addressTextController.text;
    setState(() {
      _currentStep++;
    });
  }

  setDeliveryAddress()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var villeId = pref.getInt('city_id');
    addressReceiver.address = addressTextController.text;
    addressReceiver.villeId = villeId;
    addressReceiver.description = descTextController.text;
    addressReceiver.quarter = quarterTextController.text;
    addressReceiver.titre = titleTextController.text;
    addressReceiver.latitude = placeLat.toString();
    addressReceiver.longitude = placeLon.toString();
    addressReceiver.providerName = "livraison-express";
    addressReceiver.id = null;
    addressReceiver.providerId = null;
    if (selectedFavoriteAddress.toString().isNotEmpty) {
      if (isFavoriteAddress(selectedFavoriteAddress, addressReceiver)) {
        addressReceiver.id = selectedFavoriteAddress.id;
        addressReceiver.providerId = selectedFavoriteAddress.providerId;
        addressReceiver.providerName = selectedFavoriteAddress.providerName;
      }
    }
    calculateDistance();
  }

  bool isFavoriteAddress(AddressFavorite addressFavorite, Address address) {
    if (addressFavorite.toString().isEmpty) {
      return false;
    }
    return addressFavorite.quartier == address.quarter &&
        addressFavorite.description == address.description &&
        addressFavorite.latitude == address.latitude &&
        addressFavorite.longitude == address.longitude &&
        addressFavorite.nom == address.address;
  }

  calculateDistance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? mags = sharedPreferences.getString("magasin");
    // final magasinData = json.decode(mags!);
    // Magasin magasin = Magasin.fromJson(magasinData);

    Shops shops=UserHelper.shops;
    String slug = shops.slug!;
    String module = shops.slug!;
    var amount = widget.totalAmount;
    String origin = senderAddress.latitude! + "," + senderAddress.longitude!;
    String destination =
        addressReceiver.latitude! + "," + addressReceiver.longitude!;
    await CourseApi().calculateOrderDistance(
        origin: origin,
        destination: destination,
        module: module,
        magasin: slug,
        amount: amount.toInt()).then((response){
          // logger.i(response);
          var body = json.decode(response.body);
          var message = body['message'];
          var data = body['data'];
          DistanceMatrix distanceMatrix =DistanceMatrix.fromJson(data);
          logger.i('distance matrix ${distanceMatrix.toJson()}');
          setState(() {
            duration = distanceMatrix.duration!;
            distance = distanceMatrix.distance!;
            durationText = distanceMatrix.durationText!;
            distanceText = distanceMatrix.distanceText!;
            deliveryPrice = distanceMatrix.prix!;
            initialDeliveryPrice = distanceMatrix.prix!;
            express =distanceMatrix.durationText!;
            _currentStep++;
          });
    }).catchError((onError) {
      logger.e(onError);
      _currentStep++;
      // UserHelper.userExitDialog(context, true,  CustomAlertDialog(
      //     svgIcon: "img/icon/svg/smiley_cry.svg", title: "Desole",
      //     message: onError,
      //     width: SizeConfig.screenWidth! *0.4,
      //     height: SizeConfig.screenHeight! * 0.3,
      //     positiveText: "OK",
      //     onContinue:(){
      //       Navigator.of(context).pop();
      //     }, moduleColor: widget.moduleColor));
    });
  }
  setDeliveryTime(bool isExpress){
    String deliveryTime;
    if(isExpress){
      if(delay<=59){
        deliveryTime = delay.toString() + " Mins";
      }else{
        deliveryTime =(delay/60).toString() +"H " + (delay%60).toString() +"Mins";
      }
    }else{
      deliveryTime = currentDate + " " + currentTime;
    }
    return deliveryTime;
  }
  setCartItems()async {
    List<CartItem> cartList =await dbHelper.getCartList();
    for(int i=0; i<cartList.length;i++){
      CartItem cartItem = cartList[i];
      Article article =Article();
      article.id=cartItem.id;
      article.libelle=cartItem.title;
      article.unitPrice=cartItem.price;
      article.totalPrice=cartItem.totalPrice;
      article.categoryId=cartItem.categoryId;
      article.subCategoryId=cartItem.categoryId;
      article.totalPrice = widget.totalAmount.toInt();
      article.quantity =cartItem.quantity;
      article.subTotalAmount =cartItem.quantity!*cartItem.price!;
      article.description ="";
      // var list =json.decode(cartItem.complement!)as List;
      // List<Attributes> attributes = list.map((json) => Attributes.fromJson(json)).toList();
      // article.attributes =attributes;
      productList.add(article);
    }
  }
  saveOrder(String modePaiement, String pi, String status, String paimentMessage)async{
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String? userString =
    sharedPreferences.getString("userData");
    final extractedUserData =
    json.decode(userString!);
    var av = sharedPreferences.getString('city');


    AppUser1 appUser1 = AppUser1.fromJson(extractedUserData);
    List<CartItem> cartList =await dbHelper.getCartList();
    for(int i=0; i<cartList.length;i++){
      CartItem cartItem = cartList[i];
      Article article =Article();
      article.id=cartItem.id;
      article.libelle=cartItem.title;
      article.unitPrice=cartItem.price;
      article.totalPrice=cartItem.totalPrice;
      article.categoryId=cartItem.categoryId;
      article.subCategoryId=cartItem.categoryId;
      article.totalPrice = widget.totalAmount.toInt();
      article.quantity =cartItem.quantity;
      article.subTotalAmount =cartItem.quantity!*cartItem.price!;
      article.description ="";
      // var list =json.decode(cartItem.complement!)as List;
      // List<Attributes> attributes = list.map((json) => Attributes.fromJson(json)).toList();
      // article.attributes =attributes;
      productList.add(article);
    }

    List<Address> addressSender = [];
    List<Address>  receiverAddress = [];
    addressSender.add(senderAddress);
    receiverAddress.add(addressReceiver);
    senderClient.addresses =addressSender;
    receiverClient.addresses=receiverAddress;
    receiverClient.providerName=appUser1.providerName;
    receiverClient.fullName=fullName;

    // originalClient.id=appUser1.providerId;
    originalClient.providerName =appUser1.providerName;
    originalClient.fullName =appUser1.fullname;
    originalClient.telephone =appUser1.telephone;
    originalClient.email =appUser1.email;
    Shops shops =UserHelper.shops;


    Order order =Order();
    order.module=UserHelper.module.slug;
    order.articles =productList;
    order.description ="";
    order.montantTotal =widget.totalAmount.toInt();
    order.promoCode =codePromo;
    order.commentaire ='';
    order.montantLivraison =initialDeliveryPrice;
    order.magasinId=shops.id;
    order.articles=productList;
    logger.wtf(productList);

    Payment payment =Payment();
    payment.totalAmount = total;
    payment.message = paimentMessage;
    payment.paymentMode = modePaiement;
    payment.status = status;
    payment.paymentIntent = pi;

    Info info = Info();
    info.origin ="Livraison express";
    info.platform ="Mobile";
    info.dateLivraison=currentDate + " "+ currentTime;
    info.dateChargement = currentDate;
    info.heureLivraison = currentTime;
    info.jourLivraison=currentDate;
    info.villeLivraison=av;
    info.duration = duration;
    info.distance = distance.toString();
    info.durationText=durationText;
    info.distanceText=distanceText;

    Map data = {
      "infos":info,
      "client":originalClient,
      "receiver":senderClient,
      "sender":receiverClient,
      "orders":order,
      "paiement":payment,
    };

    await CourseApi().commnander2( data: data).then((response) {
      var body = json.decode(response.body);
      var res = body['data'];
      var infos = body['infos'];
      logger.i('data $res /// info $infos');
      // AppUser appUsers=AppUser.fromJson(res);
    }).catchError((onError){
      logger.e(onError);
      UserHelper.userExitDialog(context, true,  CustomAlertDialog(
          svgIcon: "img/icon/svg/smiley_cry.svg", title: "Desole",
          message: onError.toString(),
          positiveText: "OK",
          onContinue:(){
            Navigator.of(context).pop();
      }, moduleColor: widget.moduleColor));
    });
  }
  Future<List<Contact>> getContacts(String query) async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final PermissionStatus permission = await Permission.contacts.status;
    if(permission == PermissionStatus.granted) {
      return await ContactsService.getContacts(query: query,
          withThumbnails: false,photoHighResolution: false
      );
    }else{
      await Permission.contacts.request().then((value) {
        if(value==PermissionStatus.granted){
          getContacts(query);
        }
      });
      throw Exception('error');
    }
  }
  handlePayment() async {
    AppUser1? appUser1=UserHelper.currentUser1;
    String clientSecret;
// 1. fetch Intent Client Secret from backend
    await MainApi().getPaymentIntentClientSecret(token: appUser1!.token!, amount:totalPrice).then((response){

      var body = json.decode(response.body);
      var data = body['data'];
      logger.w(data);
      paymentIntentClientSecret=data['client_secret'];
    });

// 2. Gather customer billing information (ex. email)
    final billingDetails = stripe.BillingDetails(
      email: appUser1.email,
      phone: appUser1.telephone,
    ); // mo mocked data for tests

// 3. Confirm payment with card details
// The rest will be done automatically using webhooks
// ignore: unused_local_variable
    final paymentIntent = await stripe.Stripe.instance.confirmPayment(
      paymentIntentClientSecret!,
      stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
              billingDetails:billingDetails
          ),
          options: stripe.PaymentMethodOptions(
            setupFutureUsage:
            _saveCard == true ? stripe.PaymentIntentsFutureUsage.OffSession : null,
          )
      ),
    );
  }
  autoComplete(){
    return
      TypeAheadField(
        getImmediateSuggestions: true,
        textFieldConfiguration:  TextFieldConfiguration(
          decoration: const InputDecoration(labelText: 'Nom et prenom *'),
          controller: _typeAheadController,
        ),
        suggestionsCallback: (pattern) {
          // call the function to get suggestions based on text entered
          return getContacts(pattern);
        },
        itemBuilder: (context,Contact suggestion) {
          // show suggection list
          suggestion.phones?.forEach((element) {
            telephone=element.value!;
          });
          return ListTile(
            title: Text(suggestion.displayName!),
            subtitle: Text(
              telephone,
            ),
          );
        },
        onSuggestionSelected: (Contact suggestion) {
          suggestion.phones?.forEach((element) {
            telephone=element.value!;
          });
          _typeAheadController.text=suggestion.displayName!;
          phoneTextController.text =telephone;
        },
        hideOnEmpty: true,
        autoFlipDirection: true,
      );
}
  bool isOpened1(List<DayItem>? itemsToday) {
    bool juge = false;
    if(itemsToday!.isNotEmpty) {
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
            setState(() {
              isTodayOpened = true;
              juge = true;
            });
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
  bool isOpened(Horaires horaires) {
    bool juge = false;
    if(horaires.toString().isNotEmpty){
      if(horaires.today!=null){
        List<DayItem>? itemsToday =
            horaires.today?.items;
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
            debugPrint('close time // $closeTimeStamp');
            if ((now.isAtSameMomentAs(openTimeStamp) ||
                now.isAfter(openTimeStamp)) &&
                now.isBefore(closeTimeStamp)) {
              isTodayOpened = true;
              juge=true;
              break;
            }
            log('VALIDER PANIER',error: isTodayOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
      if (horaires.tomorrow != null) {
        List<DayItem>? itemsToday =
            horaires.tomorrow?.items;
        for (DayItem i in itemsToday!) {
          try {
            String? openTime = i.openedAt;
            String? closeTime = i.closedAt;
            if (openTime!.isNotEmpty && closeTime!.isNotEmpty) {
              isTomorrowOpened = true;
              juge=true;
              break;
            }
            log('from home page',error: isTomorrowOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
    }
    return juge;
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final quarter = Provider.of<QuarterProvider>(context);

    // print(' times ${selectTodayTime}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valider Panier'),
        backgroundColor: widget.moduleColor.moduleColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Theme(
              data: ThemeData(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: widget.moduleColor.moduleColor)),
              child: Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails detail) {
                  return _currentStep >= 3
                      ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  widget.moduleColor.moduleColor)),
                          onPressed: () {
                            debugPrint('////');
                            if(payMode == "cash"){
                              debugPrint('////');
                              saveOrder("cash", '', '', '');
                            }else if(payMode == "card"){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaymentSheetScreenWithCustomFlow(amount: totalPrice,)));
                            }else{
                              Fluttertoast.showToast(msg: "Veuillez choisir un moyen de paiement");
                            }
                          },
                          child: const Text(
                            "COMMANDER",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                      : Container(
                    padding: const EdgeInsets.only(top: 10),
                        child: MaterialButton(
                        height: getProportionateScreenHeight(45),
                        color: UserHelper.getColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: detail.onStepContinue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('CONTINUER',style: TextStyle(color: Colors.white,fontSize: 18),),
                            Icon(Icons.arrow_forward,color: Colors.white,size: 23,)
                          ],
                        )),
                      );


                },
                type: stepperType,
                physics: const ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                // onStepCancel: cancel,
                steps: [
                  Step(
                    title: const Text('Information du client'),
                    subtitle: const Text('A QUI LIVRE'),
                    content: Form(
                      key: _formKeys[0],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('CHEZ MOI',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Radio(
                                    activeColor:UserHelper.getColor(),
                                    value: 0,
                                    groupValue: radioSelected,
                                    onChanged: (int? value) async {
                                      SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                      String? userString =
                                      sharedPreferences.getString("userData");
                                      final extractedUserData =
                                      json.decode(userString!);
                                      AppUser1 appUser = AppUser1.fromJson(extractedUserData);
                                      AppUser1? user=UserHelper.currentUser1??appUser;
                                      email =(user.email??appUser.email)!;
                                      fullName =(user.fullname??appUser.fullname)!;
                                      telephone =(user.telephone??appUser.telephone)!;
                                      telephone1 =(user.telephoneAlt??appUser.telephoneAlt)??'';
                                      setState(() {
                                        radioSelected = value!;
                                        nameTextController.text = fullName;
                                        phone2DepartTextController.text = telephone1;
                                        phoneTextController.text = telephone;
                                        emailTextController.text = email;
                                        senderClient.providerName=user.providerName;
                                        senderAddress.providerName =
                                        "livraison-express";
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('AUTRE',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Radio(
                                    activeColor: UserHelper.getColor(),
                                    value:1,
                                    groupValue: radioSelected,
                                    onChanged: (int? value) {
                                      fullName = '';
                                      email = '';
                                      telephone1 = '';
                                      telephone = '';
                                      setState(() {
                                        radioSelected = value!;
                                        nameTextController.text = fullName;
                                        phone2DepartTextController.text = telephone1;
                                        phoneTextController.text = telephone;
                                        emailTextController.text = email;
                                        // sender.id = null;
                                        senderClient.providerName =
                                        'livraison-express';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          radioSelected == 0?TextFormField(
                            controller: nameTextController,
                            readOnly: radioSelected==0 && nameTextController.text.isNotEmpty,
                            decoration: const InputDecoration(
                                labelText: 'Nom et prenom *'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer le nom et prénom";
                              }
                              return null;
                            },
                          ):
                          autoComplete(),
                          TextFormField(
                            controller: phoneTextController,
                            readOnly: radioSelected==0 && phoneTextController.text.isNotEmpty,
                            decoration:
                            const InputDecoration(labelText: 'Telephone 1 *'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le numéro de téléphone';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: phone2DepartTextController,
                            readOnly: radioSelected==0 && phone2DepartTextController.text.isNotEmpty,
                            decoration:
                            const InputDecoration(labelText: 'Telephone 2 '),
                          ),
                          TextFormField(
                            controller: emailTextController,
                            readOnly: radioSelected==0 && emailTextController.text.isNotEmpty,
                            decoration:radioSelected==0?
                            const InputDecoration(labelText: 'Email *'):const InputDecoration(labelText: 'Email '),
                            validator:radioSelected==0? (value) {
                              if (value!.isEmpty) {
                                return "Veuillez remplir ce champ";
                              }
                              return null;
                            }:null,
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text("Informationd'adresse "),
                    content: Form(
                      key: _formKeys[1],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Consulter ma liste d'adresses: "),
                              IconButton(
                                  onPressed: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: AlertDialog(
                                              content: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  const Align(
                                                    child: Text(
                                                      ' Choisir votre adresse: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color:
                                                          Color(0xff00a117)),
                                                    ),
                                                    alignment:
                                                    Alignment.topCenter,
                                                  ),
                                                  addresses.isEmpty
                                                      ? const Text(
                                                    ' Votre liste est vide ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  )
                                                      : ListView.builder(
                                                      itemBuilder:
                                                          (context, index) {
                                                        return const Text(
                                                            'draw');
                                                      }),
                                                  Align(
                                                    alignment:
                                                    Alignment.bottomCenter,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                .white)),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'FERMER',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color:
                                                              Colors.black38),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: SvgPicture.asset('img/icon/svg/ic_address.svg'))
                            ],
                          ),

                          TextFormField(
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            decoration:
                            const InputDecoration(labelText: 'Ville '),
                            controller: cityDepartTextController,
                            enabled: false,
                          ),
                          TypeAheadField<String>(
                            textFieldConfiguration:  TextFieldConfiguration(
                              controller: quarterTextController,
                              decoration: const InputDecoration(
                                  labelText: 'Quartier'),
                            ),
                            suggestionsCallback: (String pattern) async {
                              return city=='Douala'|| city == "DOUALA"?quarter.quarterDouala
                                  .where((item) =>
                                  item.toLowerCase().startsWith(pattern.toLowerCase()))
                                  .toList():quarter.quarterYaounde
                                  .where((item) =>
                                  item.toLowerCase().startsWith(pattern.toLowerCase()))
                                  .toList();
                            },
                            itemBuilder: (context, String suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (String suggestion) {
                              quarterTextController.text = suggestion;
                            },
                            autoFlipDirection: true,
                            hideOnEmpty: true,
                          ),
                          TextFormField(
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                labelText: 'Description du lieu '),
                            controller: descTextController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veuillez remplir ce champ";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onTap: ()async{
                              MainUtils.hideKeyBoard(context);
                              var result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MapsView()));
                              setState(() {
                                placeLon = result['Longitude'] ?? 0.0;
                                placeLat = result['Latitude'] ?? 0.0;
                                location = result['location'];
                                print(
                                    '//received from map $placeLon / $placeLat');
                                addressTextController.text = location!;
                                // senderAddress.nom!=location;
                              });
                            },
                            readOnly: true,
                            decoration: const InputDecoration(
                                labelText: 'Adresse geolocalisee *'),
                            controller: addressTextController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veuillez remplir ce champ\n"
                                    "activer votre localisation et reesayer";
                              } else {
                                if (placeLon == 0.0 ||
                                    placeLat == 0.0) {
                                  location = "";
                                  return "La valeur de ce champ est incorrecte";
                                }
                                return null;
                              }
                            },
                          ),
                          Visibility(
                              visible: isChecked,
                              child: Column(
                                children: [
                                  TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                        hintText: "Titre d'adresse *"),
                                    controller: titleTextController,
                                    validator: (value) {
                                      if (isChecked == true) {
                                        if (value!.isEmpty) {
                                          return "Veuillez remplir ce champ";
                                        } else {
                                          return null;
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Ex: Maison, Bureau',
                                        style:
                                        TextStyle(color: Colors.black26),
                                      )),
                                ],
                              )),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            checkColor: Colors.white,
                            activeColor: Colors.black,
                            title: const Text('Enregistrer cette adresse'),
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                                if (isChecked==true) {
                                  senderAddress.isFavorite = true;
                                  senderAddress.titre =
                                      titleTextController.text;
                                }
                              });
                              print(isFavoriteAddress(selectedAddressDepart, senderAddress));
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Heure de livraison'),
                    content: Form(
                      key: _formKeys[2],
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: !isTodayOpened && isTomorrowOpened?null:() {
                                  if(isTodayOpened) {
                                    setState(() {
                                    _deliveryType = DeliveryType.express;
                                    chooseTime=express;
                                  });
                                  }else{
                                    Fluttertoast.showToast(msg: "Service Momentanement indisponible");
                                  }
                                },
                                child: Row(
                                  children: [
                                    Radio<DeliveryType>(
                                      activeColor: widget.moduleColor.moduleColorDark,
                                      value: DeliveryType.express,
                                      groupValue: _deliveryType,
                                      onChanged:!isTodayOpened && isTomorrowOpened?null: (DeliveryType? value) {
                                        setState(() {
                                          _deliveryType = value;
                                          chooseTime=express;
                                        });
                                      },
                                    ),
                                    const Text('Livraison express'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _deliveryType = DeliveryType.heure_livraison;
                                  });
                                  showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0)),
                                            elevation: 0.0,
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10, left: 6),
                                                      height: 35,
                                                      width: double.infinity,
                                                      decoration:
                                                           BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(10),
                                                                topRight: Radius
                                                                    .circular(5)),
                                                        color: widget.moduleColor.moduleColorDark,
                                                      ),
                                                      child: const Text(
                                                        'Quand souhaitez vous etre livre ?',
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    /**
                                                     * Today
                                                     */
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(widget.moduleColor.moduleColorDark)),
                                                      onPressed: () {
                                                        if(!isTodayOpened && isTomorrowOpened) {
                                                          Fluttertoast.showToast(msg: "Service Momentanement indisponible");

                                                        }else{
                                                          print("isTodayOpened/...$isTodayOpened...$isTomorrowOpened ");
                                                          showToday();
                                                        }
                                                        },
                                                      child: const Text(
                                                        "AUJOUD'HUI",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Expanded(
                                                            child: Divider()),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(8.0),
                                                          child: Text('Ou'),
                                                        ),
                                                        Expanded(
                                                            child: Divider()),
                                                      ],
                                                    ),
                                                    /**
                                                     * tomorrow
                                                     */
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(widget.moduleColor.moduleColorDark)),
                                                        onPressed: () {
                                                          showTomorrow();
                                                        },
                                                        child: const Text(
                                                          "DEMAIN",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  ],
                                                ),
                                                Positioned(
                                                  right: 0.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child:  Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: CircleAvatar(
                                                        radius: 14.0,
                                                        backgroundColor:
                                                        widget.moduleColor.moduleColorDark,
                                                        child: const Icon(Icons.close,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Radio<DeliveryType>(
                                      activeColor: widget.moduleColor.moduleColorDark,
                                      value: DeliveryType.heure_livraison,
                                      groupValue: _deliveryType,
                                      onChanged: (DeliveryType? value) {
                                        setState(() {
                                          _deliveryType = value;
                                        });
                                      },
                                    ),
                                    const Text('Choisir mon heure de livraison'),
                                  ],
                                ),
                              ),
                              Text(chooseTime),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Confirmation'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin:const EdgeInsets.only(bottom: 5),
                          child:  const Text("Résumé",style: TextStyle(color: grey40),),
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: grey40)
                              )
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Montant du panier: '),
                              Text(cartProvider.totalPrice.toString() + 'FCFA')
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text('Livraison: '),
                              Text(deliveryPrice.toString() + ' FCFA')
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total: '),
                            Consumer<Cart>(
                              builder: (_, cart, child)
                              {
                                var total=cartProvider.getTotalPrice() +deliveryPrice;
                                     return Text(
                                        total.toString()+ " FCFA",
                                        style: const TextStyle(
                                            color: grey90),
                                      );
                                    }),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 5,bottom: 5),
                          child:  const Text("Promotion",style: TextStyle(color:grey40),),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: grey40)
                              )
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                labelText: 'Code Promo'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all(Colors
                                                          .white)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Annuler',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black87),
                                                  )),
                                              const Spacer(
                                                flex: 2,
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all(Colors
                                                          .white)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Valider',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black38),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children:  [
                              Container(
                                  margin:const EdgeInsets.only(right: 3),
                                  child: SvgPicture.asset('img/icon/svg/ic_link_black.svg',color:grey40 ,)),
                              const Text('Ajouter un code promo',style: TextStyle(color: primaryColor),),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 5,bottom: 5),
                          child:  const Text("Mode de paiement",style: TextStyle(color: grey40),),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color:grey40)
                              )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                                value: 0,
                                groupValue: payOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    payOption =value;
                                    payMode = 'cash';
                                  });
                                }
                            ),
                            const Text('Paiement à la livraison'),
                            SvgPicture.asset('img/icon/svg/ic_link_black.svg',color:grey40 ,)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                                value: 1,
                                groupValue: payOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    payOption =value;
                                    payMode = 'card';
                                  });
                                }
                            ),
                            const Text('Payer par carte bancaire',style: TextStyle(color: grey90),),
                            SvgPicture.asset('img/icon/svg/ic_credit_card_black.svg',)
                          ],
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    // _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    if (_formKeys[_currentStep].currentState!.validate()) {
      switch (_currentStep) {
        case 0:
          setSenderAndReceiverInfo();
          break;
        case 1:
          setDeliveryAddress();
          break;
        case 2:
          setState(() {
            dateFormat=DateFormat.Hms();
            currentTime=dateFormat.format(now);
            currentDate =DateFormat("yyyy-MM-dd").format(now);
            if(chooseTime.isEmpty) {
              Fluttertoast.showToast(msg: "Veuillez choisir une heure de livraison");
            }else {
              _currentStep++;
            }
          });
          break;
      }
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 10)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }
}
