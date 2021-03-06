import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  String googleApikey = "AIzaSyBn_LS3TTqaSsByi5U7poZjoFLB8Egi2Kk";
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(4.0511, 9.7679));
  CameraPosition? cameraPosition;
  GoogleMapController? mapController;
  LatLng startLocation = const LatLng(4.0511, 9.7679);
  Set<Marker> markers = {};
  late Marker marker;
  Position? _currentPosition;
  final startAddressController = TextEditingController();
  String location = "Search Location";
  double? latitude;
  double? longitude;

  String _currentAddress = '';
  final sessionToken = const Uuid().v4();
  // Method for retrieving the current location
  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.checkPermission();
    BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(
        context, 'img/icon/svg/ic_location_on_black.svg');
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        markers.add(
          Marker(
              draggable: true,
              onDragEnd: (newPosition) {
                debugPrint('new pos ${newPosition}');
              },
              markerId: MarkerId(startLocation.toString()),
              position: startLocation,
              icon: bitmapDescriptor),
        );
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('ERROR'),
                content: Text('Veuillez activer la localisation svp'),
              );
            });
      }
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      debugPrint('position');
      setState(() {
        // Store the position in the variable
        _currentPosition = position;
        latitude = _currentPosition?.latitude;
        longitude = _currentPosition?.longitude;
        print('current location $_currentPosition');

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
        markers.add(
          Marker(
              markerId: MarkerId(startLocation.toString()),
              position: LatLng(latitude!, longitude!),
              icon: bitmapDescriptor,
              draggable: true,
              onDragEnd: (newPosition) {
                setState(() {
                  longitude = newPosition.longitude;
                  latitude = newPosition.latitude;
                  _getAddress();
                });
                debugPrint('new pos ${newPosition}');
              }),
        );
      });
      _getAddress();
    }).catchError((e) {
      print(e);
    });

  }
  // Method for retrieving the address

  _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(latitude!, longitude!);

      // Taking the most probable result
      Placemark place = p[0];

      setState(() {
        // Structuring the address
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Update the text of the TextField
        startAddressController.text = _currentAddress;

        // Setting the user's present location as the starting address
        location = _currentAddress.toString();
      });

      // debugPrint('new pos $_currentAddress');
    } catch (e) {
      print(e);
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
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
      region: 'cm',
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
          await _places.getDetailsByPlaceId(p.placeId!,region: 'CM');
      latitude = detail.result.geometry!.location.lat;
      longitude = detail.result.geometry!.location.lng;
      BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(
          context, 'img/icon/svg/ic_location_on_black.svg');
      setState(() {
        // location = p.description!;
        //move map camera to selected place with animation
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude!, longitude!), zoom: 17)));
        markers.add(Marker(
          draggable: true,
          onDragEnd: (newPosition) {
            longitude = newPosition.longitude;
            latitude = newPosition.latitude;
            _getAddress();
          },
          markerId: MarkerId(startLocation.toString()),
          position: LatLng(latitude!, longitude!),
          icon: bitmapDescriptor,
        ));
      });
      _getAddress();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${p.description} - $latitude/$longitude")),
      );
    }
  }

  getPos(GoogleMapController _cntlr) async {
    mapController = _cntlr;
    bool serviceEnabled;
    LocationPermission permission = await Geolocator
        .checkPermission(); // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        markers.add(
          Marker(
              draggable: true,
              onDragEnd: (newPosition) {
                debugPrint('new pos ${newPosition}');
              },
              markerId: MarkerId(startLocation.toString()),
              position: startLocation,
              icon: BitmapDescriptor.defaultMarker),
        );
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('ERROR'),
                content: Text('Veuillez activer la localisation svp'),
              );
            });
      }
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      debugPrint('position');
      setState(() {
        // Store the position in the variable
        _currentPosition = position;
        print('current location $_currentPosition');

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
        markers.add(
          Marker(
              draggable: true,
              onDragEnd: (newPosition) {
                debugPrint('new pos ${newPosition}');
              },
              markerId: MarkerId(startLocation.toString()),
              position: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              icon: BitmapDescriptor.defaultMarker),
        );
      });
      _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  initPos() async {
    BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(
        context, 'img/icon/svg/ic_location_on_black.svg');
    markers.add(
      Marker(
        draggable: true,
        onDragEnd: (newPosition) {
        },
        markerId: MarkerId(startLocation.toString()),
        position: startLocation,
        icon: bitmapDescriptor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
      _getCurrentLocation();
      initPos();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> CommandeCoursier(
            //   currentAddress: location,
            //   currentLocation: _currentPosition,
            // )));
            var data = {
              "location": location,
              "Latitude": latitude,
              "Longitude": longitude,
            };
            print('latLng // $latitude / $longitude');
            Navigator.of(context).pop(data);
          },
          child: const Icon(Icons.check),
        ),
        body: Stack(alignment: Alignment.center, children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            markers: Set<Marker>.from(markers),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false, //enable Zoom in, out on map
            initialCameraPosition: initialPosition,
            mapType: MapType.normal, //map type
            onMapCreated: (GoogleMapController controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
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
                      onTap: _getCurrentLocation,
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

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        36 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 36 * devicePixelRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    int nWidth = width.toInt();
    int nHeight = height.toInt();
    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(nWidth, nHeight);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
