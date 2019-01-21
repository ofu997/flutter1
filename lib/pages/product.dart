import 'package:flutter/material.dart';
import 'dart:async';
class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(// determines if user can leave the page and with what value
      onWillPop: (){
        print('back button pressed');
        Navigator.pop(context, false);// (context, false): user can leave without deleting. (context): will delete.
        return Future.value(false);// (false) because we don't want to start another pop event
      },
      child: Scaffold(
          // we can put UI elements here
          appBar: AppBar(
            title: Text(title),
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,// vertical centering
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(imageUrl),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(title),
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Delete'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )),
              // makes a Back button like the automated one seen in AppBar
            ],
          )
          // Center(child: Text('You are on ProductPage'),) // an argument here would override the one in Constructor
      ),
    );
  }
}
