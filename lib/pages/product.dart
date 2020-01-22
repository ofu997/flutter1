import 'package:flutter_web/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/title_default.dart';
// import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
// import '../scoped-models/main.dart';
import 'package:map_view/map_view.dart';
import '../widgets/products/product_fab.dart';


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

  Widget _buildFieldLabels(String label){
    return
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 25.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5.0)),
              child: Text(label)
            ),
          ],
        );
  }

  Widget _buildAddressPriceRow(String address, double price) {
    List<String> addressArray = address.split(',');

    return Column(children: <Widget>
      [
        _buildFieldLabels("Address:"),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 25.0,),     
            
              
                GestureDetector(
                  onTap: _showMap,
                  // () {
                  //   FocusScope.of(context).requestFocus(
                  //     FocusNode()
                  //   ); //instantiates an empty focus node, looks at form elements
                  //   _showMap;              
                  // },
                  child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: <Widget>[

                      for (var item in addressArray) 
                      Text(
                        item,
                        style: 
                          TextStyle(
                            fontFamily: 'NotoSans',
                            color: Colors.black, 
                            fontSize: 16.0,
                          )                

                      )
                    ],
                  ), 
                  // for backup, this follows child: 
                  // Text(
                  //   address, 
                  //   style: TextStyle(fontFamily: 'NotoSans',color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.w100),
                  // )
                ),
              
                      
          ],
        ),      
        SizedBox(height: 25.0),
        _buildFieldLabels("Price:"),
        Row(         
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: <Widget>[
            SizedBox(width: 25.0,),
            Text(
              '\$' + price.toString(),
              style: TextStyle(fontSize: 16.0, fontFamily: 'NotoSans', color: Colors.black),
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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 256.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(product.title, style: TextStyle(fontFamily: 'Pacifico')),
                  background: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      image: NetworkImage(product.image),
                      height: 300.0,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/food.jpg'),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 50.0,),
                    _buildFieldLabels("Title:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      SizedBox(width: 25.0,),                  
                        TitleDefault(product.title),
                      ], 
                    ),
                    SizedBox(height: 25.0,),
                    _buildAddressPriceRow(
                        product.location.address, product.price
                    ),
                    SizedBox(height: 75.0,),
                    _buildFieldLabels("Description:"),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        product.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 150.0),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: ProductFAB(product),            
      ),
    );
  }
}