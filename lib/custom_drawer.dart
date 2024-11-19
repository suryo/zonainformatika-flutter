import 'package:flutter/material.dart';
import 'package:zonainformatika/cart.dart';
import 'package:zonainformatika/checkout.dart';
import 'package:zonainformatika/home.dart';
import 'package:zonainformatika/home2.dart';
import 'package:zonainformatika/message.dart';
import 'package:zonainformatika/message2.dart';
import 'package:zonainformatika/products.dart';
import 'tentangkami.dart';
import 'list_todo_page.dart';
import 'add_todo_page.dart';
import 'login.dart';
import 'about_us_page.dart';
import 'contact_us_page.dart';
import 'affiliate_page.dart';
import 'term_page.dart';
import 'privacy_policy_page.dart';
import 'map.dart';
import 'chat.dart';

class CustomDrawer extends StatelessWidget {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Product 1',
      'price': 100.0,
      'quantity': 2, // Quantity of Product 1
    },
    {
      'name': 'Product 2',
      'price': 50.0,
      'quantity': 1, // Quantity of Product 2
    },
    {
      'name': 'Product 3',
      'price': 150.0,
      'quantity': 3, // Quantity of Product 3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Container(
        color: Color(0xFF151515), // Set drawer background color to black
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                ),
              ),
            ),
            // ListTile(
            //   title: Text(
            //     'List Todo',
            //     style: TextStyle(color: Colors.black87), // Set text color to white
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ListTodoPage(data: 'test'),
            //       ),
            //     );
            //   },
            // ),
            // ListTile(
            //   title: Text(
            //     'Add Todo',
            //     style: TextStyle(color: Colors.black87), // Set text color to white
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => AddTodoPage(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Home2',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home2(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'About Us',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Contact Us',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Affiliate',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AffiliatePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Term',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Map',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Chat',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Message',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(chatName: "My Wife"),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Message',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Message2Page(contactName: "My Wife"),
                  ),
                );
              },
            ),

            ListTile(
              title: Text(
                'Cart',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(cartItems: cartItems),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Checkout',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Products',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
