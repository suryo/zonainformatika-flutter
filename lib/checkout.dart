import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Example cart items
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Item 1',
      'price': 100.0,
      'quantity': 2,
    },
    {
      'name': 'Item 2',
      'price': 50.0,
      'quantity': 1,
    },
    {
      'name': 'Item 3',
      'price': 150.0,
      'quantity': 1,
    },
  ];

  // To calculate the total price
  double _calculateTotalPrice() {
    return _cartItems.fold(0.0, (total, item) => total + (item['price'] * item['quantity']));
  }

  // Form controllers for shipping info
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // Function to handle the checkout process
  void _handleCheckout() {
    // You can add validation and further checkout logic here
    if (_nameController.text.isNotEmpty && _addressController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      // Proceed with checkout
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout Successful!')));
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the details!')));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items List
            Text(
              'Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                    color: Colors.blueGrey[50], // Light background for product cards
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                ),
child: ListTile(
  title: Text(item['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
  subtitle: Text('Price: \$${item['price']} | Quantity: ${item['quantity']}', style: TextStyle(fontSize: 14, color: Colors.blueGrey[900])),
  trailing: Text('Total: \$${item['price'] * item['quantity']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
),
                );

              },
            ),

            // Total Price
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Total: \$${_calculateTotalPrice()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Shipping Info Form
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                ),

              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            // Checkout Button
            ElevatedButton(
              onPressed: _handleCheckout,
              child: Text('Confirm Order'),
              style: ElevatedButton.styleFrom(
                // primary: Colors.black87,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
