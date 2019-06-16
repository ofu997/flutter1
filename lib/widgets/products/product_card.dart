import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';



class ProductCard extends StatelessWidget{
  final Product product;
  //final int productIndex;

  ProductCard(this.product);
  
  Widget _buildTitlePrice(){
    return  Container(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center, // For a row, centers it horizontally
            children: <Widget>[
              Expanded(flex: 2, child: Column()),
              Expanded(flex: 4,child: TitleDefault(product.title),),              
              SizedBox(
                width: 33.0,
              ),
              PriceTag(product.price.toString()),
              Expanded(flex: 2, child: Column()),
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
              onPressed: () {
                model.selectProduct(product.id);
                Navigator
                    .pushNamed<bool>(context,
                      '/product/' + product.id)
                    .then((_) => model.selectProduct(null));                  
              },                    
            ),
            IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    model.selectProduct(product.id);
                    model.toggleProductFavoriteStatus(model.selectedProduct);
                  },
                ),
          ]
        );   
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.amber[200],
                blurRadius: 20.0,
                
              ),
            ]
          ),
      child: Card(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Hero(
              tag: product.id,
              child: FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/food.jpg'),
              ),
            ),          
            _buildTitlePrice(),
            SizedBox(height: 10.0),
            AddressTag(product.location.address),
            //Text(product.userEmail),
            Text(product.dateTime),
            _buildIcons(context)
          ],
        )
      ),
    );

  }
} 

