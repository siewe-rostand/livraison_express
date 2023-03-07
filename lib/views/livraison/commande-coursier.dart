import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/address.dart';
import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/model/distance_matrix.dart';
import 'package:livraison_express/model/infos.dart';
import 'package:livraison_express/model/payment.dart';
import 'package:livraison_express/model/orders.dart' as command;
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/service/paymentApi.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/livraison/step1.dart';
import 'package:livraison_express/views/livraison/step2.dart';
import 'package:livraison_express/views/widgets/select_time.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/day_item.dart';
import '../../model/horaire.dart';
import '../../model/order.dart';
import '../../model/quartier.dart';
import '../../model/shop.dart';
import '../../utils/main_utils.dart';
import '../home/home-page.dart';
import '../widgets/custom_alert_dialog.dart';

enum DeliveryType { express, heure_livraison }

class CommandeCoursier extends StatefulWidget {
  const CommandeCoursier(
      {Key? key,})
      : super(key: key);

  @override
  State<CommandeCoursier> createState() => _CommandeCoursierState();
}

class _CommandeCoursierState extends State<CommandeCoursier> {
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step3FormKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  int _currentStep = 0;
  int radioSelected = 1;
  int radioSelected2 = 1;
  DeliveryType? _deliveryType;
  StepperType stepperType = StepperType.vertical;
  bool isChecked = false, isToday = false, isChecked1 = false;
  List addresses = [];
  String newCity = '';
  late List<String> filteredList;
  QuarterProvider quarterProvider = QuarterProvider();

  //order variables
  List<Address> addressList = [];
  String fullName = '', telephone = '', telephone1 = '', email = '';
  final TextEditingController _typeAheadController = TextEditingController();

//step 1 variables
  Client sender = Client();
  TextEditingController quarterTextController = TextEditingController();
  TextEditingController nomDepartTextController = TextEditingController();
  TextEditingController phoneDepartTextController = TextEditingController();
  TextEditingController phone2DepartTextController = TextEditingController();
  TextEditingController emailDepartTextController = TextEditingController();
  TextEditingController addressDepartTextController = TextEditingController();
  TextEditingController descDepartTextController = TextEditingController();
  TextEditingController cityDepartTextController = TextEditingController();
  TextEditingController titleDepartTextController = TextEditingController();
  Address senderAddress = Address();
  Adresse selectedAddressDepart = Adresse();
  double? placeLatDepart, placeLonDepart;
  String? location;
  String quartierDepart = '';
  bool isMeDest = true;
  List<Contact> contacts = [];
  List<Contact> contacts1 = [];
  Map contactMap = {};
  List<String> contactsName = [];

//step 2 variables
  Client receiver = Client();
  TextEditingController quarterDestinationTextController =
      TextEditingController();
  TextEditingController nomDestinationTextController = TextEditingController();
  TextEditingController phoneDestinationTextController =
      TextEditingController();
  TextEditingController phone2DestinationTextController =
      TextEditingController();
  TextEditingController emailDestinationTextController =
      TextEditingController();
  TextEditingController addressDestinationTextController =
      TextEditingController();
  TextEditingController descDestinationTextController = TextEditingController();
  TextEditingController cityDestinationTextController = TextEditingController();
  TextEditingController titleDestinationTextController =
      TextEditingController();
  Address receiverAddress = Address();
  Adresse selectedAddressDestination = Adresse();
  double? placeLatDestination, placeLonDestination;
  String? locationDestination;
  String quartierDestination = '';
  bool isLoading = false, isMeDepart = true;
  bool isLoading1 = false;

  //step 3 variables
  TextEditingController descColisTextController = TextEditingController();
  List<String> timeSlots = [];
  List<String> todayTime = [];
  DateTime now = DateTime.now();
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  late DateFormat dateFormat;
  late String selectTodayTime;
  Duration step = const Duration(minutes: 10);
  String chooseTime = '', currentDate = '', currentTime = '', distanceText = '';
  int? initialDeliveryPrice, deliveryPrice;
  String? durationText;
  Shops shops = Shops();
  int delay = 0;
  String deliveryTime = '';
  String commander = 'COMMANDER';

