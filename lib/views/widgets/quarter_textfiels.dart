import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../model/quartier.dart';

class QuarterTextField extends StatelessWidget {
  const QuarterTextField({Key? key, required this.quarterTextController, required this.city, required this.quartier}) : super(key: key);
 final TextEditingController quarterTextController;
 final String city;
 final void Function(String?) quartier;

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return TypeAheadFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textFieldConfiguration:  TextFieldConfiguration(
        controller: quarterTextController,
        decoration: const InputDecoration(
            labelText: 'Quartier'),
      ),
      suggestionsCallback: (String pattern) async {
        if(pattern.isEmpty){
          return const Iterable<String>.empty();
        }
        return city=='Douala'|| city == "DOUALA"? quarter.quarterDouala
            .where((String quarter) => quarter
            .toLowerCase().split(' ').any((word) =>word.startsWith(pattern
            .toLowerCase()) )
        )
            .toList():quarter.quarterYaounde
            .where((item) =>
            item.toLowerCase().startsWith(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (String suggestion) {
        quarterTextController.text = suggestion;
      },
      onSaved: quartier,
      validator: (value) {
        List<String> douala = city=='Douala'|| city == "DOUALA"? quarter.quarterDouala:quarter.quarterYaounde;
        if (value!.isEmpty) {
          return "Veuillez remplir ce champ";
        }
        if (!(douala.contains(value))) {
          return "Veuillez Choisir une ville svp";
        }
        return null;
      },
      autoFlipDirection: true,
      hideOnEmpty: true,
    );
  }
}
