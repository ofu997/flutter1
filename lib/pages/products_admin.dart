import 'package:flutter_web/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return 
    Drawer(// menu square UI
      child: Column(
        children: <Widget>[
          AppBar(// what shows up when hamburger menu is clicked
            automaticallyImplyLeading: false,
            title: Text('Choose below', style: TextStyle(fontFamily: 'Pacifico')),
            elevation: Theme.of(context).platform == TargetPlatform.iOS? 0.0 : 4.0,
          ), //automaticallyImplyLeading: whether to assume AppBar actions
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('All items'),
            onTap: () {// change parameters to key since it requires the page
              Navigator.pushReplacementNamed(context,'/products');
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Map'),
              onTap: (){
                Navigator.pushReplacementNamed(context, '/map');
              } 
          ,),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar:  AppBar(
          title: Text('Manage items', style: TextStyle(fontFamily: 'Pacifico')),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          bottom: TabBar(tabs: <Widget>[
            Tab(icon: Icon(Icons.library_books), text: 'My items',),            
            Tab(icon: Icon(Icons.create),text: 'Create item',),
          ],),
        ),
        body: TabBarView(// reads TabBar events and displays content
          children: <Widget>[
          ProductListPage(model),            
          ProductEditPage(),
          ],
        ),
      )
    );
  }
}