  //step4 variables
  Payment payment = Payment();
  String payMode = '';
  Orders order = Orders();
  Infos info = Infos();
  Client client = Client();
  String codePromo = '';
  int duration = 0, distance = 0;
  int? payOption;
  final logger = Logger();
  String? city;
  int? cityId;
  bool isTomorrowOpened = false;
  bool isTodayOpened = false;

  @override
  void initState() {
    isToday = false;
    isChecked = false;
    log(UserHelper.token);

    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 20, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 20, 30, 0);

    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      startTime = timeIncrement;
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
    }
    while (now1.isBefore(endTime)) {
      now1;
      DateTime incr = now1.add(step);
      todayTime.add(DateFormat.Hm().format(incr));
      now1 = incr;
    }
    initView();
    super.initState();
  }

  initView() async {
    shops = UserHelper.shops;
    city =  UserHelper.city.name;
    cityId =  UserHelper.city.id;
    isOpened(UserHelper.shops.horaires!);
    setState(() {
      cityDepartTextController = TextEditingController(text: city);
      cityDestinationTextController = TextEditingController(text: city);
    });
  }

  showToday() {
    Navigator.of(context).pop();
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
                          color: Color(0xff2A5CA8),
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
                                selectTime = DateFormat('dd-MM-yyyy k:mm')
                                    .format(startTime2);
                                print(selectTime);
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
                              DateFormat('dd-MM-yyyy k:mm').format(startTime2);
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
                            backgroundColor: Color(0xff2A5CA8),
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
                          color: Color(0xff2A5CA8),
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
                                  onPressed: () {
                                    debugPrint("Tomorrow's today");
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
                                    onPressed: () {
                                      debugPrint("tomorrow's tomorrow");
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
                              now.day + 1, int.parse(nw), int.parse(a), 0);
                          var selectTime1 =
                              DateFormat('dd-MM-yyyy  k:mm').format(startTime2);
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
                            backgroundColor: Color(0xff2A5CA8),
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


  setSender() {
    var providerName = "livraison-express";
    var city = UserHelper.city;
    senderAddress.latLng =
        senderAddress.latitude! + ',' + senderAddress.longitude!;

    senderAddress.providerName = providerName;
    senderAddress.villeId = city.id;
    senderAddress.ville = city.name;
    senderAddress.pays = "Cameroun";
    // debugPrint("${sender.toJson()} ${senderAddress.providerId}");
    List<Address> addresses = [];
    addresses.add(senderAddress);
    sender.addresses = addresses;
    // logger.w(senderAddress.toJson());
    log('///address ${UserHelper.city.toJson()}');
    if (mounted) {
      setState(() {
        _currentStep++;
      });
    }
  }

  setReceiver() async {
    receiverAddress.latLng =
        receiverAddress.latitude! + ',' + receiverAddress.longitude!;
    receiverAddress.id = null;
    receiverAddress.providerId = null;
    receiverAddress.villeId = cityId;
    receiverAddress.ville = city;
    receiverAddress.pays = "Cameroun";

    List<Address> addresses = [];
    addresses.add(receiverAddress);
    receiver.addresses = addresses;
    String? origin = sender.addresses![0].latLng;
    String? destination = receiver.addresses![0].latLng;
    debugPrint("distances ${sender.toJson()} // $destination");
    calculateDistance();

  }
  calculateDistance()async{
    String? origin = sender.addresses![0].latLng;
    String? destination = receiver.addresses![0].latLng;
    await CourseApi(context: context)
        .calculateDeliveryDistance(origin: origin!, destination: destination!)
        .then((response) {
      var body = json.decode(response.body);
      var message = body['message'];
      var data = body['data'];
      DistanceMatrix distanceMatrix = DistanceMatrix.fromJson(data);
      logger.w(distanceMatrix.toJson());
      setState(() {
        duration = distanceMatrix.duration!;
        distanceText = distanceMatrix.distanceText!;
        distance = distanceMatrix.distance!;
        durationText = distanceMatrix.durationText;
        deliveryPrice = distanceMatrix.prix;
        initialDeliveryPrice = distanceMatrix.prix;
        isLoading = true;
        _currentStep++;
      });
      showToast(context: context, text: message, iconData: Icons.check, color: UserHelper.getColor());
    }).catchError((onError) {
      var message ="Une erreur est survenue lors du calcul de la distance. Veuillez vérifier vos informations puis réessayez.";
      logger.e(onError);
      errorDialog(context: context, title: "Distance Error", message: message, onTap: (){
        Navigator.pop(context);
      });
    });
  }

  setPaymentMode() {
    if (payMode.isNotEmpty) {
      if (payMode == 'cash') {
        payment.message = null;
        payment.paymentMode = payMode;
        payment.totalAmount = deliveryPrice;
        payment.status = null;
        payment.paymentIntent = null;
        confirmOrder();
      } else if (payMode == 'card') {
        payment.paymentMode = payMode;
        var amt = deliveryPrice.toString();
        PaymentApi(context: context).makePayment(amount: amt).then((val){
          setState(() {
            isLoading1=false;
          });
        },onError:(err){
          setState(() {
            isLoading1=false;
          });
        });
      }
    } else {
      showToast(context: context, text: "Veuillez choisir un moyen de paiement", iconData: Icons.check, color: UserHelper.getColor());
      // Fluttertoast.showToast(msg: "Veuillez choisir un moyen de paiement");
    }
  }

  confirmOrder() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString("userData");
    final extractedUserData = json.decode(userString!);
    var email = extractedUserData['email'];
    var fullName = extractedUserData['fullname'];
    var telephone = extractedUserData['telephone'];
    var providerName = extractedUserData['provider_name'];
    var av = sharedPreferences.getString('city');
    order.module = "delivery";
    order.magasinId = shops.id;
    order.description = descColisTextController.text;
    order.montantLivraison = deliveryPrice;
    // order.articles=[];
    order.codePromo = codePromo;
    order.commentaire = "";
    info.origin = "Livraison express";
    info.platform = "Mobile";
    info.dateLivraison = currentDate + " " + currentTime;
    info.dateChargement = currentDate;
    info.heureLivraison = currentTime;
    info.jourLivraison = currentDate;
    info.villeLivraison = av;
    info.duration = duration;
    info.distance = distance;
    info.durationText = durationText;
    info.distanceText = distanceText;
    info.statutHuman = '';
    // client.id=int.parse(userId);
    client.providerName = providerName;
    client.fullName = fullName;
    client.telephone = telephone;
    client.email = email;
    Map data = {
      "infos": info,
      "client": client,
      "receiver": receiver,
      "sender": sender,
      "orders": order,
      "paiement": payment,
    };
    await CourseApi(context: context).commnander(data: data).then((response) async {
      setState(() {
        isLoading1=false;
      });
      var body = json.decode(response.body);
      var res = body['data'];
      var infos = body['message'];
      command.Command ord =command.Command.fromJson(res);
      log('data $res /// info ${ord.toJson()}');
      UserHelper.userExitDialog(context, true,  CustomAlertDialog(
        svgIcon: "img/icon/svg/smiley_happy.svg", title: "Youpiii".toUpperCase(),
        message: "Felicitation, Commande enregistrée avec succès\nN° commande ${ord.infos?.ref} ",
        positiveText: "OK",
        onContinue:(){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage()));
        },
      ));
    }).catchError((onError) {
      setState(() {
        isLoading1=false;
      });
      UserHelper.userExitDialog(context, true,  CustomAlertDialog(
          svgIcon: "img/icon/svg/smiley_cry.svg", title: "Desole",
          message: onErrorMessage,
          positiveText: "OK",
          onContinue:(){
            Navigator.of(context).pop();
          }));
      // log(onError);
    });
  }

  getStoredUserInfo(int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString("userData");
    final extractedUserData = json.decode(userString!);
    AppUser1 user1 = AppUser1.fromJson(extractedUserData);
    AppUser1? appUser1 = UserHelper.currentUser1 ?? user1;
    email = radioSelected == 0 ? appUser1.email! : '';
    fullName = radioSelected == 0 ? appUser1.fullname! : '';
    telephone = radioSelected == 0 ? appUser1.telephone! : '';
    telephone1 = radioSelected == 0 ? appUser1.telephoneAlt ?? '' : '';
    var id = appUser1.providerId;
    setState(() {
      radioSelected = value;
      nomDepartTextController.text = fullName;
      phone2DepartTextController.text = telephone1;
      phoneDepartTextController.text = telephone;
      emailDepartTextController.text = email;
      // sender.id = int.parse(id);
      print("${id.runtimeType}");
      sender.providerName = radioSelected == 0
          ? extractedUserData['provider_name']
          : 'livraison-express';
      senderAddress.providerName = "livraison-express";
    });
  }

  bool isOpened(Horaires horaires) {
    bool juge = false;
    if (horaires.toString().isNotEmpty) {
      if (horaires.today != null) {
        List<DayItem>? itemsToday = horaires.today?.items;
        for (DayItem i in itemsToday!) {
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
            debugPrint('close time delic // $closeTimeStamp');
            if ((now.isAtSameMomentAs(openTimeStamp) ||
                    now.isAfter(openTimeStamp)) &&
                now.isBefore(closeTimeStamp)) {
              isTodayOpened = true;
              juge = true;
              break;
            }
            log('commande coursier', error: isTodayOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
      if (horaires.tomorrow != null) {
        List<DayItem>? itemsToday = horaires.tomorrow?.items;
        for (DayItem i in itemsToday!) {
          try {
            String? openTime = i.openedAt;
            String? closeTime = i.closedAt;
            if (openTime!.isNotEmpty && closeTime!.isNotEmpty) {
              isTomorrowOpened = true;
              juge = true;
              break;
            }
            log('from home page', error: isTomorrowOpened.toString());
          } catch (e) {
            debugPrint('shop get time error $e');
          }
        }
      }
    }
    return juge;
  }

  bool isOpened1(List<DayItem>? itemsToday) {
    bool juge = false;
    if (itemsToday!.isNotEmpty) {
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

  @override
  void dispose() {
    controller.dispose();
    phone2DestinationTextController.dispose();
    cityDestinationTextController.dispose();
    cityDepartTextController.dispose();
    titleDestinationTextController.dispose();
    descDestinationTextController.dispose();
    addressDestinationTextController.dispose();
    emailDestinationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.white),
          title: Center(
              child: Image.asset(
            'img/logo.png',
            height: getProportionateScreenHeight(50),
            width: MediaQuery.of(context).size.width,
          )),
          iconTheme: const IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails detail) {
                    return _currentStep >= 3
                        ? InkWell(
                      onTap:(isLoading1 == false)? ()async{
                        setState(() {
                          isLoading1=true;
                        });
                        setPaymentMode();
                      }:null,
                      child: Container(
                          height: getProportionateScreenHeight(50),
                          decoration: BoxDecoration(
                              color: UserHelper.getColor(),
                              border: Border.all(color: primaryColor, width: 1.5),
                              borderRadius: BorderRadius.circular(getProportionateScreenHeight(6))
                          ),
                          child: Center(
                              child: (isLoading1 == false)
                                  ? Text("COMMANDER", style: boldTextStyle(16, color: Colors.white))
                                  : CupertinoActivityIndicator(radius: 15, animating: (isLoading1 == true), color: Colors.white)
                          )
                      ),
                    )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                                onPressed: detail.onStepContinue,
                                child: const Text(
                                  "CONTINUER",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          );
                  },
                  type: stepperType,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => step <= _currentStep? tapped(step):null,
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: [
                    Step(
                      title: const Text('Depart'),
                      subtitle: const Text("Contact de l'expéditeur",style: TextStyle(color: Colors.black38),),
                      content: Step1(
                        addressSender: senderAddress,
                        sender: sender,
                        step1FormKey: _formKeys[0],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Destination'),
                      subtitle: const Text("Contact du destinataire",style: TextStyle(color: Colors.black38),),
                      content: Step2(receiver: receiver,receiverAddress: receiverAddress,formKey: _formKeys[1],),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Informations de livraison'),
                      content: Form(
                        key: _formKeys[2],
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Description du colis *'),
                              controller: descColisTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: !isTodayOpened && isTomorrowOpened
                                      ? null
                                      : () {
                                          if (isTodayOpened) {
                                            setState(() {
                                              _deliveryType =
                                                  DeliveryType.express;
                                              chooseTime = durationText!;
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Service Momentanement indisponible");
                                          }
                                        },
                                  child: Row(
                                    children: [
                                      Radio<DeliveryType>(
                                        activeColor:
                                            UserHelper.getColorDark(),
                                        value: DeliveryType.express,
                                        groupValue: _deliveryType,
                                        onChanged: !isTodayOpened &&
                                                isTomorrowOpened
                                            ? null
                                            : (DeliveryType? value) {
                                                setState(() {
                                                  _deliveryType = value;
                                                  chooseTime = durationText!;
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
                                      chooseTime = '';
                                      _deliveryType =
                                          DeliveryType.heure_livraison;
                                    });
                                    showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return SelectTime(onSelectedDate: (onSelectedDate){
                                            setState(() {
                                              chooseTime = onSelectedDate;
                                            });
                                          });
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Radio<DeliveryType>(
                                        activeColor:
                                        UserHelper.getColorDark(),
                                        value: DeliveryType.heure_livraison,
                                        groupValue: _deliveryType,
                                        onChanged: (DeliveryType? value) {
                                          setState(() {
                                            chooseTime = '';
                                            _deliveryType = value;
                                          });
                                          showDialog<void>(
                                              context: context,
                                              builder: (context) {
                                                return SelectTime(onSelectedDate: (onSelectedDate){
                                                  setState(() {
                                                    chooseTime = onSelectedDate;
                                                  });
                                                });
                                              });
                                        },
                                      ),
                                      const Text(
                                          'Choisir mon heure de livraison'),
                                    ],
                                  ),
                                ),
                                Text(
                                  chooseTime,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Confirmation'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: const Text(
                              "Résumé",
                              style: TextStyle(color: grey40),
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: grey40))),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Distance :  ',
                                  style: TextStyle(color: grey90),
                                ),
                                Text(
                                  distanceText ,
                                  style: const TextStyle(color: grey90),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Prix de livraison : ',
                                style: TextStyle(color: grey90),
                              ),
                              Text(
                                deliveryPrice.toString() + ' FCFA',
                                style: const TextStyle(color: grey90),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: const Text(
                              "Promotion",
                              style: TextStyle(color: grey40),
                            ),
                            decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: grey40))),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Annuler',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Valider',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black38),
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
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    child: SvgPicture.asset(
                                      'img/icon/svg/ic_link_black.svg',
                                      color: grey40,
                                    )),
                                const Text(
                                  'Ajouter un code promo',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: const Text(
                              "Mode de paiement",
                              style: TextStyle(color: grey40),
                            ),
                            decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: grey40))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    payMode = 'cash';
                                  });
                                },
                                child: Radio(
                                    value: 0,
                                    groupValue: payOption,
                                    onChanged: (int? value) {
                                      setState(() {
                                        payOption = value;
                                        payMode = 'cash';
                                      });
                                    }),
                              ),
                              const Text('Paiement à la livraison'),
                              SvgPicture.asset(
                                'img/icon/svg/ic_link_black.svg',
                                color: grey40,
                              )
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
                                      payOption = value;
                                      payMode = 'card';
                                    });
                                  }),
                              const Text(
                                'Payer par carte bancaire',
                                style: TextStyle(color: grey90),
                              ),
                              SvgPicture.asset(
                                'img/icon/svg/ic_credit_card_black.svg',
                              )
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
                )
              ],
            ),
          ),
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

  continued() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      switch (_currentStep) {
        case 0:
          _formKeys[_currentStep].currentState?.save();
          setSender();
          break;
        case 1:
          _formKeys[_currentStep].currentState?.save();
          setReceiver();
          break;
        case 2:
          if(chooseTime.isNotEmpty) {
            setState(() {
            dateFormat = DateFormat.Hms();
            currentTime = dateFormat.format(now);
            currentDate = DateFormat("yyyy-MM-dd").format(now);
            _currentStep++;
          });
          }else{
            showToast(context: context, text: "Veuillez choisir l'heure de livraison");
          }
          break;
        default:
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
