import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_app1/models/user_model.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/utility/my_dialog.dart';
import 'package:tree_app1/widgets/show_image.dart';
import 'package:tree_app1/widgets/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildImage(size),
              buildAppName(),
              buildUser(size),
              buildPassword(size),
              buildLogin(size),
              buildCreateAccount(),
            ],
          ),
        ),
      )),
      // appBar: AppBar(
      //   title: Text('Authen'),
      // ),
      //body: SafeArea(child: child),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'ไม่มีบัญชีผู้ใช้ใช่ไหม ? ',
          textStyle: MyConstant().h3Style(),
        ),
        TextButton(
          onPressed: () {
            //print('press textbutton');
            Navigator.pushNamed(context, MyConstant.routeCreateAccount);
          },
          child: Text(
            'สร้างบัญชีผู้ใช้ใหม่',
            style: MyConstant().h4Style(),
          ),
        ),
      ],
    );
  }

  Row buildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String user = userController.text;
                String password = passwordController.text;
                print('## user = $user, password = $password');
                checkAuthen(password: password, user: user);
              }
            },
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    //print('### (checkAuthen)user ==> $user, password ==> $password');
    String apiCheckAuthen =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==> $value');
      if (value.toString().trim() == 'null') {
        MyDialog()
            .normalDialog(context, 'ผู้ใช้ไม่ถูกต้อง', 'ไม่พบข้อมูล $user');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(item);
          if (password == userModel.password) {
            String usertype = userModel.usertype;
            print('## Authen Success in userType = $usertype');

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('id', userModel.id);
            preferences.setString('usertype', usertype);
            preferences.setString('user', userModel.user);
            preferences.setString('name', userModel.name);

            switch (usertype) {
              case 'ADMIN':
                //Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeOfficialAdmin, (route) => false);
                Navigator.pushNamed(context, MyConstant.routeOfficialAdmin);
                break;

              case 'USER': 
                //Navigator.pushNamedAndRemoveUntil(context, MyConstant.routeForestPlanter, (route) => false);
                Navigator.pushNamed(context, MyConstant.routeForestPlanter);
                break;
              default:
            }

          } else {
            // Authen Fail
            MyDialog().normalDialog(context, 'รหัสผ่านผิดพลาด', 'กรุณาลองใหม่อีกครั้ง');
          }
        }
      }

      //return null;
    });
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            obscureText: statusRedEye,
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่รหัสผ่าน';
                //return 'Please Fill Password field';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      statusRedEye = !statusRedEye;
                    });
                  },
                  icon: statusRedEye
                      ? Icon(
                          Icons.remove_red_eye,
                          color: MyConstant.blackcolor1,
                        )
                      : Icon(
                          Icons.remove_red_eye,
                          color: MyConstant.redcolor1,
                        )),
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password : ',
              prefixIcon: Icon(
                Icons.lock_outline,
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
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่ชื่อผู้ใช้';
                //return 'Please Fill User field';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User : ',
              prefixIcon: Icon(
                Icons.account_circle_outlined,
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
        ),
      ],
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: MyConstant.appName,
          textStyle: MyConstant().h1Style(),
        ),
      ],
    );
  }

  Row buildImage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(16.0),
          width: size * 0.6,
          //child: ShowImage(path: MyConstant.image1,imgWidth: size,imgHeight: 250,),
          child: ShowImage(
            path: MyConstant.image1,
          ),
        ),
      ],
    );
  }
}
