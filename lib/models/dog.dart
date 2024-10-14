//import 'package:meta/meta.dart';

class Dog {
  final int externalId;
  final String sex;
  final String color;
  final String breed;
  final String name;
  final String description;
  final String avatarUrl;
  final String location;
  final int likeCounter;
  final bool isAdopted;
  final List<String> pictures;
  final List<String> dogattributes;

  Dog({
    required this.externalId,
    required this.sex,
    required this.color,
    required this.breed,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.location,
    required this.likeCounter,
    required this.isAdopted,
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
      color: json['color'] ?? 'Sin color especificado',
      breed: json['breed'] ?? 'Sin raza especificada',
      pictures:
          json['pictures'] != null ? List<String>.from(json['pictures']) : [],
      dogattributes: json['dogattributes'] != null
          ? List<String>.from(json['dogattributes'])
          : [],
    );
  }
}
