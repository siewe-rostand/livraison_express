
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../utils/size_config.dart';


class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({Key? key}) : super(key: key);

  @override
  State<CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int activeIndex=0;
  List<String> imgList=[
    "img/supermarche/beurre.png",
    "img/supermarche/chocolate.jpg",
    "img/supermarche/mayonnaise.png",
    "img/supermarche/vin.png",
    "img/supermarche/whisky_chanceler.png",
  ];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            for(var image in imgList)Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(image, fit: BoxFit.cover, width: 1000.0,height: getProportionateScreenHeight(180),),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(image)} image',
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: getProportionateScreenHeight(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
          options: CarouselOptions(
            height: getProportionateScreenHeight(150),
            aspectRatio: 2.0,
            autoPlay: true,
            enlargeCenterPage: true,
            // onPageChanged: (index,reason){
            //   setState(() {
            //     activeIndex=index;
            //   });
            // }
          ),
        ),
        //indicator

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: imgList.map((url) {
        //     int index = imgList.indexOf(url);
        //     return Container(
        //       width: 8.0,
        //       height: 8.0,
        //       margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: activeIndex == index
        //             ? Colors.blue
        //             : const Color.fromRGBO(0, 0, 0, 0.4),
        //       ),
        //     );
        //   }).toList(),
        // ),
      ],
    );
  }
}

