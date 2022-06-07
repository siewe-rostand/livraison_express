import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/model/address-favorite.dart';
import 'package:livraison_express/model/address.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/model/day.dart';
import 'package:livraison_express/model/payment.dart';
import 'package:livraison_express/service/course_service.dart';
import 'package:livraison_express/service/favorite_address_api.dart';
import 'package:livraison_express/views/MapView.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/day_item.dart';
import '../../model/quartier.dart';

enum Contact { moi, autre }
enum DeliveryType { express, heure_livraison }

class CommandeCoursier extends StatefulWidget {
  final String? city;
  final Position? currentLocation;
  final String? currentAddress;
  final String? from;
  final Shops shops;
  const CommandeCoursier(
      {Key? key,
      this.city,
      this.currentLocation,
      this.currentAddress,
      this.from,
      required this.shops})
      : super(key: key);

  @override
  State<CommandeCoursier> createState() => _CommandeCoursierState();
}

class _CommandeCoursierState extends State<CommandeCoursier> {
  final GlobalKey<FormState> step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> step3FormKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  int _currentStep = 0;
  DeliveryType? _deliveryType;
  StepperType stepperType = StepperType.vertical;
  bool isChecked = false;
  bool isToday = false;
  List addresses = [];
  String newCity = '';
  late List<String> filteredList;
  QuarterProvider quarterProvider = QuarterProvider();

  //order variables
  List<Address> addressList = [];
  String fullName = '';
  String telephone = '';
  String telephone1 = '';
  String email = '';

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
  AddressFavorite selectedAddressDepart = AddressFavorite();
  double? placeLatDepart;
  double? placeLonDepart;
  String? location;
  String quartierDepart = '';
  Contact? _contact = Contact.autre;
  bool isMeDest = true;

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
  AddressFavorite selectedAddressDestination = AddressFavorite();
  double? placeLatDestination;
  double? placeLonDestination;
  String? locationDestination;
  String quartierDestination = '';
  Contact? _contactDest = Contact.autre;
  bool isLoading = false;
  bool isMeDepart = true;

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
  String chooseTime = '';
  bool? initialDeliveryPrice;
  bool? deliveryPrice;
  String? durationText;
  String? distanceText;
  bool isTodayOpened = false;
  Shops shops = Shops();

  //step4 variables
  Payment payment = Payment();

