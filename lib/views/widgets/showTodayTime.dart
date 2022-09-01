import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livraison_express/views/widgets/showTomorrowTime.dart';

import '../../data/user_helper.dart';
import '../../model/day.dart';

class ShowTodayTime extends StatefulWidget {
  final String chooseTime;
  const ShowTodayTime({Key? key,required this.chooseTime}) : super(key: key);

  @override
  State<ShowTodayTime> createState() => _ShowTodayTimeState();
}

class _ShowTodayTimeState extends State<ShowTodayTime> {
  bool isToday = false;
  DateTime now = DateTime.now();
  late String selectTodayTime;
  List<String> todayTime = [];
  Duration step = const Duration(minutes: 10);
  DateTime now1 = DateTime.now().add(const Duration(minutes: 20)).roundDown();
  DateTime t = DateTime.now().add(const Duration(minutes: 30)).roundDown();
  var selectTime;
  String choose='';
  late DateFormat dateFormat;
  Days tomorrow =UserHelper.shops.horaires!.tomorrow!;
  @override
  void initState() {
    super.initState();

    choose =widget.chooseTime;
    dateFormat = DateFormat.Hm();
    selectTodayTime = dateFormat.format(t);
    DateTime endTime = DateTime(now.year, now.month, now.day, 20, 30, 0);
    while (now1.isBefore(endTime)) {
      now1;
      DateTime incr = now1.add(step);
      todayTime.add(DateFormat.Hm().format(incr));
      now1 = incr;
    }
  }
  @override
  Widget build(BuildContext context) {
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
                         * today's tomorrow time
                         */
                        ElevatedButton(
                            onPressed: () {
                              print("today's tomorrow");
                              isToday == false;
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
                      value: selectTodayTime,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 16,
                      style: const TextStyle(color: Color(0xA31236BD)),
                      onChanged: (String? newValue) {
                        setState(() {
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
                    choose = selectTime ?? selectTime1;
                  });
                  print(widget.chooseTime);
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
}
extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 10)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }
}