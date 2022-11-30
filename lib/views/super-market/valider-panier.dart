import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/data/local_db/db-helper.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/cart-model.dart';
import 'package:livraison_express/model/client.dart';
import 'package:livraison_express/model/day_item.dart';
import 'package:livraison_express/model/infos.dart';
import 'package:livraison_express/model/orders.dart' as command;
import 'package:livraison_express/model/payment.dart';
import 'package:livraison_express/model/product.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/paymentApi.dart';
import 'package:livraison_express/utils/app_extension.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/super-market/widget/step1.dart';
import 'package:livraison_express/views/super-market/widget/step2.dart';
import 'package:livraison_express/views/widgets/custom_alert_dialog.dart';
import 'package:livraison_express/views/widgets/custom_dialog.dart';
import 'package:livraison_express/views/widgets/select_time.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color-constant.dart';
import '../../model/address.dart';
import '../../model/distance_matrix.dart';
import '../../model/horaire.dart';
import '../../model/order.dart';
import '../../model/shop.dart';
import '../../service/course_service.dart';
import 'cart-provider.dart';
import '../cart/cart.dart';

enum DeliveryType { express, heure_livraison }

class ValiderPanier extends StatefulWidget {
  const ValiderPanier({Key? key, required this.totalAmount}) : super(key: key);
  final double totalAmount;

  @override
  State<ValiderPanier> createState() => _ValiderPanierState();
}

class _ValiderPanierState extends State<ValiderPanier> {
  MainUtils mainUtils =MainUtils();

  DBHelper1 dbHelper = DBHelper1();
  final logger = Logger();
  Map<String, dynamic>? paymentIntentData;
  int radioSelected = 1;
  DeliveryType? _deliveryType;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  List addresses = [];
  bool isChecked = false;
  bool isChecked1 = false;
  bool isLoading=false;
  bool isLoading1=false;
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
  TextEditingController cityDepartTextController = TextEditingController();
  TextEditingController promoTextController = TextEditingController();
  Adresse selectedAddressDepart = Adresse();
  String? city;
  int? cityId;
  String? slug;
  int? idChargement;
  List<Products> productList =[];
  bool isTodayOpened=false,isTomorrowOpened=false;

  @override
  void initState() {
    isChecked = false;
    isChecked1 = false;
    isToday = false;
    initView();

    // TODO: implement initState
    super.initState();
  }

  initView(){
    city = UserHelper.city.name;
    cityId = UserHelper.city.id;
    cityDepartTextController = TextEditingController(text: city);
    isOpened(UserHelper.shops.horaires!);
  }

