import 'package:uuid/uuid.dart';

class Farm {
  final String id;
  String name;
  String location;
  int area;
  DateTime createdAt;

  Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.area,
    required this.createdAt,
  });

  Farm.create({
    required this.name,
    required this.location,
    required this.area,
  }) : id = const Uuid().v4(),
      createdAt = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'area': area,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      area: json['area'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}