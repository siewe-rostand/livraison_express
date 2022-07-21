import 'dart:developer';

import 'package:flutter/material.dart';



class InputFormField extends StatelessWidget {
  const InputFormField({
    Key? key,
    required this.fieldName,
    required this.obscure,
    required this.validator,
    required this.controller,
  }) : super(key: key);

  final String fieldName;
  final bool obscure;
  final Function validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        return validator(value);
      },
      decoration: InputDecoration(
        hintText: fieldName,
        hintStyle: const TextStyle(fontSize: 13),
      ),
      obscureText: obscure,
    );
  }
}

class ProgressDialog extends StatelessWidget {
  final String? status;
  const ProgressDialog({Key? key,this.status}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
              ),
              const SizedBox(
                width: 25,
              ),
              Text(
                status!,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  final String label;
  final Icon icon;
  final bool obscure;
  final TextEditingController controller;
  const InputTextField(
      {Key? key,required this.label,
        required this.icon,
        required this.controller,
        required this.obscure}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
        ),
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String? value) {
          return value!.length < 4 ? 'Enter a valid Email-Id' : null;
        },
      ),
    );
  }
}

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 165,
            child: DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
                  //TODO 1: User photo should be here
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Profile Name',
                        // TODO 2: User Name should be here
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Visit Profile',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ), //Drawer Header
          const ListTile(
            leading: Icon(Icons.electric_car_rounded),
            title: Text(
              'Rent my Car',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'History',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text(
              'About us',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class AvailabilityButton extends StatelessWidget {
  final String text;
  final Color color;

  const AvailabilityButton({Key? key,required this.text, required this.color}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ConfirmSheetButton extends StatelessWidget {
  final String title;
  final Color color;

  const ConfirmSheetButton({Key? key,
    required this.title,
    required this.color,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Container(
        // height: 50.0,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final String pageHeader;
  const CustomBackButton({Key? key, required this.pageHeader}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                pageHeader,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleScaffold extends StatelessWidget {
  final List<Widget> children;
  final List<String> tags;
  final String title;
  final EdgeInsets? padding;
  const ExampleScaffold({
    Key? key,
    this.children = const [],
    this.tags = const [],
    this.title = '',
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60),
            Padding(
              child: Text(title, style: Theme.of(context).textTheme.headline5),
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
            SizedBox(height: 4),
            Padding(
              child: Row(
                children: [
                  for (final tag in tags) Chip(label: Text(tag)),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
            SizedBox(height: 20),
            if (padding != null)
              Padding(
                padding: padding!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              )
            else
              ...children,
          ],
        ),
      ),
    );
  }
}

class LoadingButton extends StatefulWidget {
  final Future Function()? onPressed;
  final String text;

  const LoadingButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12)),
            onPressed:
            (_isLoading || widget.onPressed == null) ? null : _loadFuture,
            child: _isLoading
                ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ))
                : Text(widget.text),
          ),
        ),
      ],
    );
  }

  Future<void> _loadFuture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed!();
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error $e')));
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}