  displayPaymentSheet() async {

    try {
      await stripe.Stripe.instance.presentPaymentSheet().then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        logger.v('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Paiement reussir"),
          backgroundColor: Colors.green,
        ));
        logger.e(paymentIntentData!['amount']);
        // saveOrder('card', paymentIntentData!['id'].toString(), 'OK', paymentIntentData!['object']);
        paymentIntentData = null;

      }).onError((error, stackTrace){
        log('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on stripe.StripeException catch (e) {
      log('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      log('$e');
    }
  }

   makePayment({required String amount, required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String? userString =
      sharedPreferences.getString("userData");
      final extractedUserData =
      json.decode(userString!);
      AppUser1 appUser1 = AppUser1.fromJson(extractedUserData);

      paymentIntentData =
      await PaymentApi(context: context).createPaymentIntent(amount, 'XAF');
      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            applePay: true,
            googlePay: true,
            testEnv: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: appUser1.fullname ?? appUser1.firstname,
            customerId: paymentIntentData!['customer'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],)).then((value){
        print('0000000000000000000000');
      });

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  setSenderAndReceiverInfo() {
    var city =  UserHelper.city;
    Shops shops=UserHelper.shops;
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
    senderAddress.villeId = city.id;
    senderAddress.ville = city.name;
    senderAddress.pays = "Cameroun";
    senderAddress.quarter = shops.adresse?.quartier;
    senderAddress.description = shops.adresse?.description;
    senderAddress.latitude = shops.adresse?.latitude;
    senderAddress.longitude = shops.adresse?.longitude;
    senderAddress.providerId = shops.adresse?.providerId;
    senderAddress.providerName = shops.adresse?.providerName;
    senderAddress.nom=shops.slug;

    // logger.d('4${receiverClient.toJson()}');
    if (mounted) {
      setState(() {
        _currentStep++;
      });
    }
  }

  setDeliveryAddress() {
    addressReceiver.providerName = "livraison-express";
    addressReceiver.id = null;
    addressReceiver.providerId = null;
    addressReceiver.ville=city;
    addressReceiver.villeId=cityId;
    addressReceiver.pays="Cameroun";
    calculateDistance();
  }


  calculateDistance() async {
    setState(() {
      isLoading1 = true;
    });
    Shops shops=UserHelper.shops;
    String slug = shops.slug!;
    String module = shops.slug!;
    var amount = widget.totalAmount;
    String origin = senderAddress.latitude! + "," + senderAddress.longitude!;
    String destination =
        addressReceiver.latitude! + "," + addressReceiver.longitude!;
    await CourseApi(context: context).calculateOrderDistance(
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
          // logger.i('distance matrix ${addressReceiver.toJson()}');
          if (mounted) {
            setState(() {
              duration = distanceMatrix.duration!;
              distance = distanceMatrix.distance!;
              durationText = distanceMatrix.durationText!;
              distanceText = distanceMatrix.distanceText!;
              deliveryPrice = distanceMatrix.prix!;
              initialDeliveryPrice = distanceMatrix.prix!;
              express =distanceMatrix.durationText!;

              isLoading1 =false;
              UserHelper.chooseTime='';
              _currentStep++;
            });
          }
          log("message${distanceMatrix.toJson()}");
    }).catchError((onError) {
      setState(() {
        isLoading1 =false;
      });
      logger.e(onError);
      var message ="Une erreur est survenue lors du calcul de la distance. Veuillez vérifier vos informations puis réessayez.";
      showGenDialog(context,true,CustomDialog(title: "Alert", content: message, positiveBtnText: "OK", positiveBtnPressed: (){
        Navigator.pop(context);
      }));
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
      Products article =Products();
      article.id=cartItem.id;
      article.libelle=cartItem.title;
      article.prixUnitaire=cartItem.price;
      article.totalPrice=cartItem.totalPrice;
      article.categorieId=cartItem.categoryId;
      article.subCategoryId=cartItem.categoryId;
      article.totalPrice = widget.totalAmount.toInt();
      article.quantity =cartItem.quantity;
      article.subTotalAmount =Provider.of<CartProvider>(context).getTotalPrice().toInt();

      productList.add(article);
    }
  }
  saveOrder(String modePaiement, String pi, String status, String paimentMessage)async{
    Shops shops =UserHelper.shops;
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String? userString =
    sharedPreferences.getString("userData");
    final extractedUserData =
    json.decode(userString!);


    AppUser1 appUser1 = AppUser1.fromJson(extractedUserData);
    List<CartItem> cartList =await dbHelper.getCartList();
    for(int i=0; i<cartList.length;i++){
      CartItem cartItem = cartList[i];
      Products article =Products();
      article.id=cartItem.productId;
      article.libelle=cartItem.title;
      article.prixUnitaire=cartItem.price;
      article.totalPrice=cartItem.totalPrice;
      article.totalPrice = widget.totalAmount.toInt();
      article.quantity =cartItem.quantity;
      article.subTotalAmount =Provider.of<CartProvider>(context,listen: false).getTotalPrice().toInt();
      article.magasinId=shops.id;
      productList.add(article);
    }

    List<Address> addressSender = [];
    List<Address>  receiverAddress = [];
    addressReceiver.clientId = appUser1.id;
    addressSender.add(senderAddress);
    receiverAddress.add(addressReceiver);
    senderClient.addresses =addressSender;
    receiverClient.addresses=receiverAddress;
    receiverClient.providerName=appUser1.providerName;

    // originalClient.id=appUser1.providerId;
    originalClient.providerName =appUser1.providerName;
    originalClient.fullName =appUser1.fullname;
    originalClient.telephone =appUser1.telephone;
    originalClient.email =appUser1.email;


    Orders order =Orders();
    order.module=UserHelper.module.slug;
    order.listeArticles =productList;
    order.description ="";
    order.montantTotal =widget.totalAmount.toInt();
    order.codePromo =codePromo;
    order.commentaire ='';
    order.montantLivraison =initialDeliveryPrice;
    order.magasinId=shops.id;
    order.listeArticles = productList;
    var total=Provider.of<CartProvider>(context,listen: false).getTotalPrice() +deliveryPrice;
    Payment payment =Payment();
    payment.totalAmount = total.toInt();
    payment.message = paimentMessage;
    payment.paymentMode = modePaiement;
    payment.status = status;
    payment.paymentIntent = pi;

    Infos info = Infos();
    info.origin ="Livraison express";
    info.platform ="Mobile";
    info.dateLivraison=currentDate + " "+ currentTime;
    info.dateChargement = currentDate;
    info.heureLivraison = currentTime;
    info.jourLivraison=currentDate;
    info.villeLivraison=city;
    info.duration = duration;
    info.distance = distance;
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

    await CourseApi(context: context).commnander2( data: data).then((response) {
      var body = json.decode(response.body);
      var com = body['data'];
      command.Command ord =command.Command.fromJson(com);
      UserHelper.userExitDialog(context, true,  CustomAlertDialog(
          svgIcon: "img/icon/svg/smiley_happy.svg", title: "Youpiii".toUpperCase(),
          message: "Felicitation, Commande enregistrée avec succès\nN° commande ${ord.infos?.ref} ",
          positiveText: "OK",
          onContinue:(){
            setState(() {
              isLoading1=false;
            });
            Navigator.of(context).pop();
            Provider.of<CartProvider>(context,listen: false).clears();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const CartPage()));
          },
          ));
    }).catchError((onError){
      setState(() {
        isLoading1=false;
      });
      logger.e(onError);
      UserHelper.userExitDialog(context, true,  CustomAlertDialog(
          svgIcon: "img/icon/svg/smiley_cry.svg", title: "Desole",
          message: onError.toString(),
          positiveText: "OK",
          onContinue:(){
            Navigator.of(context).pop();
      }));
    });
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
            // debugPrint('close time // $closeTimeStamp');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valider Panier'),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>const CartPage()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: UserHelper.getColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Theme(
              data: ThemeData(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: UserHelper.getColor()),
                focusColor: UserHelper.getColorDark(),
              ),
              child: Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails detail) {
                  return isLoading==true?const CircularProgressIndicator(): _currentStep >= 3
                      ? InkWell(
                    onTap:(isLoading1 == false)? ()async{
                      setState(() {
                        isLoading1=true;
                      });
                      if(payMode == "cash"){
                        saveOrder("cash", '', '', '');
                      }else if(payMode == "card"){
                        var amt=cartProvider.totalPrice +deliveryPrice;
                        var amount= amt.toString();
                        await stripe.Stripe.instance.presentPaymentSheet();
                        PaymentApi(context: context).makePayment(amount: amount);
                      }else{
                        Fluttertoast.showToast(msg: "Veuillez choisir un moyen de paiement");
                      }
                    }:null,
                    child: Container(
                        height: getProportionateScreenHeight(50),
                        decoration: BoxDecoration(
                            color: UserHelper.getColor(),
                            border: Border.all(color: UserHelper.getColorDark(), width: 1.5),
                            borderRadius: BorderRadius.circular(getProportionateScreenHeight(6))
                        ),
                        child: Center(
                            child: (isLoading1 == false)
                                ? Text("COMMANDER", style: boldTextStyle(16, color: Colors.white))
                                : CupertinoActivityIndicator(radius: 15, animating: (isLoading1 == true))
                        )
                    ),
                  )
                      : Container(
                    padding: const EdgeInsets.only(top: 10),
                        child: MaterialButton(
                        height: getProportionateScreenHeight(45),
                        color: UserHelper.getColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: detail.onStepContinue,
                        child:(isLoading1 == false)? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('CONTINUER',style: TextStyle(color: Colors.white,fontSize: 18),),
                            Icon(Icons.arrow_forward,color: Colors.white,size: 23,)
                          ],
                        ): CupertinoActivityIndicator(radius: 15, animating: (isLoading1 == true))
                        ),
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
                    content: Step1(step1FormKey:  _formKeys[0],sender: receiverClient,),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text("Information 'adresse "),
                    content: Step2(step2FormKey: _formKeys[1],addressReceiver: addressReceiver,),
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
                                onTap: !isTodayOpened && isTomorrowOpened? (){
                                  showToast(context: context, text: "Service Momentanement indisponible", iconData: Icons.close_rounded, color: Colors.red);
                                }
                                    :() {
                                  if(isTodayOpened) {
                                    setState(() {
                                    _deliveryType = DeliveryType.express;
                                    chooseTime=express;
                                    UserHelper.chooseTime=chooseTime;
                                  });
                                  }else{
                                    Fluttertoast.showToast(msg: "Service Momentanement indisponible");
                                  }
                                },
                                child: Row(
                                  children: [
                                    Radio<DeliveryType>(
                                      activeColor: UserHelper.getColorDark(),
                                      focusColor: UserHelper.getColorDark(),
                                      value: DeliveryType.express,
                                      groupValue: _deliveryType,
                                      onChanged:!isTodayOpened && isTomorrowOpened?null: (DeliveryType? value) {

                                                  setState(() {
                                          _deliveryType = value;
                                          chooseTime=express;
                                          UserHelper.chooseTime=chooseTime;
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
                                    chooseTime='';
                                  });
                                  showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        return  Center(
                                          child: SelectTime(onSelectedDate: (selectedDate){
                                            setState(() {
                                              chooseTime=selectedDate;
                                            });
                                            },),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Radio<DeliveryType>(
                                      activeColor: UserHelper.getColorDark(),
                                      focusColor: UserHelper.getColorDark(),
                                      value: DeliveryType.heure_livraison,
                                      groupValue: _deliveryType,
                                      onChanged: (DeliveryType? value) {
                                        setState(() {
                                          _deliveryType = value;
                                          chooseTime='';
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
                              Text(cartProvider.getTotalPrice().toString() + 'FCFA')
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
                            Consumer<CartProvider>(
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
                                            controller: promoTextController,
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
                                                    var amount = cartProvider.getTotalPrice();
                                                    CourseApi(context: context).validatePromoCode(
                                                        code: promoTextController.text,
                                                        magasin_id: UserHelper.shops.id!,
                                                        amount: amount.toInt(),
                                                        delivery_amount: deliveryPrice).onError((error, stackTrace){
                                                       return  showToast(context: context, text: "Code non valide ou expirer");
                                                    });
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
                                activeColor: UserHelper.getColorDark(),
                                focusColor: UserHelper.getColorDark(),
                                value: 0,
                                groupValue: payOption,
                                onChanged: (int? value) {
                                  if (mounted) {
                                    setState(() {
                                      payOption =value;
                                      payMode = 'cash';
                                    });
                                  }
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
                                activeColor: UserHelper.getColorDark(),
                                focusColor: UserHelper.getColorDark(),
                                value: 1,
                                groupValue: payOption,
                                onChanged: (int? value) {
                                  if (mounted) {
                                    setState(() {
                                      payOption =value;
                                      payMode = 'card';
                                    });
                                  }
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
    if(step <= _currentStep) {
      setState(() => _currentStep = step);
    }else{
      showToast(context: context, text: 'Veuillez clicker le button');
    }
  }

  continued() async {
    // _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    if (_formKeys[_currentStep].currentState!.validate()) {
      switch (_currentStep) {
        case 0:
          _formKeys[_currentStep].currentState!.save();
          setSenderAndReceiverInfo();
          break;
        case 1:
          _formKeys[_currentStep].currentState!.save();
          setDeliveryAddress();
          break;
        case 2:
          if(mounted) {
            if(chooseTime.isNotEmpty) {
              setState(() {
            dateFormat=DateFormat.Hms();
            currentTime=dateFormat.format(now);
            currentDate =DateFormat("yyyy-MM-dd").format(now);
            _currentStep++;
          });
            }else{
              showToast(context: context, text: "Veuillez choisir l'heure de livraison");
            }
          }
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
