import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String usertype;
  final String occupation;
  final String sex;
  final String age;
  final String email;
  final String phone;
  final String user;
  final String password;
  UserModel({
    required this.id,
    required this.name,
    required this.usertype,
    required this.occupation,
    required this.sex,
    required this.age,
    required this.email,
    required this.phone,
    required this.user,
    required this.password,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? usertype,
    String? occupation,
    String? sex,
    String? age,
    String? email,
    String? phone,
    String? user,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      usertype: usertype ?? this.usertype,
      occupation: occupation ?? this.occupation,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'usertype': usertype,
      'occupation': occupation,
      'sex': sex,
      'age': age,
      'email': email,
      'phone': phone,
      'user': user,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      usertype: map['usertype'],
      occupation: map['occupation'],
      sex: map['sex'],
      age: map['age'],
      email: map['email'],
      phone: map['phone'],
      user: map['user'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, usertype: $usertype, occupation: $occupation, sex: $sex, age: $age, email: $email, phone: $phone, user: $user, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.name == name &&
      other.usertype == usertype &&
      other.occupation == occupation &&
      other.sex == sex &&
      other.age == age &&
      other.email == email &&
      other.phone == phone &&
      other.user == user &&
      other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      usertype.hashCode ^
      occupation.hashCode ^
      sex.hashCode ^
      age.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      user.hashCode ^
      password.hashCode;
  }
}
