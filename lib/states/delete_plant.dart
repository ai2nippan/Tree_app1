import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/utility/my_dialog.dart';
import 'package:tree_app1/widgets/show_image.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class DeletePlant extends StatefulWidget {
  //final List<String> images;
  final String images;
  const DeletePlant({Key? key, required this.images}) : super(key: key);
  // final PlantModel plantModel;
  // const DeletePlant({Key? key, required this.plantModel}) : super(key: key);

  @override
  _DeletePlantState createState() => _DeletePlantState();
}

class _DeletePlantState extends State<DeletePlant> {
  // String? selectedImages;
  File? file;
  // List<File?> files = [];
  double? lat, lng;
  // List<PlantModel> plantModels = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController plantController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  // List<ImageSource> imgSrc = [];

  List<String> pathImages = [];
  int index = 0;

  String? avatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    avatar = widget.images;
    loadDataFromAPI();
  }

  Future<Null> loadDataFromAPI() async {
    // print('avatar111 => $avatar');
    // double size = MediaQuery.of(context).size.width;

    if (pathImages.length != 0) {
      pathImages.clear();
    }

    String apiCheckAvatar =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getPlantWhereAvatar.php?isAdd=true&avatar=$avatar';

    await Dio().get(apiCheckAvatar).then((value) {
      print('value for API ==> $value');
      // PlantModel model = PlantModel.fromMap(json.decode(value.data));
      for (var item in json.decode(value.data)) {
        PlantModel model = PlantModel.fromMap(item);
        // plantModels.add(model);

        print('name = ${model.name}');

        String npath = MyConstant.domain + model.avatar;

        setState(() {
          plantController.text = model.name;
          placeController.text = model.place;
          lat = double.parse(model.lat);
          lng = double.parse(model.lng);
          // String filex = '${MyConstant.domain}${avatar}';
          // Image.file(filex);
          // buildAvatar(size);
          buildMap();
          // LatLng latLng = LatLng(lat!, lng!);
          // CameraPosition cameraPosition = CameraPosition(
          //   target: latLng,
          //   zoom: 16.0,
          // );

          // String npath = MyConstant.domain + model.avatar;
          //file = File(MyConstant.domain+model.avatar);
          //file = File(npath);

          //Image.file(file!);
          // imgSrc.add(model.);
          pathImages.add(model.avatar.trim());
          print('pathImage : ${pathImages[index]}');
        });
        //print('Img = ${MyConstant.domain}${model.avatar}');
        print('Img = $npath');
        print('lat = $lat, lng = $lng');
        //index++;
      }
    });

    //print('plant name = $plantController, place = $placeController');
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(context, 'Location Service ปิดอยู่ ?',
          'กรุณาเปิด Location Service ด้วยคะ');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> Work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Delete Plant'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTitle('ข้อมูลต้นไม้'),
                    buildPlantName(constraints),
                    buildPlace(constraints),
                    buildTitle('ภาพต้นไม้'),
                    // buildImage(constraints),
                    buildAvatar(size),
                    buildTitle('แผนที่ตำแหน่งที่ปลูก'),
                    buildMap(), deleteButton(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> confirmDialogDelete() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: '${MyConstant.domain}${pathImages[0]}',
            placeholder: (context, url) => ShowProgress(),
          ),
          title: ShowTitle(
            title: 'Delete ${plantController.text}? ',
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitle(
            title: 'สถานที่ : ${placeController.text}',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('Perform delete');
              String apiDeletePlantWhereAvatar =
                '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/deletePlantWhereAvatar.php?isAdd=true&avatar=$avatar';

              await Dio().get(apiDeletePlantWhereAvatar).then((value) {
                Navigator.pop(context); // pop from dialog
                Navigator.pop(context); // pop from this screen 
                loadDataFromAPI();
             });

            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }

  Widget deleteButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
          style: MyConstant().myButtonStyleRed(),
          onPressed: () {
            //print('Delete');
            confirmDialogDelete();
          },
          icon: Icon(
            Icons.delete,
          ),
          label: Text('Delete')),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // IconButton(
        //   onPressed: () => chooseImage(ImageSource.camera),
        //   icon: Icon(
        //     Icons.add_a_photo,
        //     size: 36,
        //     color: MyConstant.dark,
        //   ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 70),
          width: size * 0.6,
          child: (pathImages.isEmpty || pathImages == null)
              //file != null
              ? ShowProgress() //ShowImage(path: MyConstant.image9)
              : CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}${pathImages[0]}'), //Image.file(file!),

          // ? CachedNetworkImage(imageUrl: '${MyConstant.domain}${pathImages[0]}')//Image.file(file!),
          // : ShowImage(path: MyConstant.image9)
        ),
        // IconButton(
        //   onPressed: () => chooseImage(ImageSource.gallery),
        //   icon: Icon(
        //     Icons.add_photo_alternate,
        //     size: 36,
        //     color: MyConstant.dark,
        //   ),
        // ),
      ],
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่', snippet: 'Lat = $lat, lng = $lng'),
        ),
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 300,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ), //Text('Lat = $lat, Lng = $lng'),
      );

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          child: Image.asset(MyConstant.image9),
        ),
      ],
    );
  }

  Widget buildPlantName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      //width: size * 0.6,
      child: TextFormField(
        controller: plantController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก Plant Name ด้วยคะ';
          } else {}
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'Plant Name : ',
          prefixIcon: Icon(
            Icons.yard,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildPlace(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      //width: size * 0.6,
      child: TextFormField(
        controller: placeController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก Place ด้วยคะ';
          } else {}
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'Place : ',
          prefixIcon: Icon(
            Icons.fmd_good,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }
}
