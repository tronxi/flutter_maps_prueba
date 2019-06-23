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
  GoogleMapController mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker> {};
  //final Set<Marker> _markers = {};
  LatLng _lastMapPosition = LatLng(40.390392, -3.686711);

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  void _showModalSheet(String texto) {
    showModalBottomSheet(context: context, builder: (builder) {
      return Container(
        child: Text(texto),
        padding: EdgeInsets.all(40.0),
      );
    });
  }
  void _showDialog(String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
          content: Text("Alert Dialog body"),
          actions: <Widget>[
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteMarker(texto);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _onAddMarkerButtonPressed() {
    _addMarker(_lastMapPosition);
  }
  void _addMarker(LatLng latlong) {
    setState(() {
      _markers[MarkerId(latlong.toString())] = (Marker(
          markerId: MarkerId(latlong.toString()),
          position: latlong,
          infoWindow: InfoWindow(
            title: 'Titulo del marcador',
            snippet: latlong.toString(),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onTap:() {
            //_showModalSheet(latlong.toString());
            _showDialog(latlong.toString());
            print("MAPA" + latlong.toString());
          }
      ));
    });
  }

  void _deleteMarker(String idString) {
    MarkerId id = MarkerId(idString);
    setState(() {
      _markers.remove(id);
    });
  }
  void _onLongPress(LatLng latlong) {
    print('LONGTAP' + latlong.toString());
    _addMarker(latlong);
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
              markers: Set<Marker>.of(_markers.values),
              onCameraMove: _onCameraMove,
              onLongPress: _onLongPress,
            )
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
