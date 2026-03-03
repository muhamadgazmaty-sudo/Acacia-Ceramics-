import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/app_config_provider.dart';
import 'login_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acacia Ceramics'),
        backgroundColor: const Color(0xFF36454F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF36454F),
              Color(0xFFD4AF37),
            ],
          ),
        ),
        child: Column(
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '🏛️',
                    style: TextStyle(fontSize: 50),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مرحباً بك يا ${user?.displayName ?? \'مستخدم\'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Acacia Ceramics - للفخامة عنوان',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip(context, 'All', '🏠'),
                    _buildCategoryChip(context, 'Vases', '🏺'),
                    _buildCategoryChip(context, 'Plates', '🍽️'),
                    _buildCategoryChip(context, 'Bowls', '🥣'),
                    _buildCategoryChip(context, 'Decor', '🎨'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Products Grid
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, _products[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String name, String emoji) {
    return Consumer<AppConfigProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.selectedCategory == name;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text('$emoji $name'),
            selected: isSelected,
            onSelected: (selected) {
              provider.setCategory(name);
            },
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFFD4AF37),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF36454F),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Consumer<AppConfigProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF36454F).withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product['emoji'],
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF36454F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product['name']} أضيف للسلة'),
                              backgroundColor: const Color(0xFFD4AF37),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'أضف',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // منتجات تجريبية
  static final List<Map<String, dynamic>> _products = [
    {'name': 'Vase Classic', 'price': '45.00', 'emoji': '🏺', 'category': 'Vases'},
    {'name': 'Plate Gold', 'price': '25.00', 'emoji': '🍽️', 'category': 'Plates'},
    {'name': 'Bowl Elegant', 'price': '30.00', 'emoji': '🥣', 'category': 'Bowls'},
    {'name': 'Decor Royal', 'price': '55.00', 'emoji': '🎨', 'category': 'Decor'},
    {'name': 'Vase Modern', 'price': '50.00', 'emoji': '🏺', 'category': 'Vases'},
    {'name': 'Plate White', 'price': '20.00', 'emoji': '🍽️', 'category': 'Plates'},
    {'name': 'Bowl Deep', 'price': '35.00', 'emoji': '🥣', 'category': 'Bowls'},
    {'name': 'Decor Art', 'price': '60.00', 'emoji': '🎨', 'category': 'Decor'},
  ];
}
