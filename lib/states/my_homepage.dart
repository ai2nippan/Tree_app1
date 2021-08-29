import 'dart:typed_data';

import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tree_app1/utility/my_constant.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const markerPositions = [
    LatLng(37.42596133580664, -122.083749655962),
    LatLng(37.42996133580664, -122.087749655962),
    LatLng(37.42396133580664, -122.08949655962)
  ];

  static const colors = [
    Colors.purple,
    Colors.red,
    Colors.lightBlue,
  ];

  static const urls = [
    'http://192.168.1.107/Mobile/Flutter2/Train/TreeTest1/php/plant/plant52453.jpg',
    'http://192.168.1.107/Mobile/Flutter2/Train/TreeTest1/php/plant/plant17934.jpg',
    'http://192.168.1.107/Mobile/Flutter2/Train/TreeTest1/php/plant/plant11150.jpg'
  ];

  Future<Null> checkPress()async{
    print('You press images naja');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait(
          List.generate(
            markerPositions.length,
            (index) => CachedNetworkMarker(
              url: urls[index],
              dpr: MediaQuery.of(context).devicePixelRatio,
            ).circleAvatar(CircleAvatarParams(color: colors[index])),
          ),
        ),
        builder: (context, AsyncSnapshot<List<Uint8List>> snapshot) {
          if (snapshot.hasData) {
            final bytes = snapshot.data;
            final markers = List.generate(
              bytes!.length,
              (index) => Marker(
                markerId: MarkerId(index.toString()),
                position: markerPositions[index],
                icon: BitmapDescriptor.fromBytes(bytes[index]),
              ),
            );
      
            return GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: {...markers},onTap: (argument) {
                checkPress();
              },
            );
          }
      
          return GoogleMap(initialCameraPosition: _kGooglePlex);
        },
      ),
    );
  }
}