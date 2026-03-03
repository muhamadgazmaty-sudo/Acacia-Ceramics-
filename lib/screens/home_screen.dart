import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/app_config_provider.dart';
import '../services/firebase_service.dart';
import 'login_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    final uri = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final config = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // الانتقال للمفضلة
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // الانتقال للإعدادات
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // البانرات
            StreamBuilder(
              stream: FirebaseService().getBanners(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final banners = snapshot.data as List;
                if (banners.isEmpty) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text("لا توجد بانرات")),
                  );
                }
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: banners.map((banner) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: banner['image_url'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            // الأقسام
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "الأقسام",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: config.primaryColor,
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseService().getCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final categories = snapshot.data as List;
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (ctx, i) {
                      final cat = categories[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: config.primaryColor,
                              child: cat['image_url'] != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: cat['image_url'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.category, color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(cat['name'] ?? 'قسم'),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // المنتجات
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "أحدث المنتجات",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: config.primaryColor,
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseService().getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data as List;
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      final p = products[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 150,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsScreen(product: p),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: p['images']?.isNotEmpty == true
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            imageUrl: p['images'][0],
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(color: Colors.grey[300]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(
                                        p['name'] ?? 'منتج',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${p['price'] ?? '0'}',
                                        style: TextStyle(
                                          color: config.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchWhatsApp(context, config.whatsappNumber),
        backgroundColor: const Color(0xFF25D366),
        icon: const Icon(Icons.message, color: Colors.white),
        label: const Text("تواصل معنا", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
