import 'package:uuid/uuid.dart';

class Vaccination {
  final String id;
  String name;
  DateTime date;
  String notes;

  Vaccination({
    required this.id,
    required this.name,
    required this.date,
    required this.notes,
  });

  Vaccination.create({
    required this.name,
    required this.date,
    required this.notes,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}

class Insemination {
  final String id;
  DateTime date;
  bool confirmed;
  String notes;

  Insemination({
    required this.id,
    required this.date,
    required this.confirmed,
    required this.notes,
  });

  Insemination.create({
    required this.date,
    required this.confirmed,
    required this.notes,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'confirmed': confirmed,
      'notes': notes,
    };
  }

  factory Insemination.fromJson(Map<String, dynamic> json) {
    return Insemination(
      id: json['id'],
      date: DateTime.parse(json['date']),
      confirmed: json['confirmed'],
      notes: json['notes'],
    );
  }
}

class WeightRecord {
  final String id;
  double weight;
  DateTime date;
  String notes;

  WeightRecord({
    required this.id,
    required this.weight,
    required this.date,
    required this.notes,
  });

  WeightRecord.create({
    required this.weight,
    required this.date,
    required this.notes,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      id: json['id'],
      weight: json['weight'].toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }
}

class Cattle {
  final String id;
  String identifier;
  String farmId;
  String breed;
  DateTime birthDate;
  String gender;
  List<Vaccination> vaccinations;
  List<Insemination> inseminations;
  List<WeightRecord> weightRecords;
  DateTime createdAt;

  Cattle({
    required this.id,
    required this.identifier,
    required this.farmId,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.vaccinations,
    required this.inseminations,
    required this.weightRecords,
    required this.createdAt,
  });

  Cattle.create({
    required this.identifier,
    required this.farmId,
    required this.breed,
    required this.birthDate,
    required this.gender,
  })  : id = const Uuid().v4(),
        vaccinations = [],
        inseminations = [],
        weightRecords = [],
        createdAt = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identifier': identifier,
      'farmId': farmId,
      'breed': breed,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
      'inseminations': inseminations.map((i) => i.toJson()).toList(),
      'weightRecords': weightRecords.map((w) => w.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Cattle.fromJson(Map<String, dynamic> json) {
    return Cattle(
      id: json['id'],
      identifier: json['identifier'],
      farmId: json['farmId'],
      breed: json['breed'],
      birthDate: DateTime.parse(json['birthDate']),
      gender: json['gender'],
      vaccinations: (json['vaccinations'] as List)
          .map((v) => Vaccination.fromJson(v))
          .toList(),
      inseminations: (json['inseminations'] as List)
          .map((i) => Insemination.fromJson(i))
          .toList(),
      weightRecords: (json['weightRecords'] as List)
          .map((w) => WeightRecord.fromJson(w))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  void addVaccination(Vaccination vaccination) {
    vaccinations.add(vaccination);
  }

  void addInsemination(Insemination insemination) {
    inseminations.add(insemination);
  }

  void addWeightRecord(WeightRecord record) {
    weightRecords.add(record);
  }
}