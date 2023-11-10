
import 'dart:async';
import 'dart:io';

import 'package:livraison_express/utils/main_utils.dart';

import '../data/user_helper.dart';
import '../views/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

String handleException(Object e, BuildContext context){
  print(e);
  if(e is SocketException){
    showGenDialog(
        context,
        true,
        CustomDialog(
            content: onFailureMessage,
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            }));
    return onFailureMessage;
  }
  if(e is FormatException){
    showGenDialog(
        context,
        true,
        CustomDialog(
            content: onErrorMessage,
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            }));
    return onFailureMessage;
  }
  else if(e is TimeoutException){
    showGenDialog(
        context,
        true,
        CustomDialog(
            title: 'Ooooops',
            content: onFailureMessage,
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            }));
    return onFailureMessage;
  }
  else {
    showGenDialog(
        context,
        true,
        CustomDialog(
            content: onFailureMessage,
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            }));
    return onErrorMessage;
  }
}