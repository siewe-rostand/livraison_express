
import 'package:flutter/material.dart';
import 'package:livraison_express/views/product/skeleton.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/size_config.dart';

class ProductShimmerCard extends StatelessWidget {
  const ProductShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.black.withOpacity(0.04),
      child: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context,index)=>const SizedBox(height: 16,),
        itemBuilder: (context,index) {
          return Row(
            children:  [
              Container(
                margin: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: SizedBox(
                      height: getProportionateScreenHeight(60),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: getProportionateScreenHeight(80),
                  margin: const EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                           Expanded(
                            child: Skeleton(width: MediaQuery.of(context)
                                .size
                                .width*0.4,height: getProportionateScreenHeight(15),),
                          ),
                          Container(
                            height: getProportionateScreenHeight(15),
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context)
                                .size
                                .width*0.4,
                            decoration:  const BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: 1,
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        color: Colors.black38,
                      )
                    ],
                  ),
                ),
              ),

            ],
          );
        }
      ),
    );
  }
}
