import 'package:flutter/material.dart';
import './product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(color: Colors.pink),
          key: Key(products[index]
              ['title']), //this needs to become 'id' later to fully delete data
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              print('end to start');
              deleteProduct(index);
            } else if (direction == DismissDirection.startToEnd) {
              print('start to end');
            } else {
              print('other swipe');
            }
          },
          child: Column(
            children: <Widget>[
              ListTile(
                //leading: Container(child: Image.asset(products[index]['image']),width: 75.0),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(products[index]['image']),
                ),
                title: Text(products[index]['title']),
                subtitle: Text('\$${products[index]['price'].toString()}'),
                trailing: _buildEditButton(context, index),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }

  Widget _buildEditButton(BuildContext context, index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage(
                  product: products[index],
                  updateProduct: updateProduct,
                  productIndex: index); //we don't pass addProduct here
            },
          ),
        );
      },
    );
  }
}
