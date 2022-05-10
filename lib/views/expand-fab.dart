import 'package:flutter/material.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
     const MaterialApp(
      home: FancyFab(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
class FancyFab extends StatefulWidget {
  const FancyFab({Key? key}) : super(key: key);

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _animateColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;
  String message = '';
  DateTime now = DateTime.now();
  var midi = const TimeOfDay(hour: 12, minute: 0);

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.white,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    DateTime startTime = DateTime(now.year, now.month, now.day, 12, 10, 0);
    if(now.isBefore(startTime)){
      message = 'Bonjour ! S\'il vous plait j\'ai une préocupation';
    }else{
      message= "Bonne après midi !S'il vous plait j'ai une préocupation";
    }
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: 'toggle',
      backgroundColor: _animateColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: isOpened?const Icon(Icons.clear,color: Colors.black,):CircleAvatar(
        backgroundColor: Colors.white,
        radius: 27,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              'img/call.png',
              height: 53,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
  Widget sms() {
    return  FloatingActionButton(
      heroTag: 'sms',
      onPressed: ()async{
        launchSMS(phone: 655418165, message: message);
      },
      tooltip: 'Sms',
      child: Icon(Icons.sms),
    );
  }
  Widget whatsapp() {
    return  FloatingActionButton(
      heroTag: 'whatsapp',
      onPressed: (){
        launchWhatsApp(phone: 00237655418165, message: message);
      },
      tooltip: 'Whatsapp',
      child: const Icon(Icons.whatsapp),
    );
  }
  Widget messenger() {
    return const FloatingActionButton(
      heroTag: 'messenger',
      onPressed: null,
      tooltip: 'Messenger',
      child: Icon(Icons.mms),
    );
  }
  Widget _call() {
    return  FloatingActionButton(
      heroTag: 'image',
      onPressed: (){
        launch('tel:+237655418165');
      },
      tooltip: 'Image',
      child: Icon(Icons.call),
    );
  }
  Widget inbox() {
    return const FloatingActionButton(
      heroTag: 'inbox',
      onPressed: null,
      tooltip: 'Inbox',
      child: Icon(Icons.inbox),
    );
  }

  void launchWhatsApp(
      {required int phone,
        required String message,
      }) async {
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void launchSMS(
      {required int phone,
        required String message,
      }) async {
    String _textMe() {
      if (Platform.isAndroid) {
        String uri = 'sms:$phone?body=$message%20there';
        return uri;
      } else if (Platform.isIOS) {
        // iOS
        String uri = 'sms:$phone&body=$message%20there';
        return uri;
      }
      else{
        return 'error';
      }
    }

    if (await canLaunch(_textMe())) {
      await launch(_textMe());
    } else {
      throw 'Could not launch ${_textMe()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform(
            transform: Matrix4.translationValues(
                _translateButton.value*2.0,
                0,
                0),
            child: _call()),
        Transform(
            transform: Matrix4.translationValues(
                _translateButton.value*1.0,
                0,
                0),
            child: sms()),
        toggle(),
        Transform(
            transform: Matrix4.translationValues(
                _translateButton.value* -6.0,
                0,
                0),
            child: whatsapp()),
        Transform(
            transform: Matrix4.translationValues(
                _translateButton.value*3.0,
                0,
                0),
            child: messenger()),
      ],
    );
  }
}