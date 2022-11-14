
import 'dart:async';
import 'dart:io';

import 'package:livraison_express/utils/main_utils.dart';

String handleException(Object e){
  print(e);
  if(e is SocketException){
    print('SocketException error');
    return onFailureMessage;
  }
  else if(e is TimeoutException){
    print('TimeoutException error');
    return onFailureMessage;
  }
  else {
    print('default error');
    return onErrorMessage;
  }
}


class NoInternetException {
  String message;
  NoInternetException(this.message);
}

class NoServiceFoundException {
  String message;
  NoServiceFoundException(this.message);
}

class InvalidFormatException {
  String message;
  InvalidFormatException(this.message);
}

class UnknownException {
  String message;
  UnknownException(this.message);
}