import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';
import 'package:google_api_headers/google_api_headers.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String googleApikey = "AIzaSyBn_LS3TTqaSsByi5U7poZjoFLB8Egi2Kk";
  Set<Marker> markers = {};
  CameraPosition initialPosition =
  const CameraPosition(target: LatLng(4.0511, 9.7679));
  CameraPosition? cameraPosition;
  GoogleMapController? mapController;
  Position? _currentPosition;
  final startAddressController = TextEditingController();
  String location = "Search Location";
  final sessionToken = const Uuid().v4();
  LatLng startLocation = const LatLng(4.0511, 9.7679);

  GoogleMapController? _controller;


  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }
  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;

  }
   getPos()async{

   }
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
    debugPrint('position');

    return await Geolocator.getCurrentPosition().then((Position position) async{
      print(position.latitude);
      return position;
    }).catchError((onError){
      print(onError);
    });
  }
  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: googleApikey,
      onError: onError,
      mode: Mode.overlay,
      language: "fr",
      region: 'CM',
      sessionToken: sessionToken,
      types: [],
      offset: 0,
      strictbounds: false,
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "cm")],
    );

    displayPrediction(p, context);
  }
  Future<void> displayPrediction(Prediction? p, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: googleApikey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      setState(() {
        location = p.description!;
        //move map camera to selected place with animation
        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,lng), zoom: 17)));
        markers.add(
          Marker(
              markerId: MarkerId(startLocation.toString()),
              position: LatLng(lat,lng),
              icon: BitmapDescriptor.defaultMarker),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    print('l/l/');
    setState(() {

      getPos();
    });
    print('lll');
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> Restaurant()));
          },
          child: const Icon(Icons.check),
        ),
        body: Stack(children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            markers: Set<Marker>.from(markers),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false, //enable Zoom in, out on map
            initialCameraPosition: initialPosition,
            mapType: MapType.normal, //map type
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          //search autocomplete input
          Positioned(
            //search input bar
              top: 10,
              child: GestureDetector(
                onTap: _handlePressButton,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: Text(
                            location,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: const Icon(Icons.search),
                          dense: true,
                        )),
                  ),
                ),
              )),

          // Show current location button
          SafeArea(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange.shade100, // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
                        print(_currentPosition);
                        var loc = LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude);
                        markers.add(
                          Marker(
                              markerId: MarkerId(startLocation.toString()),
                              position: loc,
                              icon: BitmapDescriptor.defaultMarker),
                        );
                        print('new loc $loc');
                        _determinePosition();
                        mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition?.latitude ?? 0.0,
                                _currentPosition?.longitude ?? 0.0,
                              ),
                              zoom: 14.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
        // Stack(
        //   children: [
        //     GoogleMap(
        //       markers: Set<Marker>.from(markers),
        //         initialCameraPosition: CameraPosition(
        //           zoom: 14,
        //           target: startLocation
        //         ),
        //       myLocationEnabled: true,
        //       mapToolbarEnabled: false,
        //       mapType: MapType.normal,
        //       zoomControlsEnabled: true,
        //       zoomGesturesEnabled: true,
        //       onMapCreated: ( controller){
        //         setState(() {
        //           mapController = controller;
        //         });
        //
        //       },
        //       onCameraMove: (CameraPosition position){
        //         cameraPosition = position;
        //       },
        //       onCameraIdle: ()async{
        //         List<Placemark> placemarks =await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
        //         setState(() {
        //           location =placemarks.first.administrativeArea.toString() + ' , ' + placemarks.first.street.toString();
        //         });
        //       },
        //     ),
        //
        //     Positioned(
        //       child: InkWell(
        //         onTap: () async{
        //           var place = await PlacesAutocomplete.show(
        //               context: context,
        //               apiKey: googleApikey,
        //               mode: Mode.overlay,
        //               types: [],
        //               strictbounds: false,
        //               components: [Component(Component.country, 'np')],
        //               //google_map_webservice package
        //               onError: (err){
        //                 print(err);
        //               }
        //           );
        //           if(place != null){
        //             setState(() {
        //               location = place.description.toString();
        //             });
        //             //form google_maps_webservice package
        //             final plist = GoogleMapsPlaces(apiKey:googleApikey,
        //               apiHeaders: await GoogleApiHeaders().getHeaders(),
        //               //from google_api_headers package
        //             );
        //             String placeid = place.placeId ?? "0";
        //             final detail = await plist.getDetailsByPlaceId(placeid);
        //             final geometry = detail.result.geometry!;
        //             final lat = geometry.location.lat;
        //             final lang = geometry.location.lng;
        //             var newlatlang = LatLng(lat, lang);
        //             //move map camera to selected place with animation
        //             mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
        //           }
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.all(15),
        //           child: Card(
        //             child: ListTile(
        //               title: Text(location, style: TextStyle(fontSize: 16),),
        //               trailing: Icon(Icons.search),
        //               dense: true,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //
        //     // Show zoom buttons
        //     // SafeArea(
        //     //   child: Padding(
        //     //     padding: const EdgeInsets.only(left: 10.0),
        //     //     child: Column(
        //     //       mainAxisAlignment: MainAxisAlignment.center,
        //     //       children: <Widget>[
        //     //         ClipOval(
        //     //           child: Material(
        //     //             color: Colors.blue.shade100, // button color
        //     //             child: InkWell(
        //     //               splashColor: Colors.blue, // inkwell color
        //     //               child: const SizedBox(
        //     //                 width: 50,
        //     //                 height: 50,
        //     //                 child: Icon(Icons.add),
        //     //               ),
        //     //               onTap: () {
        //     //                 mapController?.animateCamera(
        //     //                   CameraUpdate.zoomIn(),
        //     //                 );
        //     //               },
        //     //             ),
        //     //           ),
        //     //         ),
        //     //         const SizedBox(height: 20),
        //     //         ClipOval(
        //     //           child: Material(
        //     //             color: Colors.blue.shade100, // button color
        //     //             child: InkWell(
        //     //               splashColor: Colors.blue, // inkwell color
        //     //               child: const SizedBox(
        //     //                 width: 50,
        //     //                 height: 50,
        //     //                 child: Icon(Icons.remove),
        //     //               ),
        //     //               onTap: () {
        //     //                 mapController?.animateCamera(
        //     //                   CameraUpdate.zoomOut(),
        //     //                 );
        //     //               },
        //     //             ),
        //     //           ),
        //     //         )
        //     //       ],
        //     //     ),
        //     //   ),
        //     // ),
        //     // Show current location button
        //     SafeArea(
        //       child: Align(
        //         alignment: Alignment.bottomRight,
        //         child: Padding(
        //           padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        //           child: ClipOval(
        //             child: Material(
        //               color: Colors.orange.shade100, // button color
        //               child: InkWell(
        //                 splashColor: Colors.orange, // inkwell color
        //                 child: SizedBox(
        //                   width: 56,
        //                   height: 56,
        //                   child: Icon(Icons.my_location),
        //                 ),
        //                 onTap: () {
        //                   mapController?.animateCamera(
        //                     CameraUpdate.newCameraPosition(
        //                       CameraPosition(
        //                         target: LatLng(
        //                           _currentPosition.latitude,
        //                           _currentPosition.longitude,
        //                         ),
        //                         zoom: 18.0,
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
