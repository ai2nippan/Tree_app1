import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class ViewPlantOfficial extends StatefulWidget {
  final PlantModel plantModel;
  const ViewPlantOfficial({Key? key, required this.plantModel})
      : super(key: key);

  @override
  _ViewPlantOfficialState createState() => _ViewPlantOfficialState();
}

class _ViewPlantOfficialState extends State<ViewPlantOfficial> {
  PlantModel? plantModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    plantModel = widget.plantModel;
    //displayPlant();
  }

  //Future<Null> displayPlant()async{}

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('View Plant'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImage(size),
                buildTitle(size),
              ],
            ),
            buildMap()
          ],
        ),
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
            markerId: MarkerId('Id'),
            position: LatLng(
                double.parse(plantModel!.lat), double.parse(plantModel!.lng)),
            infoWindow: InfoWindow(
                title: 'คุณอยู่ที่นี่',
                snippet: 'Lat = ${plantModel!.lat}, Lng = ${plantModel!.lng}')),
      ].toSet();

  Widget buildMap() {
    return Container(
      width: double.infinity,
      height: 300,
      child: plantModel!.lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(plantModel!.lat),
                    double.parse(plantModel!.lng)),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [Text('Map')],
      // ),
    );
  }

  Container buildTitle(double size) {
    return Container(
      width: size * 0.5,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShowTitle(
            title: 'ชื่อต้นไม้ : ${plantModel!.name}',
            textStyle: MyConstant().h2Style(),
          ),
          ShowTitle(
            title: 'สถานที่ : ${plantModel!.place}',
            textStyle: MyConstant().h2Style(),
          )
        ],
      ),
    );
  }

  Container buildImage(double size) {
    return Container(
      padding: EdgeInsets.all(4),
      width: size * 0.5,
      child: CachedNetworkImage(
          imageUrl: '${MyConstant.domain}${plantModel!.avatar}'),
    );
  }
}
