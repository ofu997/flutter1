import 'package:flutter/material.dart';
import './product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';



class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage(); //we don't pass addProduct here
            },
          ),
        );
      },
    );
  } 

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(color: Colors.pink),
          key: Key(model.allProducts[index].title), 
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              model.selectProduct(index);
              model.deleteProduct();
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
                  backgroundImage: AssetImage(model.allProducts[index].image),
                ),
                title: Text(model.allProducts[index].title),
                subtitle: Text('\$${model.allProducts[index].price.toString()}'),
                trailing: _buildEditButton(context, index, model),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: model.allProducts.length,
    );
      }
    );
  }
}


