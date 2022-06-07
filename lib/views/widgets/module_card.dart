import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/auto_gene.dart';

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.modules, required this.isAvailableInCity}) : super(key: key);
  final Modules modules;
  final bool isAvailableInCity;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.displayMedium;
    return Container(
      height: 80,
      width: 80,
      decoration:
      const BoxDecoration(border:Border(
        bottom: BorderSide(color: Colors.black38),
        right: BorderSide(color: Colors.black38)
      )),
      child: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(modules.image!,height: 80,width: 80,color: isAvailableInCity == false?Colors.grey:null,),
              Text(
                modules.libelle!,
                style: const TextStyle(
                  color: Color(0xff37474F),
                ),
              ),
            ]),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({Key? key, required this.modules, required this.isAvailableInCity}) : super(key: key);
  final Modules modules;
  final bool isAvailableInCity;

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Container(
          height: 90,
          decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 0.5)),
          child: Card(
              color: Colors.white,
              child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(modules.image!,height:85,color: isAvailableInCity == false?Colors.grey:null,),
                      Text(
                        modules.libelle!,
                        style: const TextStyle(
                          color: Color(0xff37474F),
                        ),
                      ),
                    ]),
              )),
        ));
  }
}