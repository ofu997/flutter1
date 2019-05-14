import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';
import 'package:map_view/map_view.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  void _showMap() {
	    final List<Marker> markers = <Marker>[
      Marker('position', 'Position', product.location.latitude,
          product.location.longitude)
    ];
    final cameraPosition = CameraPosition(
        Location(product.location.latitude, product.location.longitude), 14.0);
    final mapView = MapView();
    mapView.show(
        MapOptions(
            initialCameraPosition: cameraPosition,
            mapViewType: MapViewType.normal,
            title: 'Product Location'),
        toolbarActions: [
          ToolbarAction('Close', 1),
        ]);
    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

   Widget _buildAddressPriceRow(String address, double price) {
    return Column(children: <Widget>
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: 
              GestureDetector(
                onTap: _showMap,
                child: Text(
                  address, 
                  style: TextStyle(fontFamily: 'Oswald',color: Colors.blueGrey, fontSize: 14.0,fontWeight: FontWeight.w100),
                )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0)),
            ),
            // Text(
            //   '\$' + price.toString(),
            //   style: TextStyle(fontSize: 16.0, fontFamily: 'Cottage', color: Colors.blueGrey),
            // )
          ],
        ),
        Row(         
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
            Text(
              '\$' + price.toString(),
              style: TextStyle(fontSize: 16.0, fontFamily: 'Cottage', color: Colors.blueGrey),
            )
          ],
        )
      ]

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
        child: Scaffold(
            appBar: AppBar(
              title: Text(product.title + ' details page'),
            ),
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.center,// vertical centering
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(product.image),
                  height: 300.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/food.jpg'),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(product.title),
                ),
                _buildAddressPriceRow(product.location.address, product.price),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text(
                      product.description,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center),
                ),
              ]
            ),
          ),
    );
  }
}

//     ScopedModelDescendant<MainModel>(
//     builder: (BuildContext context, Widget child, MainModel model) {
//     //final Product product = model.allProducts;
//     return 
//   }
// )
