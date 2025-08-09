import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  final String? _userId;
  List<Pet> _pets = [];
  final _uuid = Uuid();
  bool _isLoading = false;

  PetProvider(this._userId) {
    if (_userId != null) {
      loadPets();
    }
  }

  List<Pet> get pets => [..._pets];
  bool get isLoading => _isLoading;

  List<Pet> getPetsByOwner(String ownerId) {
    return _pets.where((pet) => pet.ownerId == ownerId).toList();
  }

  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadPets() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .collection('pets')
              .get();

      _pets =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Pet.fromMap({...data, 'id': doc.id});
          }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> _uploadImage(File imageFile, String petId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('pet_images')
        .child(_userId)
        .child('$petId.jpg');

    final uploadTask = storageRef.putFile(imageFile);

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addPet(
    String ownerId,
    String name,
    String breed,
    DateTime birthDate,
    File? imageFile,
    List<Vaccination> upcomingVaccinations,
  ) async {
    if (_userId == null) throw Exception('User not authenticated');

    _isLoading = true;
    notifyListeners();

    try {
      final petId = _uuid.v4();
      // String imageUrl = '';

      if (imageFile != null) {
        // imageUrl = await _uploadImage(imageFile, petId);
      }

      final petData = {
        'ownerId': ownerId,
        'name': name,
        'breed': breed,
        // 'birthDate': birthDate.toIso8601String(),
        // 'imageUrl': imageUrl,
        // 'vaccinationHistory': [],
        // 'upcomingVaccinations':
        //     upcomingVaccinations.map((v) => v.toMap()).toList(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('pets')
          .doc(petId)
          .set(petData);

      final newPet = Pet(
        id: petId,
        ownerId: ownerId,
        name: name,
        breed: breed,
        // birthDate: birthDate,
        // imageUrl: imageUrl,
        // vaccinationHistory: [],
        // upcomingVaccinations: upcomingVaccinations,
      );

      _pets.add(newPet);
      _isLoading = false;
      notifyListeners();
      print('Pet added successfully');
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePet(Pet pet, {File? newImageFile}) async {
    if (_userId == null) throw Exception('User not authenticated');

    _isLoading = true;
    notifyListeners();

    try {
      // String imageUrl = pet.imageUrl;

      // if (newImageFile != null) {
      //   imageUrl = await _uploadImage(newImageFile, pet.id);
      // }

      final updatedPet = Pet(
        id: pet.id,
        ownerId: pet.ownerId,
        name: pet.name,
        breed: pet.breed,
        // birthDate: pet.birthDate,
        // imageUrl: imageUrl,
        // vaccinationHistory: pet.vaccinationHistory,
        // upcomingVaccinations: pet.upcomingVaccinations,
      );

      final petData = {
        'ownerId': updatedPet.ownerId,
        'name': updatedPet.name,
        'breed': updatedPet.breed,
        // 'birthDate': updatedPet.birthDate.toIso8601String(),
        // 'imageUrl': imageUrl,
        // 'vaccinationHistory':
        //     updatedPet.vaccinationHistory.map((v) => v.toMap()).toList(),
        // 'upcomingVaccinations':
        //     updatedPet.upcomingVaccinations.map((v) => v.toMap()).toList(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('pets')
          .doc(pet.id)
          .update(petData);

      final petIndex = _pets.indexWhere((p) => p.id == pet.id);
      if (petIndex >= 0) {
        _pets[petIndex] = updatedPet;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePet(String id) async {
    if (_userId == null) throw Exception('User not authenticated');

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('pets')
          .doc(id)
          .delete();

      // Delete pet image if it exists
      try {
        await FirebaseStorage.instance
            .ref()
            .child('pet_images')
            .child(_userId)
            .child('$id.jpg')
            .delete();
      } catch (e) {
        // Image might not exist, ignore error
      }

      _pets.removeWhere((pet) => pet.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Future<void> addVaccination(String petId, Vaccination vaccination) async {
  //   if (_userId == null) throw Exception('User not authenticated');

  //   final pet = getPetById(petId);
  //   if (pet == null) throw Exception('Pet not found');

  //   try {
  //     final petRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(_userId)
  //         .collection('pets')
  //         .doc(petId);

  //     if (vaccination.completed) {
  //       await petRef.update({
  //         'vaccinationHistory': FieldValue.arrayUnion([vaccination.toMap()]),
  //       });
  //       pet.vaccinationHistory.add(vaccination);
  //     } else {
  //       await petRef.update({
  //         'upcomingVaccinations': FieldValue.arrayUnion([vaccination.toMap()]),
  //       });
  //       pet.upcomingVaccinations.add(vaccination);
  //     }

  //     notifyListeners();
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  //   Future<void> completeVaccination(String petId, String vaccinationId) async {
  //     if (_userId == null) throw Exception('User not authenticated');

  //     final pet = getPetById(petId);
  //     if (pet == null) throw Exception('Pet not found');

  //     try {
  //       final vacIndex = pet.upcomingVaccinations.indexWhere(
  //         (v) => v.id == vaccinationId,
  //       );
  //       if (vacIndex < 0) throw Exception('Vaccination not found');

  //       final vaccination = pet.upcomingVaccinations[vacIndex];
  //       final completedVaccination = Vaccination(
  //         id: vaccination.id,
  //         name: vaccination.name,
  //         date: DateTime.now(),
  //         completed: true,
  //         notes: vaccination.notes,
  //       );

  //       final petRef = FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(_userId)
  //           .collection('pets')
  //           .doc(petId);

  //       // Use a transaction to ensure data consistency
  //       await FirebaseFirestore.instance.runTransaction((transaction) async {
  //         // Get the current pet data
  //         final petDoc = await transaction.get(petRef);
  //         if (!petDoc.exists) throw Exception('Pet not found');

  //         // Extract the current vaccination lists
  //         List<dynamic> upcomingVaccinations = List.from(
  //           petDoc.data()!['upcomingVaccinations'] ?? [],
  //         );
  //         List<dynamic> vaccinationHistory = List.from(
  //           petDoc.data()!['vaccinationHistory'] ?? [],
  //         );

  //         // Find and remove the vaccination from upcoming
  //         int indexToRemove = -1;
  //         for (int i = 0; i < upcomingVaccinations.length; i++) {
  //           if (upcomingVaccinations[i]['id'] == vaccinationId) {
  //             indexToRemove = i;
  //             break;
  //           }
  //         }

  //         if (indexToRemove >= 0) {
  //           upcomingVaccinations.removeAt(indexToRemove);
  //           vaccinationHistory.add(completedVaccination.toMap());

  //           // Update the document
  //           transaction.update(petRef, {
  //             'upcomingVaccinations': upcomingVaccinations,
  //             'vaccinationHistory': vaccinationHistory,
  //           });
  //         }
  //       });

  //       // Update local data
  //       pet.upcomingVaccinations.removeAt(vacIndex);
  //       pet.vaccinationHistory.add(completedVaccination);

  //       notifyListeners();
  //     } catch (error) {
  //       rethrow;
  //     }
  //   }
  // }
}
