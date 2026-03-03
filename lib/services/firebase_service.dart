import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection('products').snapshots();
  }

  Future<DocumentSnapshot> getProduct(String id) {
    return _firestore.collection('products').doc(id).get();
  }

  Future<void> addProduct(Map<String, dynamic> data) {
    return _firestore.collection('products').add(data);
  }

  Stream<QuerySnapshot> getCategories() {
    return _firestore.collection('categories').snapshots();
  }

  Future<void> submitOrder(Map<String, dynamic> orderData) {
    return _firestore.collection('orders').add(orderData);
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
