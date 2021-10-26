import 'package:geolocator/geolocator.dart';

class UserLocation {
  static Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> getPosition() async {
    return await _determinePosition();
  }
}

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';

// typedef ShowDialogFunction = void Function(String title, String message);

// class MapMarkerExample {
//   BuildContext _context;
//   HereMapController _hereMapController;
//   List<MapMarker> _mapMarkerList = [];
//   List<MapMarker3D> _mapMarker3DList = [];
//   MapImage _poiMapImage;
//   MapImage _photoMapImage;
//   MapImage _circleMapImage;
//   ShowDialogFunction _showDialog;

//   MapMarkerExample(ShowDialogFunction showDialogCallback,
//       HereMapController hereMapController, GeoCoordinates geoCoordinates) {
//     _showDialog = showDialogCallback;
//     _hereMapController = hereMapController;

//     double distanceToEarthInMeters = 4000000;
//     _hereMapController.camera
//         .lookAtPointWithDistance(geoCoordinates, distanceToEarthInMeters);

//     _setTapGestureHandler();
//     _addPOIMapMarker(geoCoordinates);
//   }

//   // void showAnchoredMapMarkers() {
//   //   _unTiltMap();
//   //
//   //   GeoCoordinates geoCoordinates =
//   //       _createRandomGeoCoordinatesAroundMapCenter();
//   //
//   //   // Centered on location. Shown below the POI image to indicate the location.
//   //   // The draw order is determined from what is first added to the map,
//   //   // but since loading images is done async, we can make this explicit by setting
//   //   // a draw order. High numbers are drawn on top of lower numbers.
//   //   _addCircleMapMarker(geoCoordinates, 0);
//   //
//   //   // Anchored, pointing to location.
//   //   _addPOIMapMarker(geoCoordinates, 1);
//   // }

//   // void showCenteredMapMarkers() {
//   //   _unTiltMap();
//   //
//   //   GeoCoordinates geoCoordinates =
//   //       _createRandomGeoCoordinatesAroundMapCenter();
//   //
//   //   // Centered on location.
//   //   _addPhotoMapMarker(GeoCoordinates(19.0760, 72.8777), 0);
//   //
//   //   // Centered on location. Shown above the photo marker to indicate the location.
//   //   _addCircleMapMarker(GeoCoordinates(19.0760, 72.8777), 1);
//   // }

//   // void showFlatMapMarkers() {
//   //   // Tilt the map for a better 3D effect.
//   //   _tiltMap();
//   //
//   //   GeoCoordinates geoCoordinates =
//   //       _createRandomGeoCoordinatesAroundMapCenter();
//   //
//   //   // Adds a flat POI marker that rotates and tilts together with the map.
//   //   _addFlatMarker3D(GeoCoordinates(19.0760, 72.8777));
//   //
//   //   // A centered 2D map marker to indicate the exact location.
//   //   // Note that 3D map markers are always drawn on top of 2D map markers.
//   //   _addCircleMapMarker(GeoCoordinates(19.0760, 72.8777), 1);
//   // }

//   // void showMapMarkers3D() {
//   //   // Tilt the map for a better 3D effect.
//   //   _tiltMap();
//   //
//   //   GeoCoordinates geoCoordinates =
//   //       _createRandomGeoCoordinatesAroundMapCenter();
//   //
//   //   // Adds a textured 3D model.
//   //   // It's origin is centered on the location.
//   //   _addMapMarker3D(GeoCoordinates(19.0760, 72.8777));
//   // }

//   Future setMarker(GeoCoordinates geoCoordinates) async {
//     await _addPOIMapMarker(geoCoordinates);
//   }

//   void clearMap() {
//     for (var mapMarker in _mapMarkerList) {
//       _hereMapController.mapScene.removeMapMarker(mapMarker);
//     }
//     _mapMarkerList.clear();

//     for (var mapMarker3D in _mapMarker3DList) {
//       _hereMapController.mapScene.removeMapMarker3d(mapMarker3D);
//     }
//     _mapMarker3DList.clear();
//   }

//   // Future<void> _addPOIMapMarker(
//   //     GeoCoordinates geoCoordinates, int drawOrder) async {
//   Future<void> _addPOIMapMarker(GeoCoordinates geoCoordinates) async {
//     // Reuse existing MapImage for new map markers.
//     if (_poiMapImage == null) {
//       Uint8List imagePixelData = await _loadFileAsUint8List('assets/poi.png');
//       _poiMapImage =
//           MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
//     }

//     Anchor2D anchor2D = Anchor2D.withHorizontalAndVertical(0.5, 1);

//     MapMarker mapMarker = MapMarker.withAnchor(
//       geoCoordinates,
//       _poiMapImage,
//       anchor2D,
//     );
//     //mapMarker.drawOrder = drawOrder;

//     Metadata metadata = new Metadata();
//     metadata.setString("key_poi", geoCoordinates.toString());
//     mapMarker.metadata = metadata;

//     _hereMapController.mapScene.addMapMarker(mapMarker);
//     _mapMarkerList.add(mapMarker);
//   }

//   // Future<void> _addPhotoMapMarker(
//   //     GeoCoordinates geoCoordinates, int drawOrder) async {
//   //   // Reuse existing MapImage for new map markers.
//   //   if (_photoMapImage == null) {
//   //     Uint8List imagePixelData =
//   //         await _loadFileAsUint8List('assets/here_car.png');
//   //     _photoMapImage =
//   //         MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
//   //   }
//   //
//   //   MapMarker mapMarker =
//   //       MapMarker(GeoCoordinates(19.0760, 72.8777), _photoMapImage);
//   //   mapMarker.drawOrder = drawOrder;
//   //
//   //   _hereMapController.mapScene.addMapMarker(mapMarker);
//   //   _mapMarkerList.add(mapMarker);
//   // }

