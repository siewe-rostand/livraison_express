import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MySession{
  static saveValue(String key, value)async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
  // static String encodeList(List<Store> musics) => json.encode(
  //   musics
  //       .map<Map<String, dynamic>>((music) => Store.toJson(music))
  //       .toList(),
  // );
  //
  // static List<Store> decodeList(String musics) =>
  //     (json.decode(musics) as List<dynamic>)
  //         .map<Store>((item) => Store.fromJson(item))
  //         .toList();
}