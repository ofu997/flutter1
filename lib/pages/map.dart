import 'package:flutter_web/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
//import '../models/auth.dart';
//import '../widgets/ui_elements/adaptive_progress_indicator.dart';
//import 'dart:convert';
import 'dart:async';

import 'package:map_view/map_view.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart' as geoloc;

// import '../helpers/ensure-visible.dart';
// import '../../models/location_data.dart';
// import '../../models/product.dart';
// import '../shared/global_config.dart';



class Map extends StatelessWidget {
  final MainModel model;

  Map(this.model);

  // @override
  // State<StatefulWidget> createState() {
  //   return _Map();
  // }


//class _Map extends State<Map>{
  // @override
  // initState(){
  //   print('in map');
  //   widget.model.fetchAllLocations();
  //   widget.model.fetchProducts();
  //   super.initState();
  //   // print('finished initState');
  // }

  // @override
  // Widget notusedfornowbuild(BuildContext context) {
  //   //int index, MainModel model
  // //   final StaticMapProvider staticMapViewProvider = StaticMapProvider(mapAPIKey);
  // //   final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
  // //   [Marker('position', 'Position', 45, 0)],
  // //   center: Location(45, 0),
  // //   width: 500,
  // //   height: 300,
  // //   maptype: StaticMapViewType.roadmap
  // // );
  //   return ScopedModelDescendant<MainModel>(
  //     builder:  (BuildContext context, Widget child, MainModel model){
  //       return Column(
  //         children: <Widget>[
  //           GestureDetector(
  //             onTap: _showMap,
  //             child: Text('Show Map'), 
  //           ),

  //           Text(model.allProducts[0].location.latitude.toString()),
  //           Text(model.allProducts[0].location.longitude.toString()),
  //           Text(model.allLatLongs[0].lat.toString()),
  //           Text(model.allLatLongs[0].long.toString()),
  //         ],
  //       );
  //     }
  //   );
  // }

  void _showMap() {
    // return 
    // WillPopScope(
    //   // determines if user can leave the page and with what value
    //   onWillPop: () {
    //     print('back button pressed');
    //     Navigator.pop(context, false); 
    //     return Future.value(false);
    //   },
    //   child:      
    //       // (fals
    //   ScopedModelDescendant<MainModel>(
    //     builder:  (BuildContext context, Widget child, MainModel model){
    //final List<Marker> markers = <Marker>[]; 
    //   Marker('position', 'Position', product.location.latitude,
    //   product.location.longitude)
    // ];

    print('in _showMap()');

    //final myMapView = MapView();

    final cameraPosition = CameraPosition(
        Location(40.0, -90.0), 1.0
      );

    final mapView = MapView();
    // return Column(
    //   children: <Widget>[

    //   ],
    // );
    mapView.show(
      
      MapOptions(
          initialCameraPosition: cameraPosition,
          mapViewType: MapViewType.normal,
          title: ''
      ),
      toolbarActions: [
        ToolbarAction('Close', 1),
      ],
    );

          for (var exlatlong in model.allLatLongs){
        //method for manually hard code markers: mapView.setMarkers(markers);
        mapView.addMarker(new Marker('a','b',exlatlong.lat, exlatlong.long));
      }       

    mapView.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapView.dismiss();
      }
    });

    mapView.onMapReady.listen((_) {
      print('in mapView.onMapReady.listen()');
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
      // determines if user can leave the page and with what value
      onWillPop: () {
        print('back button pressed');
        Navigator.pop(context, false); 
        return Future.value(false);
      },
      child:      
      ScopedModelDescendant<MainModel>(
        builder:  (BuildContext context, Widget child, MainModel model){
          
          return
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: _showMap,

                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Show Map'), 
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }  

}

