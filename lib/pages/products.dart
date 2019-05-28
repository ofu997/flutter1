import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';


class ProductsPage extends StatefulWidget{
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState(){
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage>{
  @override
  initState(){
    print('in pages/products');
    widget.model.fetchProducts();
    super.initState();
    // print('finished initState');
  }

  Widget _buildSideDrawer(BuildContext context) {//we pass context in callback and construct it with (BuildContext context) 
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false, 
            title: Text('Choose below'),
            elevation: Theme.of(context).platform == TargetPlatform.iOS? 0.0 : 4.0
          ), //automaticallyImplyLeading: whether to assume AppBar actions
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
  
  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchProducts, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Item list'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
      body: _buildProductsList(), // an argument here would override the one in Constructor
    );
  }
}