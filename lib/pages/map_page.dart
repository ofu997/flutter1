import 'package:flutter_web/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:second_app/models/latlong.dart';
// import 'package:second_app/pages/product_list.dart';
import '../scoped-models/main.dart';

// import '../models/latlong.dart';
// import '../scoped-models/connected_products.dart';
// import '../models/product.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

class MapPage extends StatefulWidget {
  final MainModel model;

  MapPage(this.model);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  @override
  void initState(){  
    widget.model.allProducts;
    super.initState();
  }

  double doubleZoom=0.0;
  Set<Marker> allMarkers=Set();
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    
    void zoomIn(){
      setState((){
      doubleZoom+=1.0;
      //  print('doubleZoom is: '+doubleZoom.toString());
      });
    }

    double getZoom(){
      return doubleZoom;      
    }    

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Maps', style: TextStyle(fontFamily: 'Pacifico')),
      ),
      body: Stack(
        children: 
          [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(40.7128, -74.0060), zoom: doubleZoom),
                minMaxZoomPreference: MinMaxZoomPreference.unbounded,            
                markers: getMarkers(),//Set<Marker>.of(getMarkers),
                onMapCreated: mapCreated,
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: goBack,
                child: Container(
                  height: 40.0,
                  width: 40.0,   
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red
                  ),   
                  child: Icon(Icons.arrow_back, color: Colors.white), 
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: InkWell(
            //     onTap: movetoBoston,
            //     child: Container(
            //       height: 40.0,
            //       width: 40.0,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20.0),
            //         color: Colors.green
            //       ),
            //       child: Icon(Icons.forward, color: Colors.white),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: zoomIn,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            )
          ]
      ),
    );
  }



  void goBack(){
    Navigator.pushNamed(context, '/products');
    //Navigator.of(context).pop();
  }  

  void mapCreated(controller) {
    setState((){
      _controller = controller;
    });
  }

  Set<Marker> getMarkers(){
      print('getMarkers ${widget.model.allProducts.length}');
      for(var product in widget.model.allProducts)
        {   
          allMarkers.add(
            Marker(
              markerId: MarkerId(product.title),
              draggable: false,
              position: LatLng(product.location.latitude, product.location.longitude),
              infoWindow: InfoWindow(title: product.title, snippet: product.description),
            )
          );
        }
    return Set.of(allMarkers);
  }

  // movetoBoston() {
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
  //   ));
  // }

  // movetoNewYork() {
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
  //   ));
  // }
}