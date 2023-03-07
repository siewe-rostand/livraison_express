
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livraison_express/utils/size_config.dart';

typedef SelectCardCallback = void Function(int option);
class RestauHome extends StatelessWidget {
  final SelectCardCallback callback;
  RestauHome(this.callback);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(400),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    height: getProportionateScreenHeight(250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF89dad0),
                      image: const DecorationImage(
                          image: AssetImage('img/supermarche/resto.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
//------------------------------------------------------------------------------
// Slide Information 🚩
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      height: getProportionateScreenHeight(220),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 0.7,
                              offset: const Offset(1, 4))
                        ],
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
//------------------------------------------------
// Slider title
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(20),
                                  vertical: getProportionateScreenHeight(20)),
                              child:
                                  const Text('Veuillez choisir une addresse de livraison'),
                            ),
                            Container(
                              height: getProportionateScreenHeight(1),
                              color: Colors.grey,
                            ),
                            cardItems(svgIcon: "img/icon/svg/ic_current_position.svg", title: 'Ma position actuelle', onPress: ()=>callback(0)),
                            Container(
                              height: getProportionateScreenHeight(1),
                              color: Colors.grey,
                            ),
                            cardItems(svgIcon: "img/icon/svg/ic_address.svg", title: "Consultez ma liste d'adresses", onPress: ()=>callback(1)),
                            Container(
                              height: getProportionateScreenHeight(1),
                              color: Colors.grey,
                            ),
                            cardItems(svgIcon: 'img/icon/svg/ic_map_location.svg', title: 'Choisir une adresse sur la carte', onPress: ()=>callback(2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  cardItems({required String svgIcon, required String title, required Function() onPress}){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(10)),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          onPressed:onPress,
          child: Row(
            children: [
              SvgPicture.asset(
                svgIcon,
                height: 25,
                color: Colors.grey[700],
              ),
              SizedBox(width: getProportionateScreenWidth(10),),
              Expanded(child: Text(title,style: TextStyle(color: Colors.grey[700]),))
            ],
          ),
        )
    );
  }
}
