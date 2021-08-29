import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/states/my_homepage.dart';
import 'package:tree_app1/states/delete_plant.dart';
import 'package:tree_app1/utility/my_constant.dart';

class ForestPlanter extends StatefulWidget {
  const ForestPlanter({Key? key}) : super(key: key);

  @override
  _ForestPlanterState createState() => _ForestPlanterState();
}

class _ForestPlanterState extends State<ForestPlanter> {
  List<Widget> widgetPlant = [];
  List<String> imgList = [];
  List<PlantModel> plantModels = [];
  // String urlImage = '';

  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {

    if (plantModels.length != null) {
      plantModels.clear();
      imgList.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    //String idPlanter = preferences.getString('id')!;
    String? idPlanter = preferences.getString('id');

    // print('idPlanter = $idPlanter');

    String apiGetPlantWhereIdPlanter =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getPlantWhereidPlanter.php?isAdd=true&idPlanter=$idPlanter';

    await Dio().get(apiGetPlantWhereIdPlanter).then((value) {
      // print('value ==> $value');
      for (var item in json.decode(value.data)) {
        PlantModel model = PlantModel.fromMap(item);
        print('## plant name = ${model.name}, avatar = ${model.avatar}');
        setState(() {
          String urlImage = '${MyConstant.domain}${model.avatar}';
          String imgname = model.name;
          print('### urlImage =  $urlImage, imgname = $imgname');
          // widgetPlant.add(makePlant(urlImage)); // For Test
          widgetPlant.add(makePlant(imgname, urlImage)); // For Test
          imgList.add(urlImage); // For Test
          plantModels.add(model);
        });
      }
    });
  }

  Widget makePlant(String title, String urlImage) {
    // Widget makePlant(String urlImage) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 500.0,
      child: Stack(
        children: [
          Image.network(
            urlImage,
            fit: BoxFit.fill,
          ),
          Container(
            alignment: Alignment.bottomCenter,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              '', //title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget bannerCarouse() {
  //   return CarouselSlider(
  //     items: widgetPlant,
  //     options: CarouselOptions(
  //       autoPlay: true,
  //       height: 400,
  //       enlargeCenterPage: true,
  //       aspectRatio: 16 / 9,
  //       pauseAutoPlayOnTouch: true,
  //     ),
  //   );
  // }

  Widget bannerCarouse() {
    return CarouselSlider(
      items: imgList
          .map((item) => Container(
                child: GestureDetector(
                  onTap: () {
                    print('image : $item');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DeletePlant(images: item,),//DeletePlant(plantModel: plantModels[item],),
                    )).then((value) {
                      //return loadValueFromAPI();
                      loadValueFromAPI();
                      bannerCarouse();
                    });
                  },
                  child: Center(
                    child: Image.network(
                      item,
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                  ),
                ),
              ))
          .toList(),
      options: CarouselOptions(
        autoPlay: true,
        height: 400,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        pauseAutoPlayOnTouch: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forest Planter'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: bannerCarouse(),
      ), //Text('Forest Planter'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, MyConstant.routeMyHomePage),//Navigator.pushNamed(context, MyConstant.routeAddPlant),
        child: Text('Add'),
      ),
    );
  }
}