//   // Future<void> _addCircleMapMarker(
//   //     GeoCoordinates geoCoordinates, int drawOrder) async {
//   //   // Reuse existing MapImage for new map markers.
//   //   if (_circleMapImage == null) {
//   //     Uint8List imagePixelData =
//   //         await _loadFileAsUint8List('assets/circle.png');
//   //     _circleMapImage =
//   //         MapImage.withPixelDataAndImageFormat(imagePixelData, ImageFormat.png);
//   //   }
//   //
//   //   MapMarker mapMarker = MapMarker(geoCoordinates, _circleMapImage);
//   //   mapMarker.drawOrder = drawOrder;
//   //
//   //   _hereMapController.mapScene.addMapMarker(mapMarker);
//   //   _mapMarkerList.add(mapMarker);
//   // }

//   // void _addFlatMarker3D(GeoCoordinates geoCoordinates) {
//   //   // Place the files in the "assets" directory as specified in pubspec.yaml.
//   //   // Adjust file name and path as appropriate for your project.
//   //   // Note: The bottom of the plane is centered on the origin.
//   //   String geometryFilePath = "assets/models/plane.obj";
//   //
//   //   // The POI texture is a square, so we can easily wrap it onto the 2 x 2 plane model.
//   //   String textureFilePath = "assets/models/poi_texture.png";
//   //
//   //   // Optionally, consider to store the model for reuse (like we showed for MapImages above).
//   //   MapMarker3DModel mapMarker3DModel =
//   //       MapMarker3DModel.withTextureFilePath(geometryFilePath, textureFilePath);
//   //   MapMarker3D mapMarker3D = MapMarker3D(geoCoordinates, mapMarker3DModel);
//   //   // Scale marker. Note that we used a normalized length of 2 units in 3D space.
//   //   mapMarker3D.scale = 50;
//   //
//   //   _hereMapController.mapScene.addMapMarker3d(mapMarker3D);
//   //   _mapMarker3DList.add(mapMarker3D);
//   // }

//   // void _addMapMarker3D(GeoCoordinates geoCoordinates) {
//   //   // Place the files in the "assets" directory as specified in pubspec.yaml.
//   //   // Adjust file name and path as appropriate for your project.
//   //   String geometryFilePath = "assets/models/obstacle.obj";
//   //   String textureFilePath = "assets/models/obstacle_texture.png";
//   //
//   //   // Optionally, consider to store the model for reuse (like we showed for MapImages above).
//   //   MapMarker3DModel mapMarker3DModel =
//   //       MapMarker3DModel.withTextureFilePath(geometryFilePath, textureFilePath);
//   //   MapMarker3D mapMarker3D = MapMarker3D(geoCoordinates, mapMarker3DModel);
//   //   mapMarker3D.scale = 6;
//   //
//   //   _hereMapController.mapScene.addMapMarker3d(mapMarker3D);
//   //   _mapMarker3DList.add(mapMarker3D);
//   // }

//   Future<Uint8List> _loadFileAsUint8List(String assetPathToFile) async {
//     // The path refers to the assets directory as specified in pubspec.yaml.
//     ByteData fileData = await rootBundle.load(assetPathToFile);
//     return Uint8List.view(fileData.buffer);
//   }

//   void _setTapGestureHandler() {
//     _hereMapController.gestures.tapListener =
//         TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
//       _pickMapMarker(touchPoint);
//     });
//   }

//   void _pickMapMarker(Point2D touchPoint) {
//     double radiusInPixel = 2;
//     _hereMapController.pickMapItems(touchPoint, radiusInPixel,
//         (pickMapItemsResult) {
//       // Note that 3D map markers can't be picked yet. Only marker, polgon and polyline map items are pickable.
//       List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
//       if (mapMarkerList.length == 0) {
//         print("No map markers found.");
//         return;
//       }

//       MapMarker topmostMapMarker = mapMarkerList.first;
//       Metadata metadata = topmostMapMarker.metadata;
//       if (metadata != null) {
//         String message = metadata.getString("key_poi") ?? "No message found.";
//         _showDialog("Map MetaDate", message);
//         return;
//       }

//       _showDialog("Map Marker picked", "No metadata attached.");
//     });
//   }

//   // void _tiltMap() {
//   //   MapCameraOrientationUpdate targetOrientation =
//   //       MapCameraOrientationUpdate.withDefaults();
//   //   targetOrientation.tilt = 60;
//   //   _hereMapController.camera.setTargetOrientation(targetOrientation);
//   // }
//   //
//   // void _unTiltMap() {
//   //   MapCameraOrientationUpdate targetOrientation =
//   //       MapCameraOrientationUpdate.withDefaults();
//   //   targetOrientation.tilt = 0;
//   //   _hereMapController.camera.setTargetOrientation(targetOrientation);
//   // }

//   // GeoCoordinates _createRandomGeoCoordinatesAroundMapCenter() {
//   //   GeoCoordinates centerGeoCoordinates =
//   //       _hereMapController.viewToGeoCoordinates(Point2D(
//   //           _hereMapController.viewportSize.width / 2,
//   //           _hereMapController.viewportSize.height / 2));
//   //   if (centerGeoCoordinates == null) {
//   //     // Should never happen for center coordinates.
//   //     throw Exception("CenterGeoCoordinates are null");
//   //   }
//   //   double lat = centerGeoCoordinates.latitude;
//   //   double lon = centerGeoCoordinates.longitude;
//   //   return GeoCoordinates(
//   //       _getRandom(lat - 0.02, lat + 0.02), _getRandom(lon - 0.02, lon + 0.02));
//   // }

//   // double _getRandom(double min, double max) {
//   //   return min + Random().nextDouble() * (max - min);
//   // }
// }
