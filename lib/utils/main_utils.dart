import 'package:flutter/cupertino.dart';

import '../model/magasin.dart';
 const onFailureMessage =
    "Veuillez vérifier votre connexion internet puis réessayez. Si le problème persiste, veuillez contacter le service technique.";
 const onErrorMessage="Nous rencontrons actuellement des problèmes lies à cette opération. Veuillez réessayer plustard ou contactez le service technique.";

class MainUtils {
  static hideKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }

  static isOpened(List<Magasin> magasins, bool isTodayOpened) {
    for (Magasin magasin in magasins) {
      if (magasin.horaires != null) {
        if (magasin.horaires!.today != null) {
          List<DayItem>? itemsToday = magasin.horaires?.today?.items;
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
              DateTime openTimeStamp = DateTime(now.year, now.month, now.day,
                  int.parse(nw!), int.parse(a!), 0);
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
      }
    }
  }
}
