import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';



class ProductsPage extends StatelessWidget{
  Widget _buildSideDrawer(BuildContext context) {//we pass context in callback and construct it with (BuildContext context) 
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false, 
            title: Text('Choose below'),
          ), //automaticallyImplyLeading: whether to assume AppBar actions
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Food List'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: Products(), // an argument here would override the one in Constructor
    );
  }
}

  // final List<Product> products;

  // ProductsPage(this.products);