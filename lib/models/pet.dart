class Pet {
  final String id;
  final String ownerId;
  String name;
  String breed;
  // DateTime birthDate;
  // String imageUrl;
  // List<Vaccination> vaccinationHistory;
  // List<Vaccination> upcomingVaccinations;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.breed,
    // required this.birthDate,
    // this.imageUrl = '',
    // required this.vaccinationHistory,
    // required this.upcomingVaccinations,
  });

  // Calculate age in years and months
  // String get age {
  //   final now = DateTime.now();
  //   final difference = now.difference(birthDate);
  //   final years = (difference.inDays / 365).floor();
  //   final months = ((difference.inDays % 365) / 30).floor();

  //   if (years > 0) {
  //     return '$years year${years > 1 ? 's' : ''} ${months > 0 ? ', $months month${months > 1 ? 's' : ''}' : ''}';
  //   } else {
  //     return '$months month${months > 1 ? 's' : ''}';
  //   }
  // }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'breed': breed,
      // 'birthDate': birthDate.toIso8601String(),
      // 'imageUrl': imageUrl,
      // 'vaccinationHistory': vaccinationHistory.map((v) => v.toMap()).toList(),
      // 'upcomingVaccinations':
      //     upcomingVaccinations.map((v) => v.toMap()).toList(),
    };
  }

  // Create from map for storage retrieval
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      breed: map['breed'] as String,
      // birthDate: DateTime.parse(map['birthDate']),
      // imageUrl: map['imageUrl'] as String,
      // vaccinationHistory:
      //     (map['vaccinationHistory'] as List)
      //         .map((v) => Vaccination.fromMap(v))
      //         .toList(),
      // upcomingVaccinations:
      //     (map['upcomingVaccinations'] as List)
      //         .map((v) => Vaccination.fromMap(v))
      //         .toList(),
    );
  }
}

class Vaccination {
  final String id;
  final String name;
  final DateTime date;
  final bool completed;
  final String notes;

  Vaccination({
    required this.id,
    required this.name,
    required this.date,
    this.completed = false,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'completed': completed,
      'notes': notes,
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      completed: map['completed'],
      notes: map['notes'],
    );
  }
}
