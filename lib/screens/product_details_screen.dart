import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirebaseService _fb = FirebaseService();
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل المنتج"),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
              _fb.toggleFavorite(widget.product['id']);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                'شاهد هذا السيراميك الرائع من آكاسيا: ${widget.product['name']}',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معرض الصور
            SizedBox(
              height: 300,
              width: double.infinity,
              child: widget.product['images']?.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: widget.product['images'][0],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.image, size: 60)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['name'] ?? 'اسم المنتج',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF36454F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product['price'] ?? '0'}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "المواصفات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product['description'] ?? 'لا يوجد وصف متاح.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  // زر AR
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.view_in_ar),
                      label: const Text("عرض في غرفتك (AR)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF36454F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("جاري تحميل نموذج ثلاثي الأبعاد..."),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // زر واتساب للمنتج
                  OutlinedButton.icon(
                    icon: const Icon(Icons.whatsapp, color: Color(0xFF25D366)),
                    label: const Text(
                      "استفسار عبر واتساب",
                      style: TextStyle(color: Color(0xFF25D366)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF25D366)),
                    ),
                    onPressed: () {
                      // فتح واتساب مع رسالة جاهزة
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
