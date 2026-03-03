import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppConfigProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Map<String, dynamic> _config = {
    'app_name': 'Acacia Ceramics',
    'app_icon_url': '',
    'primary_color': '#D4AF37',
    'whatsapp_number': '963900000000',
    'push_enabled': true,
  };
  
  bool _isLoading = true;
  
  Map<String, dynamic> get config => _config;
  String get appName => _config['app_name'] ?? 'Acacia Ceramics';
  String get appIconUrl => _config['app_icon_url'] ?? '';
  String get whatsappNumber => _config['whatsapp_number'] ?? '963900000000';
  Color get primaryColor => _hexToColor(_config['primary_color'] ?? '#D4AF37');
  bool get isLoading => _isLoading;

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Future<void> loadConfig() async {
    try {
      final doc = await _firestore.collection('app_config').doc('settings').get();
      if (doc.exists) {
        _config = {..._config, ...doc.data()!};
      }
    } catch (e) {
      print('Error loading config: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConfig(Map<String, dynamic> newData) async {
    await _firestore.collection('app_config').doc('settings').update(newData);
    _config = {..._config, ...newData};
    notifyListeners();
  }

  Stream<void> listenToConfig() async* {
    yield* _firestore.collection('app_config').doc('settings').snapshots().map((doc) {
      if (doc.exists) {
        _config = {..._config, ...doc.data()!};
        notifyListeners();
      }
    });
  }
}
