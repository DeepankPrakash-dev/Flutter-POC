import 'package:flutter/material.dart';
import 'home_page.dart';

class CartPage extends StatelessWidget {
  final List<ProductItem> cartItems; //productitem coming from parent class, i.e., home_page.dart
  final void Function(int index) onRemove;
  final VoidCallback onClearCart;

  const CartPage({ //constructor for cartpage
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    final double total = cartItems.fold(0, (sum, item) => sum + item.price); //fold, reduces list to a single value and starts from 0

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              Text(
                'Items: ${cartItems.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearCart,
                child: const Text('Clear Cart'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('Rs. ${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    onPressed: () => onRemove(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity, //full width streched
          padding: const EdgeInsets.all(14),
          color: Colors.blue.shade50,
          child: Text(
            'Total: Rs. ${total.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
