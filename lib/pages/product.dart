import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'union square, san francisco',
            style: TextStyle(
                fontSize: 16.0, fontFamily: 'Cottage', color: Colors.blueGrey),
            //textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text('|', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0)),
        ),
        Text('\$' + price.toString(),
          style: TextStyle(fontSize: 16.0, fontFamily: 'Cottage', color: Colors.blueGrey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // determines if user can leave the page and with what value
        onWillPop: () {
          print('back button pressed');
          Navigator.pop(context, false); // (context, false): user can leave without deleting. (context): will delete.
          return Future.value(false); // (false) because we don't want to start another pop event
        }, 
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
          final Product product = model.allProduct[productIndex];
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title + ' details page'),
            ),
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.center,// vertical centering
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(product.image),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(product.title),
                ),
                _buildAddressPriceRow(product.price),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text(product.description,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ]
            ),
          );
        }
      )
    );
  }
}
