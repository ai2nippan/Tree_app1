import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tree_app1/utility/my_constant.dart';
import 'package:tree_app1/utility/my_dialog.dart';
import 'package:tree_app1/widgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeOccupation;
  String? typeSex;
  String? typeAge;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildCreateNewAccount(),
        ],
        title: Text('Create New Account'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTitle('ข้อมูลทั่วไป'),
                buildName(size),
                buildTitle('อาชีพ'),
                buildRadioStudent(size),
                buildRadioEmployee(size),
                buildRadioGovernment(size),
                buildRadioOwner(size),
                buildTitle('เพศ'),
                buildRadioMale(size),
                buildRadioFemale(size),
                buildTitle('ช่วงอายุ'),
                buildRadioLT18(size),
                buildRadioGT18_25(size),
                buildRadioGT25_60(size),
                buildRadioGT60(size),
                buildEmail(size),
                buildPhone(size),
                buildUser(size),
                buildPassword(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildCreateNewAccount() => IconButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (typeOccupation == null || typeSex == null || typeAge == null) {
              if (typeOccupation == null) {
                MyDialog().normalDialog(
                    context, 'ยังไม่ได้เลือกอาชีพ คะ', 'กรุณาเลือกอาชีพ คะ');
              }

              if (typeSex == null) {
                MyDialog().normalDialog(
                    context, 'ยังไม่ได้เลือกเพศ คะ', 'กรุณาเลือกเพศ คะ');
              }

              if (typeAge == null) {
                MyDialog().normalDialog(context, 'ยังไม่ได้เลือกช่วงอายุ คะ',
                    'กรุณาเลือกช่วงอายุ คะ');
              }
            } else {
              print('Insert data Process...');
              checkUser();
            }
          }
        },
        icon: Icon(Icons.cloud_upload),
      );

  Future<Null> checkUser() async {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;

    print(
        '## name = $name, email = $email, phone = $phone, user =$user, password = $password');

    String apiCheckUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiCheckUser).then((value) {
      print('## value ==> $value');
      if (value.toString().trim() == 'null') {
        // No this user. Can Add User.
        print('## User OK');

        InsertData(
            name: name,
            email: email,
            phone: phone,
            user: user,
            password: password);
      } else {
        MyDialog().normalDialog(context, 'ผู้ใช้ผิดพลาด',
            'มีชื่อผู้ใช้ $value แล้ว ไม่สามารถใช้ชื่อนี้ได้ คะ');
      }

      //return null;
    });
  }

  Future<Null> InsertData(
      {String? name,
      String? email,
      String? phone,
      String? user,
      String? password}) async {
    print('### InsertData ###');
    print(
        '### (INS) name = $name, email = $email, phone = $phone, user = $user, password = $password');

    String apiInsertUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/TreeTest1/php/InsertUser.php?isAdd=true&name=$name&occupation=$typeOccupation&sex=$typeSex&age=$typeAge&email=$email&phone=$phone&user=$user&password=$password';

    await Dio().get(apiInsertUser).then((value) {
      if (value.toString().trim() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(context, 'สร้างผู้ใช้ผิดพลาด',
            'ไม่สามารถสร้างผู้ใช้นี้ได้ กรุณาลองใหม่อีกครั้ง');
      }
      //return null;
    });
  }

  Row buildRadioStudent(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Student',
            groupValue: typeOccupation,
            onChanged: (value) {
              setState(() {
                typeOccupation = value as String;
              });
            },
            title: ShowTitle(
              title: 'นักเรียน / นักศึกษา',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioEmployee(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Employee',
            groupValue: typeOccupation,
            onChanged: (value) {
              setState(() {
                typeOccupation = value as String;
              });
            },
            title: ShowTitle(
              title: 'พนักงานบริษัท / ลูกจ้าง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioGovernment(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Government',
            groupValue: typeOccupation,
            onChanged: (value) {
              setState(() {
                typeOccupation = value as String;
              });
            },
            title: ShowTitle(
              title: 'ข้าราชการ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioOwner(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'Owner',
            groupValue: typeOccupation,
            onChanged: (value) {
              setState(() {
                typeOccupation = value as String;
              });
            },
            title: ShowTitle(
              title: 'เจ้าของกิจการ',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioMale(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'M',
            groupValue: typeSex,
            onChanged: (value) {
              setState(() {
                typeSex = value as String;
              });
            },
            title: ShowTitle(
              title: 'ชาย',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioFemale(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'F',
            groupValue: typeSex,
            onChanged: (value) {
              setState(() {
                typeSex = value as String;
              });
            },
            title: ShowTitle(
              title: 'หญิง',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioLT18(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'LT18',
            groupValue: typeAge,
            onChanged: (value) {
              setState(() {
                typeAge = value as String;
              });
            },
            title: ShowTitle(
              title: 'ต่ำกว่า 18 ปี',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioGT18_25(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'GT18-25',
            groupValue: typeAge,
            onChanged: (value) {
              setState(() {
                typeAge = value as String;
              });
            },
            title: ShowTitle(
              title: 'มากกว่า 18 - 25 ปี',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioGT25_60(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'GT25-60',
            groupValue: typeAge,
            onChanged: (value) {
              setState(() {
                typeAge = value as String;
              });
            },
            title: ShowTitle(
              title: 'มากกว่า 25 - 60 ปี',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioGT60(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'GT60',
            groupValue: typeAge,
            onChanged: (value) {
              setState(() {
                typeAge = value as String;
              });
            },
            title: ShowTitle(
              title: 'มากกว่า 60 ปี',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          width: size * 0.6,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่ชื่อด้วย คะ';
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name (ชื่อ) :',
              prefixIcon: Icon(
                Icons.person,
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

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่อีเมล์ (Email) คะ';
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Email :',
              prefixIcon: Icon(
                Icons.email,
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

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่เบอร์โทรศัพท์ด้วย คะ';
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Phone :',
              prefixIcon: Icon(
                Icons.phone,
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
                return 'กรุณาใส่ชื่อผู้ใช้ คะ';
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User :',
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

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin:
              EdgeInsets.only(top: 16, bottom: 20), //EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาใส่รหัสผ่าน คะ';
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.password,
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
