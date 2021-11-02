import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtk_mobile/services/local_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rtk_mobile/services/networking.dart';
import 'package:http/http.dart' as http;
import 'package:rtk_mobile/services/nmea_parser.dart';
import 'package:rtk_mobile/components/constants.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final PopupController _popupController = PopupController();
  MapController controller = new MapController();
  NetworkHelper networkHelper = NetworkHelper();
  LatLng point;
  Timer timer;
  bool init = false;
  LatLng center;
  List<Marker> markers;
  double currentLat;
  double currentLon;

  List<LatLng> coordinates = [];

  @override
  void initState() {
    Position position = LocalStorageManager.position;
    setState(() {
      center = LatLng(position.latitude, position.longitude);
      coordinates.add(center);
      point = center;
      currentLat = point.latitude;
      currentLon = point.longitude;
      init = true;
      updateMarkers();
    });
    getCoordinates();
    super.initState();
  }

  @override
  void dispose() {
    timer = null;
    super.dispose();
  }

  updateMarkers() {
    setState(() {
      markers = coordinates
          .map(
            (point) => Marker(
              point: point,
              width: 60,
              height: 60,
              builder: (context) => Icon(
                Icons.location_on,
                color: Colors.red,
              ),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FlutterMap(
              mapController: controller,
              options: MapOptions(
                // swPanBoundary: LatLng(13, 77.5),
                // nePanBoundary: LatLng(13.07001, 77.58),
                center: center,
                bounds: LatLngBounds.fromPoints(coordinates),
                zoom: 18,
                minZoom: 12,
                maxZoom: 18,
                plugins: [
                  MarkerClusterPlugin(),
                ],
              ),
              layers: [
                TileLayerOptions(
                  minZoom: 12,
                  maxZoom: 18,
                  backgroundColor: Colors.black,
                  // errorImage: ,
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerClusterLayerOptions(
                  maxClusterRadius: 190,
                  disableClusteringAtZoom: 16,
                  size: Size(50, 50),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markers,
                  polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3,
                  ),
                  popupOptions: PopupOptions(
                    popupSnap: PopupSnap.markerTop,
                    popupController: _popupController,
                    popupBuilder: (_, marker) => Container(
                      color: Colors.white,
                      child: Container(
                        height: 40.0,
                        child: Column(
                          children: [
                            Text(
                              '${marker.point.latitude} / ${marker.point.longitude}',
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  builder: (context, markers) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${markers.length}'),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: kActiveCardColor,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Latitude"),
                          Text(currentLat.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Longitude"),
                          Text(currentLon.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BackButton(
              color: Colors.grey.shade700,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future getCoordinates() async {
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
      http.Response response = await networkHelper.getLiveDate();
      String sentence = response.body;
      List nmea = sentence.split("\r\n");
      for (var n in nmea) {
        var cor = await NmeaParser.parse(n);
        if (cor != null) {
          cor = jsonDecode(cor);
          try {
            setState(() async {
              point = LatLng(cor["lat"], cor["lon"]);
              currentLat = point.latitude;
              currentLon = point.longitude;
              if (!coordinates.contains(point)) {
                coordinates.add(point);
                print(n);
                print(cor);
              }
              if (coordinates.length > 20) coordinates.removeAt(0);
              updateMarkers();
            });
          } catch (e) {}
        }
      }
    });
  }
}
