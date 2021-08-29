import 'dart:io';
import 'dart:math';

import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_app1/main.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/utility/my_dialog.dart';
import 'package:tree_app1/widgets/show_image.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({Key? key}) : super(key: key);

  @override
  _AddPlantState createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  File? file;
  List<File?> files = [];
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController plantController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  String avatar = '';
  List<String> paths = [];

  // BitmapDescriptor? pinLocationIcon;

  // final generator = CachedNetworkMarker(url: '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/plant/plant52453.jpg', dpr: 200,);//MediaQuery.of(context).devicePixelRatio,);

  // final bitmap = generator.circleAvatar(CircleAvatarParams(color: Colors.lightBlue));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();

  }

  // Future<Null> setCustomMapPin() async{
  //   pinLocationIcon = await BitmapDescriptor.fromBytes(byteData)
  // }

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
          actions: [
            buildCreateNewPlant(),
          ],
          title: Text('Add Plant'),
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
                    buildMap(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  IconButton buildCreateNewPlant() {
    return IconButton(
      onPressed: () {
        // if (formKey.currentState!.validate()) {
        //   print('Process Insert to Database');
        // }
        uploadPictureAndInsertData();
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  // Future<Null> checkPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // String? user = preferences.getString('user');
  //   String? id = preferences.getString('id');
  //   print('(checkPref) User => $id');
  // }

  Future<Null> uploadPictureAndInsertData() async {

    String plantName = plantController.text;
    String place = placeController.text;
    print('## plant = $plantName, place = $place');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idPlanter = preferences.getString('id');
    String? namePlanter = preferences.getString('name');
    String? user = preferences.getString('user');

    String apiChkUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getUserWhereUser.php?isAdd=true&user=$user';

    if (formKey.currentState!.validate()) {
      if (file == null) {
        // No Picture
        insertMySQL(
            idPlanter: idPlanter,
            namePlanter: namePlanter,
            plantName: plantName,
            place: place);
      } else {
        // Have Picture
        String apiSavePlant =
            '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/savePlant.php';

        int i = Random().nextInt(100000);
        String namePlant = 'plant$i.jpg';

        // paths.add('/plant/$namePlant');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: namePlant);
        FormData data = FormData.fromMap(map);
        await Dio().post(apiSavePlant, data: data).then((value) {
          //return null;
          print('Upload Success');

          avatar = '/Mobile/Flutter2/Train/TreeTest1/php/plant/$namePlant';

          insertMySQL(
              idPlanter: idPlanter,
              namePlanter: namePlanter,
              plantName: plantName,
              place: place);
        });
      }
    }

    // await Dio().get(apiChkUser).then((value) async {
    //   print('## value<1> ==>> $value');
    //   if (value.toString().trim() == 'null') {
    //     print('## user OK');

    //     if (file == null) {
    //       // No Avatar (No Picture)
    //       print('No Avatar');
    //       insertMySQL(
    //           idPlanter: idPlanter,
    //           namePlanter: namePlanter,
    //           plantName: plantName,
    //           place: place);
    //     } else {
    //       // Have Avatar (Have Picture)
    //       print('### process Upload Avatar');
    //       String apiSaveAvatar =
    //           '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/saveAvatar.php';
    //       int i = Random().nextInt(100000);
    //       String nameAvatar = 'avatar$i.jpg';
    //       Map<String, dynamic> map = Map();
    //       map['file'] =
    //           await MultipartFile.fromFile(file!.path, filename: nameAvatar);
    //       FormData data = FormData.fromMap(map);
    //       await Dio().post(apiSaveAvatar, data: data).then((value) {
    //         //return null;
    //         avatar = '/Mobile/Flutter2/Train/TreeTest1/php/avatar/$nameAvatar';

    //         insertMySQL(
    //             idPlanter: idPlanter,
    //             namePlanter: namePlanter,
    //             plantName: plantName,
    //             place: place);
    //       });
    //     }
    //   } else {}
    // });

    // String apiInsertData =
    //     '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/InsertPlant.php?isAdd=true&idPlanter=$idPlanter&namePlanter=$namePlanter&name=$plantname&place=$place&lat=$lat&lng=$lng&avatar=$avatar';
  }

  Future<Null> insertMySQL(
      {String? idPlanter,
      String? namePlanter,
      String? plantName,
      String? place}) async {
    print('### InsertMySQL Work and avatar ==> $avatar');
    String apiInsertPlant =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/InsertPlant.php?isAdd=true&idPlanter=$idPlanter&namePlanter=$namePlanter&name=$plantName&place=$place&lat=$lat&lng=$lng&avatar=$avatar';
    await Dio().get(apiInsertPlant).then((value) {
      if (value.toString().trim() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถสร้างรายการปลูกต้นไม้ได้', 'กรุณาลองใหม่อีกรอบ');
      }
    });
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
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.image9)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          // icon: ,
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
        //controller: userController,
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'กรุณาใส่ชื่อผู้ใช้';
        //     //return 'Please Fill User field';
        //   } else {
        //     return null;
        //   }
        // },
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

        //controller: userController,
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'กรุณาใส่ชื่อผู้ใช้';
        //     //return 'Please Fill User field';
        //   } else {
        //     return null;
        //   }
        // },
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
