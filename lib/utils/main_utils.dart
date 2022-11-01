import 'package:flutter/cupertino.dart';

 const onFailureMessage =
    "Veuillez vérifier votre connexion internet puis réessayez. Si le problème persiste, veuillez contacter le service technique.";
 const onErrorMessage="Nous rencontrons actuellement des problèmes lies à cette opération. Veuillez réessayer plustard ou contactez le service technique.";

class MainUtils {
  static hideKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }


}
