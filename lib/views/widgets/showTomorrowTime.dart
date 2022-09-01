import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/views/widgets/showTodayTime.dart';

class ShowTomorrowTime extends StatefulWidget {
  const ShowTomorrowTime({Key? key}) : super(key: key);

  @override
  State<ShowTomorrowTime> createState() => _ShowTomorrowTimeState();
}

class _ShowTomorrowTimeState extends State<ShowTomorrowTime> {
  bool isToday = false;
  DateTime now = DateTime.now();
  late String selectTodayTime;
  late String nextStart;
  List<String> timeSlots = [];
  Duration step = const Duration(minutes: 10);
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  String chooseTime = '';
  var selectTime;
  late DateFormat dateFormat;
  isOpenTomorrow(){
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
  }
  @override
  void initState() {

    DateTime startTime1 =
    DateTime(now.year, now.month, now.day, 8, 30, 0);
    nextStart = dateFormat.format(startTime1);
    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 20, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 20, 30, 0);
    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      startTime = timeIncrement;
      timeSlots.add(DateFormat.Hm().format(timeIncrement));
    }
    print('init');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('build');
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
                            const ShowTodayTime(chooseTime: '',);
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
                              const ShowTomorrowTime();
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
                        setState(() {
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
  }

  timeAlertDialog(){
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
                            // showToday(chooseTime);
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
                              // showTomorrow(chooseTime);
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
                        setState(() {
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
  }
}

extension on DateTime {
DateTime roundDown({Duration delta = const Duration(minutes: 10)}) {
  return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
}
}
