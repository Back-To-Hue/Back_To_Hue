import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'pages/contact_list_page.dart';
import 'pages/contact_page.dart';
import 'pages/edit_contact_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Back to Hue',
      // Navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(),
        '/contactList': (context) => ContactListPage(),
        '/contact': (context) => ContactPage(),
        '/editContact': (context) => EditContactPage(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //created controller and isMapCreated variables
  late GoogleMapController _controller;
  bool isMapCreated = false;
  int count = 0;

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    //Updates code to account for style
    _controller = controller;
    isMapCreated = true;
    changeMapMode();
    setState(() {});
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }
  // final Map<String, Marker> _markers = {};
  // Future<void> _onMapCreated(GoogleMapController controller) async {
  //   final googleOffices = await locations.getGoogleOffices();
  //   setState(() {
  //     _markers.clear();
  //     for (final office in googleOffices.offices) {
  //       final marker = Marker(
  //         markerId: MarkerId(office.name),
  //         position: LatLng(office.lat, office.lng),
  //         infoWindow: InfoWindow(
  //           title: office.name,
  //           snippet: office.address,
  //         ),
  //       );
  //       _markers[office.name] = marker;
  //     }
  //   });
  // }

  //Neccessary helper functions to read Json and change map style
  @override
  void initState() {
    super.initState();
  }

  changeMapMode() {
    getJsonFile("assets/Clear.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Back To Hue: pressed button $count times'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.white,
                        Colors.blue
                      ])
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Contacts'),
                onPressed: () {
                  Navigator.pushNamed(context, '/contactList');
                },
              ),
            ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            count++;
          }),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        body: GoogleMap(
          //edited here for new style
          onMapCreated: _onMapCreated,
          zoomControlsEnabled: false,
          // onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          // markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
