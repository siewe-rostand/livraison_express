import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';
import '../../model/city.dart';
import '../../utils/size_config.dart';

class SelectCity extends StatefulWidget {
  final List<City> cities;
  final OnCitySelected citySelected;
   const SelectCity({Key? key,required this.cities, required this.citySelected}): super(key: key);

  @override
  _SelectCityState createState() => _SelectCityState();
}
typedef OnCitySelected = void Function(City city);
class _SelectCityState extends State<SelectCity> {
  String city = "DOUALA";

  @override
  void initState() {
    init();
    super.initState();
  }
  init()async{
    if(widget.cities.isNotEmpty) {
      city = widget.cities[0].name!;
      UserHelper.city=widget.cities[0];
    }
    city =await UserHelper.getCity();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        if(widget.cities.isNotEmpty)_showMenu();
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  margin:  EdgeInsets.only(top: getProportionateScreenHeight(6)),
                  child:  Icon(Icons.location_on_rounded,size: getProportionateScreenHeight(40),color: Colors.black45,),
                ),
                Text(
                  city.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w800
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.black45,),
          ],
        ),
      ),
    );
  }

  getPopupMenuItems() {
    List<PopupMenuItem<String>> popupMenu = [];
    for (int i = 0; i < widget.cities.length; i++) {
      String item = widget.cities[i].name!;
      UserHelper.city=widget.cities[i];
      popupMenu.add(PopupMenuItem<String>(
        value: item,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: Text(item.toUpperCase()))),
      ));
    }
    return popupMenu;
  }

  _showMenu() async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
          getProportionateScreenWidth(100),
          getProportionateScreenHeight(100),
          100,
          100),
      items: getPopupMenuItems(),
    );

    if(selected != null){
      setState(() {
        city = selected;
      });
      pref.setString('city', city);
      debugPrint("///++$selected");
      City objectCity=City();
      for (var element in widget.cities) {
        if(element.name?.toLowerCase() == city.toLowerCase()){
          objectCity = element;
        }
      }
      if(objectCity.toString().isNotEmpty) {
        UserHelper.city=objectCity;
        widget.citySelected(objectCity);
      }
    }
  }
}