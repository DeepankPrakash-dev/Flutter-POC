import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/user_profile_page.dart';
import 'pages/login_page.dart';
import 'services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _page = 0;
  final _cart = <ProductItem>[];
  late Future<List<ProductItem>> _products;
  bool _loggedIn = false;
  String _user = '';

  @override
  void initState() {
    super.initState();
    _products = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) return LoginPage(onLoginSuccess: (u) => setState(() { _loggedIn = true; _user = u; }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserProfilePage(username: _user, onLogout: () => setState(() { _loggedIn = false; _user = ''; _cart.clear(); }))),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductItem>>(
        future: _products,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No products'));
          final products = snapshot.data!;
          return IndexedStack(
            index: _page,
            children: [
              HomePage(items: products, onAddToCart: (item) => setState(() { _cart.add(item); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added'))); })),
              CartPage(cartItems: _cart, onRemove: (i) => setState(() => _cart.removeAt(i)), onClearCart: () => setState(_cart.clear)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist Created!'), backgroundColor: Colors.green)),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Badge(isLabelVisible: _cart.isNotEmpty, label: Text(_cart.length.toString()), child: const Icon(Icons.shopping_cart)),
            label: 'Cart',
          ),
        ],
        onDestinationSelected: (i) => setState(() => _page = i),
        selectedIndex: _page,
      ),
    );
  }
}
