import 'dart:convert';

class PlantModel {
  final String id;
  final String idPlanter;
  final String namePlanter;
  final String name;
  final String place;
  final String lat;
  final String lng;
  final String avatar;
  PlantModel({
    required this.id,
    required this.idPlanter,
    required this.namePlanter,
    required this.name,
    required this.place,
    required this.lat,
    required this.lng,
    required this.avatar,
  });

  PlantModel copyWith({
    String? id,
    String? idPlanter,
    String? namePlanter,
    String? name,
    String? place,
    String? lat,
    String? lng,
    String? avatar,
  }) {
    return PlantModel(
      id: id ?? this.id,
      idPlanter: idPlanter ?? this.idPlanter,
      namePlanter: namePlanter ?? this.namePlanter,
      name: name ?? this.name,
      place: place ?? this.place,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPlanter': idPlanter,
      'namePlanter': namePlanter,
      'name': name,
      'place': place,
      'lat': lat,
      'lng': lng,
      'avatar': avatar,
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'],
      idPlanter: map['idPlanter'],
      namePlanter: map['namePlanter'],
      name: map['name'],
      place: map['place'],
      lat: map['lat'],
      lng: map['lng'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) => PlantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlantModel(id: $id, idPlanter: $idPlanter, namePlanter: $namePlanter, name: $name, place: $place, lat: $lat, lng: $lng, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PlantModel &&
      other.id == id &&
      other.idPlanter == idPlanter &&
      other.namePlanter == namePlanter &&
      other.name == name &&
      other.place == place &&
      other.lat == lat &&
      other.lng == lng &&
      other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idPlanter.hashCode ^
      namePlanter.hashCode ^
      name.hashCode ^
      place.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      avatar.hashCode;
  }
}
