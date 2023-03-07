
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerCard extends StatelessWidget {
  const CategoryShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 8,
                child:  Container(
                  height: 20,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration:  const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              );
            }),
        baseColor: Colors.grey,
        highlightColor: Colors.black.withOpacity(0.04),
    );
  }
}
