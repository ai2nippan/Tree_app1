import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/models/user_model.dart';
import 'package:tree_app1/states/view_plant_official.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/widgets/show_image.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class ListPlantPlanter extends StatefulWidget {
  final UserModel userModel;
  const ListPlantPlanter({Key? key, required this.userModel}) : super(key: key);

  @override
  _ListPlantPlanterState createState() => _ListPlantPlanterState();
}

class _ListPlantPlanterState extends State<ListPlantPlanter> {
  UserModel? userModel;
  List<PlantModel> plantModel = [];
  bool load = true;
  bool? havedat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    loadPlantPlanter();
  }

  Future<Null> loadPlantPlanter() async {
    String idPlanter = userModel!.id;

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

          setState(() {
            load = false;
            havedat = true;

            plantModel.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ต้นไม้ของ : ${userModel!.name}'),
      ),
      body: load
          ? ShowProgress()
          : havedat! // Not null(!)
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ไม่พบข้อมูล',
                          textStyle: MyConstant().h1Style())
                    ],
                  ),
                ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: plantModel.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          print('You press ${plantModel[index].id}, ${plantModel[index].name}');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewPlantOfficial(
              plantModel: plantModel[index],
            ),
          ));
        },
        child: Card(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5,
                height: constraints.maxWidth * 0.4,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${MyConstant.domain}${plantModel[index].avatar}',
                  placeholder: (context, url) =>
                      LinearProgressIndicator(), //ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.image9),
                ), //imgPath),
              ),
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5 - 8,
                height: constraints.maxWidth * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                      title: 'ชื่อต้นไม้ : ${plantModel[index].name}',
                      textStyle: MyConstant().h2Style(),
                    ),
                    ShowTitle(
                      title: 'สถานที่ : ${plantModel[index].place}',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //get imgPath => '${MyConstant.domain}${plantModel[0]}';
}
