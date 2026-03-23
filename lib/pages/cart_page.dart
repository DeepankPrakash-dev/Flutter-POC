import 'package:flutter/material.dart';
import 'home_page.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  final List<ProductItem> cartItems;
  final void Function(int index) onRemove;
  final VoidCallback onClearCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    final total = cartItems.fold(0.0, (sum, item) => sum + item.price);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text('${cartItems.length} items'),
              const Spacer(),
              TextButton(onPressed: onClearCart, child: const Text('Clear')),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(cartItems[i].name),
              subtitle: Text('Rs. ${cartItems[i].price.toStringAsFixed(0)}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onRemove(i),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          color: Colors.blue.shade50,
          child: Column(
            children: [
              Text(
                'Total: Rs. ${total.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        cartItems: cartItems,
                        totalAmount: total,
                        onPaymentSuccess: onClearCart,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

