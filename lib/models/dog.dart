//import 'package:meta/meta.dart';

//enum Donortype { protectora, particular }

class Dog {
  //final Donortype donortype;
  //final String donorname;
  final int externalId;
  final String name;
  final String description;
  final String avatarUrl;
  final String location;
  final int likeCounter;
  final bool isAdopted;
  final String sex;
  final String breed;
  final String color;
  final List<String> pictures;
  final List<String> dogattributes;

  Dog({
    //required this.donortype,
    //required this.donorname,
    required this.externalId,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.location,
    required this.likeCounter,
    required this.isAdopted,
    required this.sex,
    required this.breed,
    required this.color,
    required this.pictures,
    required this.dogattributes,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      externalId: json['id'] != null ? json['id'] as int : 0,
      name: json['name'] ?? 'Sin nombre',
      description: json['description'] ?? 'Sin descripción',
      avatarUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      location: json['location'] ?? 'Ubicación no disponible',
      likeCounter:
          json['like_counter'] != null ? json['like_counter'] as int : 0,
      isAdopted: json['adopted'] != null ? json['adopted'] as bool : false,
      sex: json['sex'] ?? 'Sin sexo epecificado',
      color: json['sex'] ?? 'Sin color especificado',
      breed: json['sex'] ?? 'Sin raza especificada',
      pictures:
          json['pictures'] != null ? List<String>.from(json['pictures']) : [],
      dogattributes: json['dogattributes'] != null
          ? List<String>.from(json['dogattributes'])
          : [],
    );
  }
}
