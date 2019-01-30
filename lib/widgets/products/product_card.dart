import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
class ProductCard extends StatelessWidget{
  final Map<String, dynamic> product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePrice(){
    return  Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // For a row, centers it horizontally
            children: <Widget>[
              TitleDefault(product['title']),
              SizedBox(
                width: 33.0,
              ),
              PriceTag(product['price'].toString())
            ],
          ));
  }

  Widget _buildIcons(BuildContext context){
    return       ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).primaryColorLight,
            //child: Text('Details'),
            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/product/' + productIndex.toString(),
                )),
        IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.red,
            //child: Text('Details'),
            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/product/' + productIndex.toString(),
                )),
      ]
    );
  }

  @override
    Widget build(BuildContext context) {
       
      return Card(
        child: Column(children: <Widget>[
      Image.asset(product['image']),
      _buildTitlePrice(),
      AddressTag('Union Square, NYC'),
      _buildIcons(context)
    ]
  )
);
    }
} 