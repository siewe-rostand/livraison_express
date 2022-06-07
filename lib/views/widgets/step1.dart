
import 'package:flutter/material.dart';
class Step1{
  static validateStep1(){
    String? validateEmail(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validateName(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validatePassword(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validatePhone(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validateQuarter(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validateAddress(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }
    String? validateTitle(String value){
      if(value.isEmpty){
        return "Veuillez remplir ce champ";
      }else {
        return null;
      }
    }


  }
}