  @override
  void initState() {
    isToday = false;
    isChecked = false;
    shops = widget.shops;

    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 20, 0);
    DateTime startTime1 = DateTime(now.year, now.month, now.day, 8, 30, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 20, 30, 0);
    cityDepartTextController = TextEditingController(text: widget.city);
    cityDestinationTextController = TextEditingController(text: widget.city);

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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var av = preferences.getString('city');
    if (shops.horaires != null && shops.horaires?.today != null) {
      Days? today = shops.horaires?.today;
      List<DayItem>? itemsToday = today?.items;
      for (DayItem i in itemsToday!) {
        try {
          DateTime now = DateTime.now();
          String? openTime = i.openedAt;
          String? closeTime = i.closedAt;
          // var nw1 = currentTime.substring(0, 2);
          // var a1 = currentTime.substring(3, 5);
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
            isTodayOpened = true;
          }
          print(isTodayOpened);
          // if(isShopOpen(i.openedAt!, i.closedAt!)){
          //   isTodayOpened =true;
          // }
        } catch (e) {
          debugPrint('shop get time error $e');
        }
      }
    }
    print(av);
    if (widget.from == 'map') {
      var position = widget.currentLocation;
      placeLonDepart = position?.longitude ?? 0.0;
      placeLatDepart = position?.latitude ?? 0.0;
      addressDepartTextController =
          TextEditingController(text: widget.currentAddress);
    }
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

  calculateDistance() async {
    String? origin = sender.addresses![0].latLng;
    String? destination = receiver.addresses![0].latLng;
    debugPrint("distances $origin // $destination");
    await CourseApi.calculateOrderDistance(
            origin: origin!, destination: destination!)
        .then((value) {
      print(value);
      setState(() {
        isLoading = true;
      });
    }).catchError((onError) {
      print('eroo/');
    });
  }

  setSender() async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var id= sharedPreferences.getInt('city_id');
    var villeId =sharedPreferences.getInt('cityId');
    sender.fullName = nomDepartTextController.text;
    sender.telephone = phoneDepartTextController.text;
    sender.telephoneAlt = phone2DepartTextController.text;
    sender.email = emailDepartTextController.text;
    senderAddress.nom = location;
    senderAddress.quarter = quartierDepart;
    senderAddress.description = descDepartTextController.text;
    senderAddress.latitude = placeLatDepart.toString();
    senderAddress.longitude = placeLonDepart.toString();
    senderAddress.latLng =
        senderAddress.latitude! + ',' + senderAddress.longitude!;
    senderAddress.providerName = 'livraison-express';
    senderAddress.id = null;
    senderAddress.providerId = null;
    if(selectedAddressDepart.toString().isNotEmpty){
      senderAddress.id=selectedAddressDepart.id;
      senderAddress.providerId=selectedAddressDepart.id;
      senderAddress.providerName=selectedAddressDepart.providerName;
    }
      List<Address> addresses = [];
      addresses.add(senderAddress);
      sender.addresses = addresses;

    setState(() {
      _currentStep++;
    });
  }

  setReceiver() async {
    receiver.fullName = nomDestinationTextController.text;
    receiver.telephone = phoneDestinationTextController.text;
    receiver.telephoneAlt = phoneDestinationTextController.text;
    receiver.email = emailDestinationTextController.text;
    receiverAddress.nom = locationDestination;
    receiverAddress.quarter = quartierDestination;
    receiverAddress.description = descDestinationTextController.text;
    // print('//$location');
    receiverAddress.latitude = placeLatDestination.toString();
    receiverAddress.longitude = placeLonDestination.toString();
    receiverAddress.latLng =
        receiverAddress.latitude! + ',' + receiverAddress.longitude!;
    // String? latLong = receiver.addresses![0].latLng;
    print('receiverAddress ${receiverAddress.latLng}');
    receiverAddress.providerName = 'livraison-express';
    receiverAddress.id = null;
    receiverAddress.providerId = null;

    if (selectedAddressDestination.toString().isNotEmpty) {
      if (isFavoriteAddress(selectedAddressDestination, receiverAddress)) {
        receiverAddress.id = selectedAddressDestination.id;
        receiverAddress.providerId =
            selectedAddressDestination.id;
        receiverAddress.providerName =
            selectedAddressDestination.providerName;
      }
    }

    List<Address> addresses = [];
    addresses.add(receiverAddress);
    receiver.addresses = addresses;
    String? origin = sender.addresses![0].latLng;
    String? destination = receiver.addresses![0].latLng;
    debugPrint("distances $origin // $destination");
    await CourseApi.calculateOrderDistance(
            origin: origin!, destination: destination!)
        .then((response) {
      var body = json.decode(response.body);
      var message = body['message'];
      setState(() {
        isLoading = true;
      });
      Fluttertoast.showToast(msg: message, backgroundColor: Colors.green);
    }).catchError((onError) {
      print('eroo/');
    });
    setState(() {
      _currentStep++;
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.white),
          title: Center(
              child: Image.asset(
            'img/logo.png',
            height: 50,
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
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                                onPressed: () {},
                                child: const Text(
                                  "COMMANDER",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
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
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: [
                    Step(
                      title: const Text('Depart'),
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: const Text(
                                "Contact de l'expediteur",
                                style: TextStyle(color: Colors.black38),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<Contact>(
                                  value: Contact.moi,
                                  groupValue: _contact,
                                  onChanged: (Contact? value) async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    String? userString =
                                        sharedPreferences.getString("userData");
                                    final extractedUserData =
                                        json.decode(userString!);
                                    email = extractedUserData['email'];
                                    fullName = extractedUserData['fullname'];
                                    telephone = extractedUserData['telephone'];
                                    telephone1 =
                                        extractedUserData['telephone_alt'];
                                    var id = extractedUserData['provider_id'];
                                    setState(() {
                                      isMeDepart=false;
                                      _contact = value;
                                      nomDepartTextController.text = fullName;
                                      phone2DepartTextController.text =
                                          telephone1;
                                      phoneDepartTextController.text =
                                          telephone;
                                      emailDepartTextController.text = email;
                                      sender.id = id.toString();
                                      // print(sender.id);
                                      sender.providerName =
                                          extractedUserData['provider_name'];
                                    });
                                  },
                                ),
                                const Text('Moi'),
                                Radio<Contact>(
                                  value: Contact.autre,
                                  groupValue: _contact,
                                  onChanged: (Contact? value) {
                                    fullName = '';
                                    email = '';
                                    telephone1 = '';
                                    telephone = '';
                                    setState(() {
                                      _contact = value;
                                      nomDepartTextController.text = fullName;
                                      phone2DepartTextController.text =
                                          telephone1;
                                      phoneDepartTextController.text =
                                          telephone;
                                      emailDepartTextController.text = email;
                                      sender.id = null;
                                      sender.providerName = 'livraison-express';
                                    });
                                  },
                                ),
                                const Text('Autre'),
                              ],
                            ),
                            TextFormField(
                              enabled: isMeDepart,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Nom et prenom *'),
                              controller: nomDepartTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              enabled: isMeDepart,
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Telephone 1 *'),
                              controller: phoneDepartTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              enabled: isMeDepart,
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Telephone 2 *'),
                              controller: phone2DepartTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              enabled: isMeDepart,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration:
                                  const InputDecoration(labelText: 'Email *'),
                              controller: emailDepartTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Adresse de l'expediteur",
                                  style: TextStyle(color: Colors.black38),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      itemBuilder:
                                                          (context, index) {
                                                      return const Text('draw');
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Consulter ma liste d'adresses: "),
                                  // Image.asset('img/icon/address.png',height: 24,width: 24,)
                                  SvgPicture.asset(
                                    'img/icon/svg/ic_address.svg',
                                    height: 24,
                                    width: 24,
                                  )
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration:
                                  const InputDecoration(labelText: 'Ville '),
                              controller: cityDepartTextController,
                              enabled: false,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Description du lieu *'),
                              controller: descDepartTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return quarter.quarterDouala
                                    .where((String quarter) => quarter
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .toLowerCase()))
                                    .toList();
                              },
                              onSelected: (String selection) {
                                debugPrint('You just selected $selection');
                                quartierDepart = selection;
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                      fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  decoration: const InputDecoration(
                                      labelText: 'Quartier'),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MapsView()));
                                setState(() {
                                  placeLonDepart = result['Longitude'] ?? 0.0;
                                  placeLatDepart = result['Latitude'] ?? 0.0;
                                  location = result['location'];
                                  print(
                                      '//received from map $placeLonDepart / $placeLatDepart');
                                  addressDepartTextController.text = location!;
                                  // senderAddress.nom!=location;
                                });
                              },
                              child: TextFormField(
                                enabled: isMeDepart,
                                decoration: const InputDecoration(
                                    labelText: 'Adresse geolocalisee *'),
                                controller: addressDepartTextController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Veuillez remplir ce champ";
                                  } else {
                                    if (placeLonDepart == 0.0 ||
                                        placeLatDepart == 0.0) {
                                      location = "";
                                      return "La valeur de ce champ est incorrecte";
                                    }
                                    return null;
                                  }
                                },
                              ),
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
                                      controller: titleDepartTextController,
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
                                        titleDepartTextController.text;
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
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Destination'),
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("contact de l'expediteur"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<Contact>(
                                  value: Contact.moi,
                                  groupValue: _contactDest,
                                  onChanged: (Contact? value) async {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    String? userString =
                                        sharedPreferences.getString("userData");
                                    final extractedUserData =
                                        json.decode(userString!);
                                    email = extractedUserData['email'];
                                    fullName = extractedUserData['fullname'];
                                    telephone = extractedUserData['telephone'];
                                    telephone1 =
                                        extractedUserData['telephone_alt'];
                                    var id = extractedUserData['provider_id'];
                                    setState(() {
                                      isMeDest=false;
                                      _contactDest = value;
                                      nomDestinationTextController.text =
                                          fullName;
                                      phone2DestinationTextController.text =
                                          telephone1;
                                      phoneDestinationTextController.text =
                                          telephone;
                                      emailDestinationTextController.text =
                                          email;
                                      sender.id = id.toString();
                                      // print(sender.id);
                                      sender.providerName =
                                          extractedUserData['provider_name'];
                                    });
                                  },
                                ),
                                const Text('Moi'),
                                Radio<Contact>(
                                  value: Contact.autre,
                                  groupValue: _contactDest,
                                  onChanged: (Contact? value) {
                                    fullName = '';
                                    email = '';
                                    telephone1 = '';
                                    telephone = '';
                                    setState(() {
                                      _contactDest = value;
                                      nomDestinationTextController.text =
                                          fullName;
                                      phone2DestinationTextController.text =
                                          telephone1;
                                      phoneDestinationTextController.text =
                                          telephone;
                                      emailDestinationTextController.text =
                                          email;
                                      sender.id = null;
                                      sender.providerName = 'livraison-express';
                                    });
                                  },
                                ),
                                const Text('Autre'),
                              ],
                            ),
                            TextFormField(
                              enabled: isMeDest,
                              decoration: const InputDecoration(
                                  labelText: 'Nom et prenom *'),
                              controller: nomDestinationTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            TextFormField(
                              enabled: isMeDest,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  labelText: 'Telephone 1 *'),
                              controller: phoneDestinationTextController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              enabled: isMeDest,
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Telephone 2 *'),
                              controller: phone2DestinationTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              enabled: isMeDest,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration:
                                  const InputDecoration(labelText: 'Email *'),
                              controller: emailDestinationTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Adresse de l'expediteur",
                                  style: TextStyle(color: Colors.black38),
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      itemBuilder:
                                                          (context, index) {
                                                      return const Text('draw');
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Consulter ma liste d'adresses: "),
                                  // Image.asset('img/icon/address.png',height: 24,width: 24,)
                                  SvgPicture.asset(
                                    'img/icon/svg/ic_address.svg',
                                    height: 24,
                                    width: 24,
                                  )
                                ],
                              ),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration:
                                  const InputDecoration(labelText: 'Ville '),
                              controller: cityDestinationTextController,
                              enabled: false,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                  labelText: 'Description du lieu *'),
                              controller: descDestinationTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Veuillez remplir ce champ";
                                }
                                return null;
                              },
                            ),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return quarter.quarterDouala
                                    .where((String quarter) => quarter
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .toLowerCase()))
                                    .toList();
                              },
                              onSelected: (String selection) {
                                debugPrint('You just selected $selection');
                                quartierDestination = selection;
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                      fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  decoration: const InputDecoration(
                                      labelText: 'Quartier'),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                var result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MapsView()));
                                setState(() {
                                  placeLonDestination = result['Longitude'];
                                  placeLatDestination = result['Latitude'];
                                  locationDestination = result['location'];
                                  print(
                                      '//received from map $placeLonDestination / $placeLatDestination');
                                  addressDestinationTextController.text =
                                      locationDestination!;
                                  // senderAddress.nom!=location;
                                });
                              },
                              child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                    labelText: 'Adresse geolocalisee *'),
                                controller: addressDestinationTextController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Veuillez remplir ce champ";
                                  }
                                  return null;
                                },
                              ),
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
                                      controller:
                                          titleDestinationTextController,
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
                                  senderAddress.isFavorite = true;
                                  senderAddress.titre =
                                      titleDestinationTextController.text;
                                });
                                print(isChecked);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            isLoading == true
                                ? const CircularProgressIndicator()
                                : Container(),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Heure de livraison'),
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
                                  onTap: () {
                                    setState(() {
                                      _deliveryType = DeliveryType.express;
                                      chooseTime = 'dans 20 minutes';
                                    });
                                  },
                                  child: isTodayOpened == true
                                      ? Row(
                                          children: [
                                            Radio<DeliveryType>(
                                              value: DeliveryType.express,
                                              groupValue: _deliveryType,
                                              onChanged: (DeliveryType? value) {
                                                setState(() {
                                                  _deliveryType = value;
                                                });
                                              },
                                            ),
                                            const Text('Livraison express'),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Radio<DeliveryType>(
                                              value: DeliveryType.express,
                                              groupValue: _deliveryType,
                                              onChanged: null,
                                            ),
                                            const Text('Livraison express'),
                                          ],
                                        ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _deliveryType =
                                          DeliveryType.heure_livraison;
                                    });
                                    showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      16.0)),
                                              elevation: 0.0,
                                              child: Stack(
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 10, left: 6),
                                                        height: 35,
                                                        width: double.infinity,
                                                        decoration:
                                                        const BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  10),
                                                              topRight: Radius
                                                                  .circular(
                                                                  5)),
                                                          color:
                                                          Color(0xff2A5CA8),
                                                        ),
                                                        child: const Text(
                                                          'Quand souhaitez vous etre livre ?',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      ),
                                                      /**
                                                       * Today
                                                       */
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          showToday();
                                                        },
                                                        child: const Text(
                                                          "AUJOUD'HUI",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Expanded(
                                                              child: Divider()),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                8.0),
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Align(
                                                        alignment:
                                                        Alignment.topRight,
                                                        child: CircleAvatar(
                                                          radius: 14.0,
                                                          backgroundColor: Color(0xff2A5CA8),
                                                          child: Icon(Icons.close,
                                                              color:
                                                              Colors.white),
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
                                        value: DeliveryType.heure_livraison,
                                        groupValue: _deliveryType,
                                        onChanged: (DeliveryType? value) {
                                          setState(() {
                                            _deliveryType = value;
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                        children: [
                          const Text("contact de l'expediteur"),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Nom et prenom *'),
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 3
                          ? StepState.complete
                          : StepState.indexed,
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
          setSender();
          break;
        case 1:
          setReceiver();
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
