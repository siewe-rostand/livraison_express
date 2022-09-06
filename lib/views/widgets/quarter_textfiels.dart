import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../model/quartier.dart';

class QuarterTextField extends StatelessWidget {
  const QuarterTextField({Key? key, required this.quarterTextController, required this.city}) : super(key: key);
 final TextEditingController quarterTextController;
 final String city;

  @override
  Widget build(BuildContext context) {
    final quarter = Provider.of<QuarterProvider>(context);
    return TypeAheadFormField<String>(
      textFieldConfiguration:  TextFieldConfiguration(
        controller: quarterTextController,
        decoration: const InputDecoration(
            labelText: 'Quartier'),
      ),
      suggestionsCallback: (String pattern) async {
        if(pattern.isEmpty){
          return const Iterable<String>.empty();
        }
        return quarter.getQuarter(city)
            .where((String quarter) => quarter
            .toLowerCase().split(' ').any((word) =>word.startsWith(pattern
            .toLowerCase()) )
        )
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
      onSaved: (value)=>quarterTextController.text=value!,
      autoFlipDirection: true,
      hideOnEmpty: true,
    );
  }
}
