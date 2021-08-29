import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tree_app1/models/plant_model.dart';
import 'package:tree_app1/models/user_model.dart';
import 'package:tree_app1/states/list_plant_planter.dart';
import 'package:tree_app1/states/official_map_all.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/widgets/show_progress.dart';
import 'package:tree_app1/widgets/show_title.dart';

class OfficialAdmin extends StatefulWidget {
  const OfficialAdmin({Key? key}) : super(key: key);

  @override
  _OfficialAdminState createState() => _OfficialAdminState();
}

class _OfficialAdminState extends State<OfficialAdmin> {
  List<UserModel> userModels = [];
  List<String> uModel = [];
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataFromAPI();
  }

  Future<Null> loadDataFromAPI() async {
    String apiLoadAllUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getUserWhereUserType.php?isAdd=true';

    await Dio().get(apiLoadAllUser).then((value) {
      if (value.toString().trim() == 'null') {
        // No data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have data
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);

          setState(() {
            load = false;
            haveData = true;
            // if (model.sex == 'M') {
            //   String sex = 'ชาย';
            // } else {
            // }
            userModels.add(model);

            // String id = model.id;
            // String name = model.name;
            // String usertype = model.usertype;
            // String occupation = model.occupation;
            // String sex = model.sex;
            // String age = model.age;
            // String email = model.email;
            // String phone = model.phone;
            // String user = model.user;
            // String password = model.password;

            // uModel.;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Official Admin'),
        ),
        body: load
            ? ShowProgress()
            : haveData!
                ? LayoutBuilder(
                    builder: (context, constraints) =>
                        buildListView(constraints),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                            title: 'No User',
                            textStyle: MyConstant().h1Style()),
                        ShowTitle(
                            title: 'Please Add User',
                            textStyle: MyConstant().h2Style()),
                      ],
                    ),
                  ) // No data ,
        );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: userModels.length,
      itemBuilder: (context, index) => Card(
        child: GestureDetector(
          onTap: () {
            print('### You Click $index, id = ${userModels[index].id}');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListPlantPlanter(
                userModel: userModels[index],
              ),
            ));
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5 - 4,
                child: Column(
                  children: [
                    ShowTitle(
                        title: userModels[index].name,
                        textStyle: MyConstant().h2Style()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              print('You press map');
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OfficialMapAll(
                                  userModel: userModels[index],
                                ),
                              ));
                            },
                            icon: Icon(
                              Icons.local_florist,
                              size: 36,
                              color: MyConstant.dark,
                            )),
                        // IconButton(
                        //     onPressed: () {
                        //       print('You press List');
                        //     },
                        //     icon: Icon(Icons.list_alt)),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5 - 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                        title: 'อาชีพ : ${userModels[index].occupation}',
                        textStyle: MyConstant().h3Style()),
                    ShowTitle(
                        title: "เพศ : ${userModels[index].sex}",
                        textStyle: MyConstant().h3Style()),
                    ShowTitle(
                        title: 'Email : ${userModels[index].email}',
                        textStyle: MyConstant().h3Style()),
                    ShowTitle(
                        title: 'Mobile : ${userModels[index].phone}',
                        textStyle: MyConstant().h3Style()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
