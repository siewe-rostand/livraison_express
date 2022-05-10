import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:livraison_express/views/MapView.dart';

class Restaurant extends StatefulWidget {
  const Restaurant({Key? key}) : super(key: key);

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied. we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
  List addresses = [];
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Row(
                children: const [
                  Icon(
                    Icons.soup_kitchen_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      'Bienvenue dans mon restaurant.'
                      'Commencez par choisir une adresse de livraison.',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Veuillez choisir une addresse de livraison'),
                    ),
                    const Divider(thickness: 1.5,),
                    GestureDetector(
                      onTap: () async{
                        bool serviceEnabled;
                        LocationPermission permission;
                        serviceEnabled = await Geolocator.isLocationServiceEnabled();
                        if(!serviceEnabled){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Votre localisation n'est pas activer")),
                          );
                        }
                        var loc = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        print(loc);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Icon(Icons.gps_fixed),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text('Ma position actuelle'),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 1.5,),
                    GestureDetector(
                      onTap: (){
                        showDialog<void>(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: AlertDialog(
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Align(
                                        child:  Text( ' Choisir votre adresse: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,color: Colors.blue),
                                        ),
                                        alignment: Alignment.topCenter,
                                      ),
                                      addresses.isEmpty?
                                      const Text( ' Votre liste est vide ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ):ListView.builder(
                                          itemBuilder: (context, index){
                                        return Text('draw');
                                      }
                                      ),


                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'FERMER',
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold,color: Colors.black38),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Icon(Icons.gps_fixed),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Consultez ma liste d'adresses"),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 1.5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>const MapsView()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children:  const [
                            Icon(Icons.map),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text('Choisir une adresse sur la carte '),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
