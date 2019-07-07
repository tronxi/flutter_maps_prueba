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

  final Set<Polyline>_polyline={};
  List<LatLng> listaLangLong = List();
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
      _delteFromPolylineList(idString);
    });
  }

  void _delteFromPolylineList(String idString) {
    MarkerId id = MarkerId(idString);
    String lat = id.value.split(',')[0].replaceAll('LatLng(', '');
    String long = id.value.split(',')[1].replaceAll(')', '');

    setState(() {
      print("lat " + lat);
      print("long " + long);
      listaLangLong.remove(LatLng(double.parse(lat), double.parse(long)));
    });
  }
  void _onLongPress(LatLng latlong) {
    print('LONGTAP' + latlong.toString());
    listaLangLong.add(latlong);
    _addPolyline(latlong);
    _addMarker(latlong);
  }

  void _addPolyline(LatLng latlong) {
    setState(() {
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        points: listaLangLong,
        //points: Set<Marker>.of(_markers.values).toList(true),
        color: Colors.blue,
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
              polylines: _polyline,
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
