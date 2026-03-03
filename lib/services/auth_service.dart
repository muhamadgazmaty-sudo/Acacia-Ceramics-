import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isAdmin = false;

  // ⚠️ كلمة مرور الأدمن المشفرة
  static const String _adminEmailHash = '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918';
  
  User? get user => _user;
  bool get isAdmin => _isAdmin;
  bool get isLoggedIn => _user != null || _isAdmin;
  String get currentEmail => _isAdmin ? 'admin' : (_user?.email ?? '');

  // تشفير كلمة المرور
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // التحقق من الأدمن
    if (email == "admin" && _hashPassword(password) == _hashPassword("mgz1993")) {
      _isAdmin = true;
      _user = null;
      notifyListeners();
      
      await _firestore.collection('admin_logs').add({
        'action': 'login',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      return {'status': 'success', 'role': 'admin'};
    }

    // مستخدمين عاديين
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      final userData = userDoc.data();
      
      _user = userCredential.user;
      _isAdmin = userData?['role'] == 'admin';
      notifyListeners();
      
      return {'status': 'success', 'role': _isAdmin ? 'admin' : 'user'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<void> signOut() async {
    _isAdmin = false;
    _user = null;
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
