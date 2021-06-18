import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:rtk_mobile/services/map_object.dart';
import 'package:rtk_mobile/services/networking.dart';
import 'package:http/http.dart' as http;

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Timer timer;
  BuildContext _context;
  MapMarkerExample _mapMarkerExample;
  NetworkHelper networkHelper = NetworkHelper();

  @override
  void initState() {
    super.initState();
    SdkContext.init(IsolateOrigin.main);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            HereMap(onMapCreated: _onMapCreated),
            BackButton(
              color: Colors.grey.shade700,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) async {
      if (error == null) {
        GeoCoordinates coordinates = await getCoordinates();
        _mapMarkerExample =
            MapMarkerExample(_showDialog, hereMapController, coordinates);

        timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
          coordinates = await getCoordinates();

          await _mapMarkerExample.setMarker(coordinates);
        });
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  Future<GeoCoordinates> getCoordinates() async {
    http.Response response = await networkHelper.getLiveDate();
    String nmea = response.body;
    print(nmea);
    var y = nmea.split(",");
    print(y);
    double lat, lon, alt;
    if (nmea[0] == "\$") {
      var x = nmea.split(",");
      if (x[4] == "S") {
        lat = -1 * double.parse(x[3]);
      } else {
        lat = double.parse(x[3]);
      }
      if (x[6] == "W") {
        lon = -1 * double.parse(x[5]);
      } else {
        lon = double.parse(x[5]);
      }
      alt = double.parse(x[9]);
    }

    return GeoCoordinates(lat, lon);
  }

  // void _centeredMapMarkersButtonClicked() {
  //   _mapMarkerExample.showCenteredMapMarkers();
  // }
  //
  // void _anchoredMapMarkersButtonClicked() {
  //   _mapMarkerExample.showAnchoredMapMarkers();
  // }
  //
  // void _flatMapMarkersButtonClicked() {
  //   _mapMarkerExample.showFlatMapMarkers();
  // }
  //
  // void _mapMarkers3DButtonClicked() {
  //   _mapMarkerExample.showMapMarkers3D();
  // }
  //
  // void _clearButtonClicked() {
  //   _mapMarkerExample.clearMap();
  // }

  // // A helper method to add a button on top of the HERE map.
  // Align button(String buttonLabel, Function callbackFunction) {
  //   return Align(
  //     alignment: Alignment.topCenter,
  //     child: RaisedButton(
  //       color: Colors.lightBlueAccent,
  //       textColor: Colors.white,
  //       onPressed: () => callbackFunction(),
  //       child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
  //     ),
  //   );
  // }

  // A helper method to add a button on top of the HERE map.
  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Column(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         button('Anchored (2D)', _anchoredMapMarkersButtonClicked),
//         button('Centered (2D)', _centeredMapMarkersButtonClicked),
//       ],
//     ),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         button('Flat', _flatMapMarkersButtonClicked),
//         button('3D OBJ', _mapMarkers3DButtonClicked),
//         button('Clear', _clearButtonClicked),
//       ],
//     ),
//   ],
// ),
