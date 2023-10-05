
import 'package:flutter/material.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/orders.dart';

class OrderStatusDialog extends StatelessWidget {
  const OrderStatusDialog({Key? key, required this.command}) : super(key: key);
  final Command command;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(
        'Détail'.toUpperCase(),
        style: const TextStyle(color: primaryColor),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Reference'),
                controller: TextEditingController(text: command.infos?.ref),
              ),
              TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.black38),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Status'),
                controller:
                    TextEditingController(text: command.infos?.statutHuman),
              ),
              TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.black38),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Quartier Depart'),
                controller: TextEditingController(
                    text: command.sender?.addresses![0].quarter),
              ),
              TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.black38),
                enabled: false,
                decoration:
                    const InputDecoration(labelText: 'Quartier Livraison'),
                controller: TextEditingController(
                    text: command.receiver?.addresses![0].quarter),
              ),
              TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.black38),
                enabled: false,
                decoration: const InputDecoration(labelText: 'Somme Total'),
                controller: TextEditingController(
                    text: command.paiement?.totalAmount.toString()),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'FERMER',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black38),
                )),
          )
        ],
      )
    );
  }
}
