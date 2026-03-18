import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/user_profile_page.dart';
import 'services/api_service.dart';

void main() {
  // Entry point of the application; as an on switch for a application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //doesnt hold data, just a blueprint 
  const MyApp({super.key});//super.key passes key to the parent class(statelesswidget)

  @override// to replacing method from a parent class
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RootPage(), // what the user sees first thing
    );
  }
}

class RootPage extends StatefulWidget {//hold data and logic for the app
  //screen can be realoded with statefulwidget, not with stateless widget
  const RootPage({
    super.key,
  }); //rootpage is the main widget itself , and _rootpagestate holds data and the build() method.

  @override
  State<RootPage> createState() => _RootPageState();//create state to hold the data and logic 
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  final List<ProductItem> _cartItems = [];
  late Future<List<ProductItem>> _productsFuture; //late means the data will be initialized later

  @override
  void initState() {
    super.initState();//call parent class initstate
    _productsFuture = ApiService.fetchProducts();
  }

  void _addToCart(ProductItem item) {
    setState(() {
      _cartItems.add(item);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.name} added to cart')));
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductItem>>(//widget that builds itself based on a future state
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {//snapshot, contains data and state of the future; ConnectionState.waiting, while waiting for API response
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!;//list of all products is fetched from the API

          return IndexedStack(
            index: currentPage,
            children: [
              HomePage(items: products, onAddToCart: _addToCart),
              CartPage(
                cartItems: _cartItems,
                onRemove: _removeFromCart,
                onClearCart: _clearCart,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Floating action button');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text(_cartItems.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
