import 'package:flutter/material.dart';
import 'package:livraison_express/model/client.dart';

import '../../../data/user_helper.dart';
import '../../../utils/size_config.dart';
import 'horizontal_line.dart';

class ContactInfo extends StatelessWidget {
  final String title;
  final Client contact;

  const ContactInfo(this.title, this.contact,{Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: SizeConfig.screenHeight!*0.3,
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: getProportionateScreenWidth(16)),
            ),
          ),
        ),
        HorizontalLine(color: UserHelper.getColorDark(),),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              item(
                  label: 'Nom et prénom',
                  value: contact.fullName!
              ),
              item(
                  label: 'Email',
                  value: contact.email??''
              ),
              item(
                  label: 'Téléphone',
                  value: contact.telephone!
              ),
              item(
                  label: 'Quartier',
                  value: contact.addresses!.first.quarter!
              ),
              item(
                  label: 'Description',
                  value: contact.addresses!.first.description!
              ),
            ],
          ),
        )
      ],
    );
  }

  item({required String label, required String value}) {
    return TextField(
        readOnly: true,
        decoration: InputDecoration(
            labelText: '$label :', border: InputBorder.none),
        controller: TextEditingController(text: value));
  }
}