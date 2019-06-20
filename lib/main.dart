import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(40.390392, -3.686711), zoom: 15.0);
  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  //Map<MarkerId, Marker> markers = <MarkerId, Marker> {};
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = LatLng(40.390392, -3.686711);

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    //_controller.complete(controller);
    mapController = controller;
    //_markers.add(value)
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Titulo del marcador',
          snippet: _lastMapPosition.toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap:() {
          print("MAPA" + _lastMapPosition.toString());
        }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps in Flutter'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Text('esta parte'),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text('hola mundo'),
            ),

          ],
        ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _onAddMarkerButtonPressed();
//        mapController.animateCamera(
//          CameraUpdate.newCameraPosition(
//            CameraPosition(
//                target: LatLng(37.4219999, -122.0862462), zoom: 20.0),
//          ),
//        );
      }),

    );
  }
}
