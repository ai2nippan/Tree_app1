import 'package:flutter/material.dart';

class OfficialAdmin extends StatefulWidget {
  const OfficialAdmin({ Key? key }) : super(key: key);

  @override
  _OfficialAdminState createState() => _OfficialAdminState();
}

class _OfficialAdminState extends State<OfficialAdmin> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  
  Future<Null> loadDataFromAPI() async{

    String api

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Official Admin'),),
    );
  }
}