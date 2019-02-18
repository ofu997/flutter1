// import 'package:flutter/material.dart';
// import './widgets/products/products.dart';
// // import './product_control.dart';

// class ProductManager extends StatelessWidget {
//   final List <Map<String, dynamic>> products;
//   // final Function addProduct;
//   // final Function deleteProduct;
//   final int count=1;
//   ProductManager(this.products){//putting a {} makes it a named argument // when argument is in curly brackets we can define it more clearly
//     print('[ProductsManager state] Constructor');
//   }

//   @override
//   Widget build(BuildContext context) { // context stores metadata like Themes
//     print('[ProductManager state] build()');
//     return Column(
//       children: [
//         Expanded(child: Products(products)),// _deleteProduct as a named argument     
//         // Container(height: 300.0, child: Products(_products)) // scrollable but within a container      
//       ]
//     );
//   }
// }

// Stateful, includes operations on products

// setState() causes another build

// here build includes a button that adds 'advanced food tester' 
// to _products, then calls Products(_products)
