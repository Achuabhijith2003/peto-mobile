import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/owner.dart';

class OwnerProvider with ChangeNotifier {
  final String? _userId;
  Owner? _currentOwner;
  bool _isLoading = false;

  OwnerProvider(this._userId) {
    if (_userId != null) {
      loadOwnerProfile();
    }
  }

  Owner? get currentOwner => _currentOwner;
  bool get isLoading => _isLoading;

 Future<void> loadOwnerProfile() async {
  if (_userId == null || _isLoading) return;

  _isLoading = true;
  notifyListeners();

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      _currentOwner = Owner(
        id: _userId,
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        address: userData['address'] ?? '',
        imageUrl: userData['photoURL'] ?? '',
      );
    } else {
      _currentOwner = null;
    }
  } catch (error) {
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<String> _uploadImage(File imageFile) async {
    if (_userId == null) throw Exception('User not authenticated');
    
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$_userId.jpg');
    
    final uploadTask = storageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateOwnerProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    File? imageFile,
  }) async {
    if (_userId == null) throw Exception('User not authenticated');
    
    _isLoading = true;
    notifyListeners();
    
    try {
      Map<String, dynamic> updates = {
        'name': name,
        'email': email,
      };
      
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      
      String imageUrl = _currentOwner?.imageUrl ?? '';
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
        updates['photoURL'] = imageUrl;
      }
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update(updates);
      
      _currentOwner = Owner(
        id: _userId,
        name: name,
        email: email,
        phone: phone ?? _currentOwner?.phone ?? '',
        address: address ?? _currentOwner?.address ?? '',
        imageUrl: imageUrl,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}