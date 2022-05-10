import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('img/logo.png'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Email'),
              TextButton(
                autofocus: true,
                onPressed: (){},
                child: const Text('contact@mail.livraison-express.net'),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Numero de Telephone'),
              TextButton(
                autofocus: true,
                onPressed: (){},
                child: const Text('695461461 / 674527527'),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: const [
              Text('Version:1.15(18)'),
              Text('2018-2019 Livraison Express'),
              Text('Tous droits reserves'),
            ],
          )
        ],
      ),
    );
  }
}
