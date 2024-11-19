import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  // Sample data for products
  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Product 1',
      'price': 100.0,
      'quantity': 10,
    },
    {
      'id': '2',
      'name': 'Product 2',
      'price': 50.0,
      'quantity': 5,
    },
    // Add more products as needed
  ];

  // Function to get product by ID
  Map<String, dynamic>? getProductById(String id) {
    return products.firstWhere(
          (product) => product['id'] == id,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blueGrey, // Match the color with home.dart
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            color: Colors.blueGrey[50], // Light background for product cards
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                product['name'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900], // Dark text color for contrast
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Price: \$${product['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Quantity: ${product['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.blueGrey),
                onPressed: () {
                  // Handle add to cart action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product['name']} added to cart')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
