import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/utils/size_config.dart';
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
  final Curve _curve = Curves.easeOut;
  late Animation<Offset> _offsetLeftAnimation;
  late Animation<Offset> _offsetRightAnimation;
  String message = '';
  DateTime now = DateTime.now();
  int phone = 00237657634414;
  var midi = const TimeOfDay(hour: 12, minute: 0);

  @override
  initState() {
    _animationController =AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this
    );
    _offsetLeftAnimation = Tween<Offset>(
        begin: const Offset(10.0, 0.0),
        end: Offset.zero
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease
    ));
    _offsetRightAnimation = Tween<Offset>(
      begin: const Offset(-10.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease
    ));
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

    DateTime startTime = DateTime(now.year, now.month, now.day, 12, 10, 0);
    if(now.isBefore(startTime)){
      message = 'Bonjour ! S\'il vous plait j\'ai une préoccupation';
    }else{
      message= "Bonne après midi !S'il vous plait j'ai une préoccupation";
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
      child: isOpened?SvgPicture.asset('img/icon/svg/ic_cross.svg'):CircleAvatar(
        backgroundColor: Colors.white,
        radius: 27,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: SvgPicture.asset('img/icon/svg/ic_call_center.svg')),
      ),
    );
  }
  Widget sms() {
    return  SizedBox(
      height: getProportionateScreenHeight(45),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'sms',
        onPressed: ()async{
          launchSMS(phone: phone, message: message);
        },
        tooltip: 'Sms',
        child: SvgPicture.asset('img/icon/svg/ic_message.svg',height: getProportionateScreenHeight(25),),
      ),
    );
  }
  Widget whatsapp() {
    return  SizedBox(
      height: getProportionateScreenHeight(45),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'whatsapp',
        onPressed: (){
          launchWhatsApp(phone: phone, message: message);
        },
        tooltip: 'Whatsapp',
        child: SvgPicture.asset('img/icon/svg/ic_whatsapp.svg',height: getProportionateScreenHeight(25),),
      ),
    );
  }
  Widget messenger() {
    return  SizedBox(
      height: getProportionateScreenHeight(45),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'messenger',
        onPressed: (){
          launchMessenger(message: message);
        },
        tooltip: 'Messenger',
        child: SvgPicture.asset('img/icon/svg/ic_messenger.svg',height: getProportionateScreenHeight(25),),
      ),
    );
  }
  Widget _call() {
    return  SizedBox(
      height: getProportionateScreenHeight(45),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'phone',
        onPressed: (){
          launchUrl(Uri.parse('tel:$phone'));
        },
        tooltip: 'phone',
        child: SvgPicture.asset('img/icon/svg/ic_phone_call.svg',height: getProportionateScreenHeight(25),),
      ),
    );
  }
  Widget inbox() {
    return  SizedBox(
      height: getProportionateScreenHeight(45),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: 'inbox',
        onPressed: null,
        tooltip: 'Inbox',
        child: SvgPicture.asset('img/icon/svg/ic_messenger.svg',height: getProportionateScreenHeight(25),),
      ),
    );
  }

  void launchWhatsApp(
      {required int phone,
        required String message,
      }) async {
    try {
      String url() {
        if (Platform.isAndroid) {
          // add the [https]
          return "whatsapp://send?phone=$phone&text=$message"; // new line
        } else {
          // add the [https]
          return "https://wa.me/$phone?text=${Uri.parse(message)}"; // new line
        }
      }

      String uri = url();
      var encoded = Uri.encodeFull(uri);
      Uri whatsAppUri = Uri.parse(encoded);
      if (await canLaunchUrl(whatsAppUri)) {
        await launchUrl(whatsAppUri);
      } else {
        throw 'Could not launch ${url()}';
      }
    }  catch (e) {
      showToast(context: context, text: "L'application whatsapp n'est pas installé dans cette appareil.",color: Colors.blueGrey);
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

    if (await canLaunchUrl(Uri.parse(_textMe()))) {
      await launchUrl(Uri.parse(_textMe()));
    } else {
      throw 'Could not launch ${_textMe()}';
    }
  }

  void launchMessenger(
      {required String message,}) async {
    String facebookIdHere = "2181930825226674";
    try {
      String url() {
        if (Platform.isAndroid) {
          String uri = 'fb-messenger://user/$facebookIdHere';
          return uri;
        } else if (Platform.isIOS) {
          // iOS
          String uri = 'https://m.me/$facebookIdHere';
          return uri;
        }
        else{
          return 'error';
        }
      }

      if (await canLaunchUrl(Uri.parse(url()))) {
        await launchUrl(Uri.parse(url()));
      } else {
        throw 'Could not launch ${url()}';
      }
    } catch (e) {
      showToast(context: context, text: "L'application Messenger n'est pas installé dans cette appareil.",color: Colors.blueGrey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(position: _offsetRightAnimation,
          child: Row(
            children: [
              Container(
                margin:const EdgeInsets.all(5),
                  child: _call()),
              sms()
            ],
          ),
        ),
        toggle(),
        SlideTransition(position: _offsetLeftAnimation,
          child:Row(
            children: [
              Container(
                margin:const EdgeInsets.only(left: 3),
                  child: messenger()),
              Container(
                margin: const EdgeInsets.only(left: 5),
                  child: whatsapp())
            ],
          ) ,
        )
      ],
    );
  }
}