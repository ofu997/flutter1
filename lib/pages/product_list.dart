import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget{
  final List<Map<String,dynamic>> products;

  ProductListPage(this.products);

  @override
  Widget build(BuildContext context) {
    //return Center(child: Text('All products'),);;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image.asset(products[index]['image']),
          title: Text(products[index]['title']),  
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){

            },
          ),
        );
    }, 
    itemCount: products.length,
    );
  }
}