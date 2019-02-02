import 'package:flutter/material.dart';
import './product_edit.dart';
class ProductListPage extends StatelessWidget{
  final List<Map<String,dynamic>> products;

  ProductListPage(this.products);

  @override
  Widget build(BuildContext context) {
    //return Center(child: Text('All products'),);;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Container(child: Image.asset(products[index]['image']),width: 75.0),
          title: Text(products[index]['title']),  
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return ProductEditPage(product: products[index]);
                  },
                ),
              );
            },
          ),
        );
    }, 
    itemCount: products.length,
    );
  }
}