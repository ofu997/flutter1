import 'package:flutter/material.dart';
import './pages/product.dart';

class Products extends StatelessWidget {
  // final: the data is set from outside, triggers a build and replace
  final List<Map<String,String>> products;
  Products([this.products]){
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index){
    return Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(products[index]['image']),
                      Text(products[index]['title']),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Details'),
                            onPressed: () => Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (BuildContext context) => ProductPage(
                                  products[index]['title'],products[index]['image']
                                ),
                              ),
                            ),
                          ),
                        ]
                      )
                    ]
                  )
                );
  }

  Widget _buildProductList(){// exports widget
    Widget productCard = Center(
    child: Text('No product found, please add one'),
    );
    if(products.length >0){
      productCard =  ListView.builder(// conditional rendering
      itemBuilder: _buildProductItem,
      itemCount: products.length,// how many items will be built/displayed
      );
    }
    return productCard;// we must return something, such as Container(), because Widget build() requires it.
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build() ' + DateTime.now().toIso8601String());
    return _buildProductList();
  }
}

/* listView(children: ) is good for static number of items
Using builder.(...) allows dynamic and longer lists. it can also destroy items out of view*/
