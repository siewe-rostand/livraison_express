import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../data/user_helper.dart';
import '../../model/day.dart';
import '../../model/day_item.dart';
import '../../model/horaire.dart';
import '../../model/module_color.dart';

class SelectTime extends StatefulWidget {
  // final ModuleColor moduleColor;
  const SelectTime({Key? key}) : super(key: key);

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  DateTime now = DateTime.now();
  Duration step = const Duration(minutes: 10);
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  List<String> timeSlots = [];
  List<String> todayTime = [];
  late DateFormat dateFormat;
  late String selectTodayTime,nextStart;
  bool isToday = false;
   bool selected = false;
  String chooseTime = '';
  late bool isTodayOpened,isTomorrowOpened;




  showToday(BuildContext context) {
    Navigator.of(context).pop();
    Days today =UserHelper.shops.horaires!.today!;
    if(today.toString().isNotEmpty){
      List<DayItem>? item = today.items;
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
        }
      }
    }
    showDialog<void>(
        context: context,
        builder: (context) {
          dateFormat = DateFormat.Hm();
          selectTodayTime = dateFormat.format(t);
          var selectTime;
          return StatefulBuilder(builder: (context, setStateSB) {
            log("select time  $selectTodayTime, ");
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
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(5)),
                          color: UserHelper.getColorDark(),
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
                                          UserHelper.getColorDark())),
                                  onPressed: () {
                                    print("Today's today");
                                    isToday = true;
                                    showToday(context);
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
                                            UserHelper.getColorDark())),
                                    onPressed: () {
                                      print("today's tomorrow");
                                      isToday == false;
                                      showTomorrow(context);
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
                              style:  TextStyle(color: UserHelper.getColorDark()),
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
                          chooseTime = selectTime ?? selectTime1;
                          UserHelper.chooseTime=chooseTime;
                          // print("// ${UserHelper.chooseTime}");
                        },
                        child:  Text('VALIDER',style: TextStyle(color: UserHelper.getColorDark()),),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor:
                            UserHelper.getColorDark(),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }

  showTomorrow(BuildContext context) {
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
            while (openTimeStamp.isBefore(closeTimeStamp)) {
              DateTime timeIncrement = openTimeStamp.add(step);
              openTimeStamp = timeIncrement;
              timeSlots.add(DateFormat.Hm().format(timeIncrement));
            }
          }
        }
      }
    }
  nextStart = '';
    showDialog<void>(
        context: context,
        builder: (context) {
          dateFormat = DateFormat.Hm();
          DateTime startTime1 =
          DateTime(now.year, now.month, now.day, 8, 30, 0);
          var selectTime;
          nextStart=timeSlots.first;
          print('build');
          return StatefulBuilder(builder: (context, setStateSB) {
            List<String> se=[];
            se.add(nextStart);
            print('rebuild');

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
                        decoration:  BoxDecoration(
                          borderRadius:const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(5)),
                          color: UserHelper.getColorDark(),
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
                                          UserHelper.getColorDark())),
                                  onPressed: () {
                                    print("Tomorrow's today");
                                    isToday = true;
                                    showToday(context);
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
                                            UserHelper.getColorDark())),
                                    onPressed: () {
                                      // print("tomorrow's tomorrow");
                                      showTomorrow(context);
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
                              style:  TextStyle(color: UserHelper.getColor()),
                              onChanged: (String? newValue) {
                                setStateSB(() {
                                  nextStart = newValue!;
                                  selected=true;
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
                          UserHelper.chooseTime = selectTime ?? selectTime1;
                        },
                        child: Text('VALIDER',style: TextStyle(color: UserHelper.getColorDark()),),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:  Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: UserHelper.getColorDark(),
                            child:const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
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
  void initState() {
    super.initState();
    isOpened(UserHelper.shops.horaires!);
    // print("$isTomorrowOpened //$isTodayOpened");
    isToday = false;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  color: UserHelper.getColorDark(),
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
                        .all(UserHelper.getColorDark())),
                onPressed: () {
                  if(!isTodayOpened && isTomorrowOpened) {
                    Fluttertoast.showToast(msg: "Service Momentanement indisponible");

                  }else{
                    // print("isTodayOpened/...$isTodayOpened...$isTomorrowOpened ");
                    showToday(context);
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
                          .all(UserHelper.getColorDark())),
                  onPressed: () {
                    showTomorrow(context);
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
                  UserHelper.getColorDark(),
                  child: const Icon(Icons.close,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 10)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }
}

class SelectTime1 {
  DateTime now = DateTime.now();
  Duration step = const Duration(minutes: 10);
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  List<String> timeSlots = [];
  List<String> todayTime = [];
  late DateFormat dateFormat;
  late String selectTodayTime;
  String chooseTime = '';
   showToday(BuildContext context) {
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
              showDialog<void>(
                  context: context,
                  builder: (context) {
                    dateFormat = DateFormat.Hm();
                    selectTodayTime = dateFormat.format(t);
                    var selectTime;
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
                                            // isToday = true;
                                            showToday(context);
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
                                              // isToday == false;
                                              showTomorrow(context);
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
                                        selectTodayTime = newValue!;
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
                                  chooseTime = selectTime ?? selectTime1;

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
            }
          }
        });
      }
    }
  }
  showTomorrow(BuildContext context) {
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
                                            // isToday = true;
                                            showToday(context);
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
                                              showTomorrow(context);
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
                                  setStateSB(() {
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
}
