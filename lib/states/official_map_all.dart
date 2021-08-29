import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/models/user_model.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class OfficialMapAll extends StatefulWidget {
  final UserModel userModel;
  const OfficialMapAll({Key? key, required this.userModel}) : super(key: key);

  @override
  _OfficialMapAllState createState() => _OfficialMapAllState();
}

class _OfficialMapAllState extends State<OfficialMapAll> {
  UserModel? userModel;

  List<PlantModel> plantModel = [];
  List<LatLng> markersPositions = [];
  List<String> urls = [];

  bool load = true;
  bool? havedat;

  double? lat, lng;
  String? namePlanter;

  static const colors = [
    Colors.purple,
    Colors.red,
    Colors.lightBlue,
    Colors.green,
    Colors.grey,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    loadPlantPlanter();
  }

  Future<Null> loadPlantPlanter() async {
    String idPlanter = userModel!.id;
    namePlanter = userModel!.name;

    String apiGetPlantWhereIdPlanter =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getPlantWhereidPlanter.php?isAdd=true&idPlanter=$idPlanter';

    await Dio().get(apiGetPlantWhereIdPlanter).then((value) {
      if (value.toString().trim() == 'null') {
        // No data
        setState(() {
          load = false;
          havedat = false;
        });
      } else {
        // Have data

        for (var item in json.decode(value.data)) {
          PlantModel model = PlantModel.fromMap(item);

          lat = double.parse(model.lat);
          lng = double.parse(model.lng);

          setState(() {
            load = false;
            havedat = true;

            plantModel.add(model);
            markersPositions
                .add(LatLng(double.parse(model.lat), double.parse(model.lng)));
            urls.add('${MyConstant.domain}${model.avatar}');
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แผนที่ต้นไม้ของ : $namePlanter'),
        ),
        body: load
            ? ShowProgress()
            : havedat!
                ? buildMapImage(context)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                            title: 'ไม่พบข้อมูล',
                            textStyle: MyConstant().h1Style()),
                      ],
                    ),
                  ) //lat == null ? ShowProgress() : buildMapImage(context),
        );
  }

  FutureBuilder<List<Uint8List>> buildMapImage(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(List.generate(
          markersPositions.length,
          (index) => CachedNetworkMarker(
                url: urls[index],
                dpr: MediaQuery.of(context).devicePixelRatio,
              ).circleAvatar(CircleAvatarParams(color: colors[index])))),
      builder: (context, AsyncSnapshot<List<Uint8List>> snapshot) {
        if (snapshot.hasData) {
          final bytes = snapshot.data;
          final markers = List.generate(
            bytes!.length,
            (index) => Marker(
              markerId: MarkerId(index.toString()),
              position: markersPositions[index],
              icon: BitmapDescriptor.fromBytes(bytes[index]),
            ),
          );

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat!, lng!),
              zoom: 14.4746,
            ),
            markers: {...markers},
          );
        }
        return GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(lat!, lng!)));
      },
    );
  }
}
