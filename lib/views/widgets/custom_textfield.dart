
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/main_utils.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final bool? isPassword;
  final bool? isEmail;
  final bool? validateField;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    this.inputFormatters,
    required this.labelText,
    this.keyboardType,
    this.isPassword,
    this.validateField,
    this.onChanged,
    this.autovalidateMode,
    this.prefixIcon,
    this.suffixIcon, this.isEmail,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword == true,
      obscuringCharacter: "*",
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      decoration: inputDecoration(labelText: labelText, suffixIcon: suffixIcon),
      validator: validateField == true ? (value) {
        return (value!.isEmpty || !value.contains('@') || !value.contains('.'))
            ? (isEmail == true ? 'email non valide !!' : 'Veuillez remplir ce champ !!.')
            : null;
      } : null,
      onChanged: onChanged,
    );
  }
}
