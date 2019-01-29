import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  final String address = 'union square, San Francisco';

  ProductPage(this.title, this.imageUrl, this.description, this.price);

  Widget _buildDescriptionPriceRow(){
    return      Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0), 
                        child: Text(
                        description,
                        style: TextStyle(fontSize: 16.0),
                      //textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('|',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 8.0)),
                    ),
                    Text(price.toString(), style: TextStyle(fontSize: 16.0)),
                  ],
                );
  }

  @override
  Widget build(BuildContext context) {
     
    return WillPopScope(
        // determines if user can leave the page and with what value
        onWillPop: () {
          print('back button pressed');
          Navigator.pop(context,false); // (context, false): user can leave without deleting. (context): will delete.
          return Future.value(false); // (false) because we don't want to start another pop event
        },
        child: Scaffold(
          // we can put UI elements here
          appBar: AppBar(
            title: Text(title + ' details page'),
          ),
          body: Column(
              // mainAxisAlignment: MainAxisAlignment.center,// vertical centering
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(imageUrl),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(title),
                ),
                _buildDescriptionPriceRow(),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text(address,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ]),
        )
    );
  }
}
