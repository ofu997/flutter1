import 'package:flutter/material.dart';
// import './pages/product.dart';

class Products extends StatelessWidget {
  // final: the data is set from outside, triggers a build and replace
  final List<Map<String, dynamic>> products;
  // final Function deleteProduct;

  Products(this.products) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Image.asset(products[index]['image']),
      Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // For a row, centers it horizontally
            children: <Widget>[
              Text(
                products[index]['title'],
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'Cottage'), //
              ),
              SizedBox(
                width: 33.0,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    '\$${products[index]['price'].toString()}',
                    style: TextStyle(color: Colors.black),
                  )
                ),
            ],
          )),
      DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
          child: Text('Union Square, New York'),
        ),
      ),
      ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).primaryColorLight,
            //child: Text('Details'),
            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/product/' + index.toString(),
                )),
        IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.red,
            //child: Text('Details'),
            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/product/' + index.toString(),
                )),
      ])
    ]));
  }

  Widget _buildProductList() {
    // exports widget
    Widget productCard = Center(
      child: Text('No product found, please add one'),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        // conditional rendering
        itemBuilder: _buildProductItem,
        itemCount: products.length, // how many items will be built/displayed
      );
    }
    return productCard; // we must return something, such as Container(), because Widget build() requires it.
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build() ' + DateTime.now().toIso8601String());
    return _buildProductList();
  }
}

/* listView(children: ) is good for static number of items
Using builder.(...) allows dynamic and longer lists. it can also destroy items out of view*/
