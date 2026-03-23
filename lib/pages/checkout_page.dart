import 'package:flutter/material.dart';
import 'home_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<ProductItem> cartItems;
  final double totalAmount;
  final VoidCallback onPaymentSuccess;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.onPaymentSuccess,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  void _payNow() {
    if (_cardController.text.isEmpty || _nameController.text.isEmpty || _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Success!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onPaymentSuccess();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total: Rs. ${widget.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Cardholder Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cvvController,
              decoration: const InputDecoration(labelText: 'CVV'),
              keyboardType: TextInputType.number,
              maxLength: 3,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _payNow,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _nameController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

