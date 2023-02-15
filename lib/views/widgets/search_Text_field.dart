
import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';

class SearchTextField extends StatefulWidget {
   const SearchTextField({Key? key, this.controller}) : super(key: key);
   final TextEditingController? controller;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
 late FocusNode focusNode;

 @override
  void initState() {
   focusNode=FocusNode();
  widget.controller?.addListener(() {
     setState(() {});
   });
   focusNode.addListener(() {
     setState(() {

     });
   });
    super.initState();
  }
  @override
  void dispose() {
    widget.controller?.dispose();
   focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor: Colors.white,
          filled: true,
          hintText: 'Rechercher',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none),
          prefixIcon: Icon(
            Icons.search,
            color: focusNode.hasFocus?UserHelper.getColor():null,
          ),
          suffixIcon: widget.controller!.text.isNotEmpty
              ? IconButton(
            color: UserHelper.getColor(),
              onPressed: () => widget.controller?.clear(),
              icon: const Icon(Icons.clear))
              : null),
    );
  }
}
