import 'package:flutter/material.dart';

class ProductItem {  //blueprint for product objects used throughout the app, it has two properties name and price, and a constructor to initialize them.
  final String name; //parameter 1 
  final double price;//parameter 2

  const ProductItem({required this.name, required this.price});
}

class HomePage extends StatelessWidget { //homepage doesnt store the data, the data is stored in rootpage 
  final List<ProductItem> items;
  final void Function(ProductItem item) onAddToCart;//funct recived from parent, when clicked "ADD", func called

  const HomePage({
    super.key,
    required this.items,
    required this.onAddToCart,
  });

  @override //build method ; responsible for rendering the UI
  Widget build(BuildContext context) {
    return ListView.builder( //used to create a scrollable list of items usinf parameters
      padding: const EdgeInsets.all(12),
      itemCount: items.length, //parameter 1: number of items in the list
      itemBuilder: (context, index) { //parameter 2: function that defines how each item in the list should be rendered
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8), //padding and spacing for each card
          child: ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(item.name),
            subtitle: Text('Rs. ${item.price.toStringAsFixed(0)}'),
            trailing: ElevatedButton(
              onPressed: () => onAddToCart(item),
              child: const Text('Add'),
            ),
          ),
        );
      },
    );
  }
}
