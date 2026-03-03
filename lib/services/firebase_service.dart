import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // جلب المنتجات
  Stream<List<Map<String, dynamic>>> getProducts() {
    return _firestore.collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList());
  }

  // إضافة منتج
  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _firestore.collection('products').add({
      ...productData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // حذف منتج
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  // جلب الأقسام
  Stream<List<Map<String, dynamic>>> getCategories() {
    return _firestore.collection('categories')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList());
  }

  // إضافة قسم
  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    await _firestore.collection('categories').add({
      ...categoryData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // حذف قسم
  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }

  // جلب البانرات
  Stream<List<Map<String, dynamic>>> getBanners() {
    return _firestore.collection('banners')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList());
  }

  // إضافة بانر
  Future<void> addBanner(Map<String, dynamic> bannerData) async {
    await _firestore.collection('banners').add({
      ...bannerData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // حذف بانر
  Future<void> deleteBanner(String bannerId) async {
    await _firestore.collection('banners').doc(bannerId).delete();
  }

  // تبديل المفضلة
  Future<void> toggleFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);
    final doc = await userRef.get();
    List<dynamic> favorites = doc.data()?['favorites'] ?? [];

    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    await userRef.update({'favorites': favorites});
  }

  // رفع صورة
  Future<String> uploadImage(String path, Uint8List imageData) async {
    final ref = _storage.ref().child(path).child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putData(imageData);
    return await ref.getDownloadURL();
  }

  // جلب إعدادات التطبيق
  Future<Map<String, dynamic>> getAppConfig() async {
    final doc = await _firestore.collection('app_config').doc('settings').get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return {
      'app_name': 'Acacia Ceramics',
      'primary_color': '#D4AF37',
      'whatsapp_number': '306974193285',
    };
  }

  // تحديث إعدادات التطبيق
  Future<void> updateAppConfig(Map<String, dynamic> data) async {
    await _firestore.collection('app_config').doc('settings').set(
      data,
      SetOptions(merge: true),
    );
  }
}
