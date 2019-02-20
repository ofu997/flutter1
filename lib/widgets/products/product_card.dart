import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';



class ProductCard extends StatelessWidget{
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePrice(){
    return  Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // For a row, centers it horizontally
            children: <Widget>[
              TitleDefault(product.title),
              SizedBox(
                width: 33.0,
              ),
              PriceTag(product.price.toString())
            ],
          ));
  }

  Widget _buildIcons(BuildContext context){
    return       
    ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
      return 
        ButtonBar(
          alignment: MainAxisAlignment.center, 
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).primaryColorLight,
                //child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(
                      context,
                      '/product/' + model.allProducts[productIndex].id
                    ),
            ),
            IconButton(
                  icon: Icon(model.allProducts[productIndex].isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    model.selectProduct(model.allProducts[productIndex].id);
                    model.toggleProductFavoriteStatus();
                  },
                ),
          ]
        );   
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/food.jpg'),
          ),
          _buildTitlePrice(),
          AddressTag('Union Square, NYC'),
          Text(product.userEmail),
          _buildIcons(context)
        ],
      )
    );
  }
} 
