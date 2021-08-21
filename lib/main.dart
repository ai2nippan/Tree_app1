import 'package:flutter/material.dart';
import 'package:tree_app1/states/add_plant.dart';
import 'package:tree_app1/states/authen.dart';
import 'package:tree_app1/states/create_account.dart';
import 'package:tree_app1/states/delete_plant.dart';
import 'package:tree_app1/states/forest_planter.dart';
import 'package:tree_app1/states/official_admin.dart';
import 'package:tree_app1/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount':(BuildContext context) => CreateAccount(),
  '/officialAdmin':(BuildContext context) => OfficialAdmin(),
  '/forestPlanter':(BuildContext context) => ForestPlanter(),
  '/addPlant':(BuildContext context) => AddPlant(),
  // '/delPlant':(BuildContext context) => DeletePlant(),
};

// String initRoute;

String initRoute = '/authen';


void main() {
  runApp(MyApp());
}

// main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      title: MyConstant.appName,
      routes: map,
      initialRoute: initRoute,
    );
  }
}
