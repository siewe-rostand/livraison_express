import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'cart-provider.dart';

enum Contact { moi, autre }
enum DeliveryType { express, heure_livraison }

class ValiderPanier extends StatefulWidget {
  const ValiderPanier({Key? key}) : super(key: key);

  @override
  State<ValiderPanier> createState() => _ValiderPanierState();
}

class _ValiderPanierState extends State<ValiderPanier> {
  Contact? _contact = Contact.moi;
  DeliveryType? _deliveryType;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  List addresses = [];
  bool isChecked = false;
  bool isChecked1 = false;
  bool isToday = false;
  int deliveryPrice = 1000;
  String chooseTime = '';
  List<String> timeSlots = [];
  List<String> todayTime = [];
  DateTime now = DateTime.now();
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  late DateFormat dateFormat;
  late String selectTodayTime;
  Duration step = const Duration(minutes: 10);


  @override
  void initState() {
    isChecked = false;
    isChecked1 = false;
    isToday = false;

    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 20, 0);
    DateTime startTime1 = DateTime(now.year, now.month, now.day, 8, 30, 0);
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

    // TODO: implement initState
    super.initState();
  }

  showToday() {
    Navigator.of(context).pop();
    showDialog<void>(
        context: context,
        builder: (context) {

          dateFormat =DateFormat.Hm();
          selectTodayTime = dateFormat.format(t);
          var selectTime;
          return StatefulBuilder(
            builder: (context, setStateSB) {
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
                                        backgroundColor: MaterialStateProperty.all(
                                            const Color(0xff00a117))),
                                    onPressed: () {
                                      print("Today's today");
                                      isToday = true;
                                      showToday();
                                    },
                                    child: const Text(
                                      "AUJOUD'HUI",
                                      style: TextStyle(fontWeight: FontWeight.bold),
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
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                     selectTodayTime =newValue!;
                                  });
                                  var nw=selectTodayTime.substring(0,2);
                                  var a=selectTodayTime.substring(3,5);
                                  DateTime startTime2 = DateTime(now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
                                  selectTime=DateFormat('dd-MM-yyyy  k:mm').format(startTime2);
                                },
                                items: todayTime
                                    .map<DropdownMenuItem<String>>((String value) {
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
                          onPressed: (){
                            var nw=selectTodayTime.substring(0,2);
                            var a=selectTodayTime.substring(3,5);
                            DateTime startTime2 = DateTime(now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
                            var selectTime1=DateFormat('dd-MM-yyyy  k:mm').format(startTime2);
                            Navigator.of(context).pop();
                            setState(() {
                              chooseTime =selectTime??selectTime1;
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
            }
          );
          //   AlertDialog(
          //   shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(
          //           Radius.circular(10))),
          //   contentPadding:
          //   const EdgeInsets.only(
          //       top: 2,
          //       bottom: 0,
          //       right: 0,
          //       left: 0),
          //   content: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Container(
          //         decoration:
          //         const BoxDecoration(
          //           borderRadius:
          //           BorderRadius.only(
          //               topLeft: Radius
          //                   .circular(5),
          //               topRight:
          //               Radius.circular(
          //                   5)),
          //           color: Color(0xA30A9518),
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text(
          //               ' souhaitez vous etre livrer ?',
          //               style: TextStyle(
          //                   color:
          //                   Colors.white),
          //             ),
          //             IconButton(
          //                 onPressed: () {
          //                   Navigator.of(
          //                       context)
          //                       .pop();
          //                 },
          //                 icon: const Icon(
          //                   Icons.clear,
          //                   color: Colors.white,
          //                 ))
          //           ],
          //         ),
          //       ),
          //       ElevatedButton(
          //         style: ButtonStyle(
          //             backgroundColor:
          //             MaterialStateProperty
          //                 .all(Colors
          //                 .green
          //                 .shade900)),
          //         onPressed: () {
          //           showToday(context);
          //         },
          //         child:  const Text(
          //           "AUJOUD'HUI",
          //           style: TextStyle(
          //               fontWeight:
          //               FontWeight
          //                   .bold),
          //         ),
          //       ),
          //       Row(
          //         children: const [
          //           Expanded(child: Divider()),
          //           Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: Text('Ou'),
          //           ),
          //           Expanded(child: Divider()),
          //         ],
          //       ),
          //       ElevatedButton(
          //           style: ButtonStyle(
          //               backgroundColor:
          //               MaterialStateProperty
          //                   .all(Colors
          //                   .green
          //                   .shade900)),
          //           onPressed: () {
          //             showTomorrow(context);
          //           },
          //           child: const Text(
          //             "DEMAIN",
          //             style: TextStyle(
          //                 fontWeight:
          //                 FontWeight.bold),
          //           )),
          //     ],
          //   ),
          // );

        });
  }

  showTomorrow() {

    Navigator.of(context).pop();
    showDialog<void>(
        context: context,
        builder: (context) {
          dateFormat =DateFormat.Hm();
          DateTime startTime1 = DateTime(now.year, now.month, now.day, 8, 30, 0);
          String nextStart = dateFormat.format(startTime1);
          var selectTime;
          return StatefulBuilder(
              builder: (context, setStateSB) {
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
                                          backgroundColor: MaterialStateProperty.all(
                                              const Color(0xff00a117))),
                                      onPressed: () {
                                        print("Tomorrow's today");
                                        isToday = true;
                                        showToday();
                                      },
                                      child: const Text(
                                        "AUJOUD'HUI",
                                        style: TextStyle(fontWeight: FontWeight.bold),
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
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold),
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
                                    var nw=nextStart.substring(0,2);
                                    var a=nextStart.substring(3,5);
                                    DateTime startTime2 = DateTime(now.year, now.month, now.day+1, int.parse(nw), int.parse(a), 0);
                                    selectTime=DateFormat('dd-MM-yyyy  k:mm').format(startTime2);
                                    // print(selectTime);
                                  },
                                  items: timeSlots
                                      .map<DropdownMenuItem<String>>((String value) {
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
                            onPressed: (){
                              var nw=nextStart.substring(0,2);
                              var a=nextStart.substring(3,5);
                              DateTime startTime2 = DateTime(now.year, now.month, now.day, int.parse(nw), int.parse(a), 0);
                              var selectTime1=DateFormat('dd-MM-yyyy k:mm').format(startTime2);
                              Navigator.of(context).pop();
                              setState(() {
                                chooseTime = selectTime??selectTime1;
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
                                child: Icon(Icons.close, color:  Colors.white),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    // print(' times ${selectTodayTime}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valider Panier'),
        backgroundColor: const Color(0xff00a117),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Theme(
              data: ThemeData(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: const Color(0xff00a117))),
              child: Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails detail) {
                  return _currentStep >= 3
                      ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff00a117))),
                          onPressed: () {},
                          child: const Text(
                            "COMMANDER",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff00a117))),
                          onPressed: detail.onStepContinue,
                          child: const Text(
                            "CONTINUER",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ));
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
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio<Contact>(
                              activeColor: const Color(0xff00a117),
                              value: Contact.moi,
                              groupValue: _contact,
                              onChanged: (Contact? value) {
                                setState(() {
                                  _contact = value;
                                });
                              },
                            ),
                            const Text('Moi'),
                            Radio<Contact>(
                              activeColor: const Color(0xff00a117),
                              value: Contact.autre,
                              groupValue: _contact,
                              onChanged: (Contact? value) {
                                setState(() {
                                  _contact = value;
                                });
                              },
                            ),
                            const Text('Autre'),
                          ],
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Nom et prenom *'),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Telephone 1 *'),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Telephone 2 *'),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Email *'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text("Informationd'adresse "),
                    content: Column(
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
                                                        color: Color(0xff00a117)),
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
                                icon: const Icon(Icons.place))
                          ],
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Douala '),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Quartier *'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Description du lieu *'),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Adresse geolocalisee *'),
                        ),
                        Visibility(
                            visible: isChecked,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Titre d'adresse *"),
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Ex: Maison, Bureau',
                                      style: TextStyle(color: Colors.black26),
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
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        )
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text('Heure de livraison'),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Description du colis *'),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _deliveryType = DeliveryType.express;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<DeliveryType>(
                                    activeColor: const Color(0xff00a117),
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
                              ),
                            ),
                            GestureDetector(
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
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(5)),
                                                      color: Color(0xff00a117),
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
                                                                .all(const Color(0xff00a117))),
                                                    onPressed: () {
                                                      showToday();
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
                                                                  .all(const Color(0xff00a117))),
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
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CircleAvatar(
                                                      radius: 14.0,
                                                      backgroundColor:
                                                       Color(0xff00a117),
                                                      child: Icon(Icons.close,
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
                                    activeColor: const Color(0xff00a117),
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
                          child: const Text("Resume"),
                          alignment: Alignment.centerLeft,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Montant du panier: '),
                            Text(cartProvider.totalPrice.toString() + 'FCFA')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Livraison: '),
                            Text('1000' + 'FCFA')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total: '),
                            Consumer<Cart>(
                              builder: (_, cart, child) => Text(
                                cart.totalAmount.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: const Text("Promotion")),
                        const Divider(
                          thickness: 1.3,
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
                            children: const [
                              Icon(Icons.attachment_outlined),
                              Text('Ajouter un code promo'),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child: const Text("Mode de Paiement"),
                        ),
                        const Divider(
                          thickness: 1.3,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                          title: const Text('Paiement a la livraison'),
                          value: isChecked,
                          onChanged: (value) {
                            if (isChecked1 == true) {
                              setState(() {
                                isChecked1 == false;
                              });
                            }
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                          title: const Text('payer par bancaire'),
                          value: isChecked1,
                          onChanged: (value) {
                            if (isChecked == true) {
                              setState(() {
                                isChecked == false;
                              });
                            }
                            setState(() {
                              isChecked1 = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        )
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

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
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
